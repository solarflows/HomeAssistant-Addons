# 上游 alist-tvbox 工作状态分析

> 本文件记录上游 power721/alist-tvbox 的完整架构，供 HA addon 适配参考。

上游仓库：[power721/alist-tvbox](https://github.com/power721/alist-tvbox)
AList 内核：[power721/PowerList](https://github.com/power721/PowerList)
基础镜像：[haroldli/alist-base](https://hub.docker.com/r/haroldli/alist-base)
上游文档：`CLAUDE.md`、`docs/DOCKER_SCRIPTS_REFACTOR.md`、`docker/scripts/README.md`

---

## 1. 项目概述

Spring Boot 4 (Java 21) + Vue 3 系统：
- TVBox VOD API 后端
- 云存储聚合（AList 内核以 subprocess 方式运行）
- Telegram 搜索引擎、直播聚合
- 插件 + 过滤器系统
- 离线下载（115/迅雷/广雅）

基础包：`cn.har01d.alist_tvbox`

---

## 2. Docker 镜像变体

| 镜像名 | Dockerfile | INSTALL | 模式 | 说明 |
|--------|-----------|---------|------|------|
| xiaoya-tvbox | Dockerfile-xiaoya | xiaoya | 完整 | 小雅集成版，含远程索引/数据库同步 |
| xiaoya-tvbox-hostmode | Dockerfile-host | hostmode | 完整 | host 网络模式 |
| alist-tvbox | Dockerfile | new | 精简 | 标准版，无小雅功能 |
| alist-tvbox (native) | Dockerfile-native | native | 精简 | GraalVM Native Image |

---

## 3. 基础镜像 haroldli/alist-base

提供运行时环境，所有变体 FROM 此镜像：

```
/jre/bin/java                    ← JRE 21（完整安装，非 symlink）
/h2-2.1.214.jar                  ← 旧版 H2 数据库工具（upgrade_h2 用）
/bin/busybox-extras              ← httpd 服务（xiaoya 模式）
/usr/sbin/nginx                  ← 反向代理（xiaoya 模式）
/opt/alist/alist                 ← AList 二进制（可选，由 haroldli/alist 提供）
```

---

## 4. Dockerfile 结构（以 Dockerfile-xiaoya 为例）

```dockerfile
FROM haroldli/alist-base:latest

ENV MEM_OPT="-Xmx1024M" ALIST_PORT=5344 INSTALL=xiaoya

# 资源文件全部 COPY 到 /（根目录），不是 /data/
COPY config/alist.json /
COPY docker/scripts/ /docker/scripts/
COPY data/tvbox.zip /
COPY data/115.index.zip /
COPY data/index.share.zip /
COPY data/cat.zip /
COPY data/pg.zip /
COPY data/zx.zip /
COPY data/data.zip /
COPY data/nginx.full.conf /etc/nginx/http.d/default.conf
COPY data/base_version /
COPY target/application/ ./                    ← Spring Boot layertools
COPY data/version /app_version                 ← 上游 CI 构建时生成

VOLUME ["/www/static"]                         ← 唯一的 VOLUME

EXPOSE 4567 80
ENTRYPOINT ["/docker/scripts/entrypoint.sh"]
CMD ["81", "--spring.profiles.active=production,xiaoya"]
```

**关键设计：**
- `VOLUME` 只有 `/www/static`，`/data/` 不是卷
- 资源文件在 `/`（镜像层），容器重建时自动恢复
- `data/version` → `/app_version`（CI 构建时生成，不在 git 中）
- `haroldli/alist-base` 提供 `/docker.version`

---

## 5. 容器启动流程（entrypoint.sh）

```sh
set -e                                        # 任何命令失败即退出

# 加载依赖
. /docker/scripts/lib/common.sh
. /docker/scripts/lib/proxy.sh

# 初始化
load_custom_env
setup_env_proxy
chmod a+x /docker/scripts/*.sh /docker/scripts/lib/*.sh
ensure_dir /data/log

# 根据 INSTALL 选择初始化脚本
case "$INSTALL" in
  xiaoya|hostmode)
    /docker/scripts/init-xiaoya.sh 2>&1 | tee /data/log/init.log
    ;;
  new|docker|*)
    /docker/scripts/init-alist.sh 2>&1 | tee /data/log/init.log
    ;;
esac

# 启动 httpd（xiaoya 模式，端口 81）
if [ -f /bin/busybox-extras ]; then
  /bin/busybox-extras httpd -p 81 -h /www &
fi

# 启动 nginx（端口 80）
if [ -f /usr/sbin/nginx ]; then
  /usr/sbin/nginx
fi

# 创建 Spring Boot 配置目录
mkdir -p /data/atv/config/

# 启动 Java 应用（前台运行）
exec /jre/bin/java "$MEM_OPT" \
  -Duser.timezone=Asia/Shanghai \
  -Dspring.config.additional-location=file:/data/atv/config/ \
  -cp BOOT-INF/classes:BOOT-INF/lib/* \
  cn.har01d.alist_tvbox.AListApplication "$@"
```

**注意：** 上游用 `-cp BOOT-INF/classes:BOOT-INF/lib/*`（直接 JAR 解压），不是 layertools 目录结构。

---

## 6. 服务架构

### 6.1 httpd（busybox，端口 81）

提供小雅静态资源和 CGI 脚本服务：

```
/www/
├── cgi-bin/
│   ├── search          ← CGI 搜索脚本（从 data.zip 解压）
│   ├── sou             ← 搜索入口
│   ├── whatsnew        ← 最新资源
│   └── header.html     ← 页面头部
├── tvbox/              ← TvBox 订阅源（download_tvbox 从网络下载）
├── cat/                ← 猫影视资源（cat.zip 解压）
├── pg/                 ← PG 资源（pg.zip 解压）
├── zx/                 ← ZX 资源（zx.zip 解压）
└── mobi/               ← 移动端资源（xiaoya_first_init 解压 mobi.tgz）
```

`/www/` 不在 VOLUME 中，每次容器启动由 `extract_resource_zips()` 和 `xiaoya_first_init()` 重新生成。

### 6.2 nginx（端口 80）

反向代理到 AList:5244，配置来自 `data/nginx.full.conf`：

```nginx
server {
    listen 80 default_server;

    # 图片代理缓存（/image/ 路径，支持豆瓣/TMDB 等 CDN）
    location ~ ^/image/ { proxy_pass $image_target; proxy_cache image_cache; }

    # 视频直链（不缓存，保持 Range 请求头）
    location /d/ { proxy_pass http://127.0.0.1:5244/d/; proxy_buffering off; }

    # WebDAV
    location /dav { proxy_pass http://127.0.0.1:5244/dav; }

    # 安全限制（屏蔽管理/写操作 API）
    location ^~ /@manage       { deny all; }
    location ^~ /api/admin     { deny all; }
    location ^~ /api/fs/copy   { deny all; }
    location ^~ /api/fs/move   { deny all; }
    location ^~ /api/fs/mkdir  { deny all; }
    location ^~ /api/fs/put    { deny all; }
    location ^~ /api/fs/remove { deny all; }
    location ^~ /api/fs/rename { deny all; }

    # 默认代理到 AList
    location / { proxy_pass http://127.0.0.1:5244; }
}
```

**注意：** 上游用 Alpine，nginx 配置在 `/etc/nginx/http.d/default.conf`。Debian 用 `/etc/nginx/sites-enabled/`。

### 6.3 Spring Boot 应用（端口 4567）

AList-TvBox 管理后台，启动参数：

```bash
java -Xmx1024M \
  -Duser.timezone=Asia/Shanghai \
  -Dspring.config.additional-location=file:/data/atv/config/ \
  -cp BOOT-INF/classes:BOOT-INF/lib/* \
  cn.har01d.alist_tvbox.AListApplication 81 \
  --spring.profiles.active=production,xiaoya
```

- 端口 4567：管理后台 Web UI + API
- 内部管理 AList 子进程（端口 5244）
- 两个数据库：H2（`/data/atv`）+ SQLite（`/opt/alist/data/data.db`）

### 6.4 AList 内核（端口 5244）

由 Spring Boot 应用以 subprocess 方式启动和管理：
- 二进制：`/opt/alist/alist`
- 数据目录：`/opt/alist/data/`（含 data.db、config.json）
- 不直接暴露端口，通过 nginx:80 代理访问

---

## 7. 数据目录布局

### /data/（容器可写层，Docker 中非卷）

```
/data/
├── alist/              ← AList 数据（symlink 目标）
│   ├── data.db         ← SQLite 数据库（小雅数据）
│   ├── config.json     ← AList 配置
│   └── log/            ← AList 日志
├── atv/                ← Spring Boot 数据
│   ├── data.mv.db      ← H2 数据库文件
│   ├── data.trace.db   ← H2 追踪文件
│   └── config/         ← Spring Boot 外部配置
├── index/              ← 小雅索引文件
│   ├── index.txt       ← 合并索引
│   ├── index.video.txt ← 视频索引
│   ├── index.book.txt  ← 书籍索引
│   ├── index.music.txt ← 音乐索引
│   ├── index.share.txt ← 分享索引
│   └── version.txt     ← 索引版本
├── index115/           ← 115 索引
├── store/              ← TvBox 数据
├── log/                ← 初始化日志（init.log）
├── backup/             ← 备份目录
├── cat/                ← 用户自定义猫影视资源覆盖
├── pg/                 ← 用户自定义 PG 资源覆盖
├── h2.version.txt      ← H2 升级标记（upgrade_h2 成功后创建）
└── database.zip        ← 数据库备份（restore_database 用）
```

### /（镜像层，不可变）

```
/
├── data.zip            ← 初始数据库 + 索引种子（84MB）
├── tvbox.zip           ← TvBox 订阅源
├── 115.index.zip       ← 115 索引种子
├── index.share.zip     ← 分享索引种子
├── cat.zip             ← 猫影视资源
├── pg.zip              ← PG 资源
├── zx.zip              ← ZX 资源
├── base_version        ← 电影数据库版本号
├── alist.json          ← AList config.json 模板
├── app_version         ← 应用版本号（CI 构建时生成）
├── docker.version      ← Docker 版本号（haroldli/alist-base 提供）
├── h2-2.1.214.jar      ← 旧版 H2 工具（haroldli/alist-base 提供）
├── /jre/bin/java       ← JRE（haroldli/alist-base 提供）
├── /opt/alist/alist    ← AList 二进制
├── /opt/atv/           ← Spring Boot layertools 目录
│   ├── application/    ← BOOT-INF/classes
│   ├── dependencies/   ← BOOT-INF/lib
│   ├── snapshot-dependencies/
│   └── spring-boot-loader/
├── /docker/scripts/    ← 初始化脚本
└── /etc/nginx/         ← nginx 配置
```

---

## 8. 初始化脚本架构

### 8.1 脚本调用关系

```
entrypoint.sh
  ├── lib/common.sh      ← 日志、错误处理、ensure_dir、safe_symlink
  ├── lib/proxy.sh       ← 代理配置
  └── case $INSTALL:
      ├── init-alist.sh   ← 标准模式
      │   ├── lib/database.sh   ← upgrade_h2、restore_database
      │   ├── lib/version.sh    ← is_initialized、mark_initialized、compare_version
      │   └── init-common.sh    ← init_directories、setup_symlinks、extract_resource_zips、seed_index115、download_tvbox
      │
      └── init-xiaoya.sh  ← 小雅模式
          ├── lib/database.sh
          ├── lib/download.sh   ← download_with_proxy、download_and_extract_zip
          ├── lib/version.sh
          └── init-common.sh
```

### 8.2 关键函数

#### is_initialized / mark_initialized（lib/version.sh）

```sh
is_initialized() {
  [ -f "/opt/alist/data/.init" ] && [ "$(head -n1 /opt/alist/data/.init)" = "1" ]
}
mark_initialized() {
  echo "1" > /opt/alist/data/.init
}
```

标记文件：`/opt/alist/data/.init`（内容 "1"）

#### upgrade_h2（lib/database.sh）

升级 Spring Boot 的 H2 数据库版本（从旧版导出再导入新版）：

```sh
upgrade_h2() {
  # 已升级则跳过
  [ -f /data/h2.version.txt ] && return 0

  file=/opt/atv/data/data
  [ -f /data/atv.mv.db ] && file=/data/atv

  # 用旧版 H2 导出
  /jre/bin/java -cp /h2-2.1.214.jar org.h2.tools.Script \
    -url jdbc:h2:file:$file -user sa -password password -script backup.sql

  # 用新版 H2 导入
  /jre/bin/java -cp /opt/atv/BOOT-INF/lib/h2-*.jar org.h2.tools.RunScript \
    -url jdbc:h2:file:$file -user sa -password password -script backup.sql

  echo "2.3.232" > /data/h2.version.txt
}
```

**前提：** 需要 `/jre/bin/java` 和 `/h2-2.1.214.jar` 存在。无旧数据库时 export 失败 + `set -e` 会杀死脚本。

#### restore_database（lib/database.sh）

从 `/data/database.zip` 备份恢复 H2 数据库。首次安装时无备份，跳过。

#### init_directories / setup_symlinks（init-common.sh）

```sh
init_directories() {
  ensure_dir /data/atv /data/index /data/backup /data/log /www
}
setup_symlinks() {
  [ -d /index ] && rm -rf /index
  safe_symlink /data/index /index
  safe_symlink /data/config /opt/atv/config
  safe_symlink /data/log /opt/atv/log
}
```

#### extract_resource_zips（init-common.sh）

解压 cat/pg/zx 资源到 `/www/`（幂等，目录存在则跳过）。

#### seed_index115（init-common.sh）

从 `/115.index.zip` 解压到 `/data/index115/`（目录存在则跳过）。

#### download_tvbox（init-common.sh）

从 GitHub/d.har01d.cn 下载 `tvbox.zip` 解压到 `/www/tvbox/`。

#### xiaoya_first_init（init-xiaoya.sh）

首次初始化（`is_initialized` 返回 false 时执行）：

1. `ensure_dir /var/lib/pxg /www/cgi-bin`
2. 解压 `/var/lib/data.zip`（含 data.db、update.sql、CGI 脚本、mobi.tgz）
3. 移动 `data.db` → `/opt/alist/data/data.db`
4. 配置 CGI 脚本（search、sou、whatsnew、header.html）
5. 创建 `config.json`（从 `/alist.json` 模板，随机生成 secret）
6. 解压移动端资源（mobi.tgz → /www/mobi/）
7. `sqlite3 /opt/alist/data/data.db ".read /update.sql"`（导入小雅数据）
8. `download_tvbox()`
9. `update_movie()`（解压电影数据到 /data/atv/）

#### update_xiaoya_data（init-xiaoya.sh）

每次启动执行，从网络更新：

1. 下载 `update.zip`（密码 abcd）→ 解压获取 `update.sql`
2. 清空 AList 数据库（drop x_storages/x_meta/x_setting_items）
3. `.read update.sql`（重建数据库）
4. 下载 `index.zip` → 更新 `/data/index/` 索引文件
5. 处理分享索引（`index.share.zip`）
6. 写入版本记录到数据库

---

## 9. init-xiaoya.sh 主流程

```sh
set -e

# 加载依赖
. /docker/scripts/lib/common.sh
. /docker/scripts/lib/database.sh
. /docker/scripts/lib/download.sh
. /docker/scripts/lib/version.sh
. /docker/scripts/init-common.sh

cat /app_version                              # 打印版本（文件不存在则 set -e 退出）
version=$(head -n1 /docker.version)           # 读取版本

# 数据库操作
upgrade_h2                                    # H2 升级（无旧数据库时失败 + set -e 退出）
restore_database                              # 从备份恢复

mkdir -p /var/cache/nginx/image

# 初始化或更新
if is_initialized; then
  log_info "Already initialized, running update tasks"
  update_movie                                # 检查电影数据版本
else
  log_info "Running first-time xiaoya initialization"
  init_directories
  setup_symlinks
  xiaoya_first_init
  mark_initialized
fi

# 每次启动都执行
extract_resource_zips                         # 解压 cat/pg/zx
seed_index115                                 # 种子 115 索引
update_xiaoya_data                            # 从网络更新索引和数据库

log_info "Xiaoya initialization completed successfully"
```

---

## 10. init-alist.sh 主流程（标准模式）

```sh
set -e

# 同样加载依赖
cat /app_version
upgrade_h2
restore_database
init_directories
setup_symlinks

if is_initialized; then
  log_info "Already initialized, skipping first-time setup"
else
  # 创建 config.json
  # 显示 AList 管理员密码
  # download_tvbox()
  mark_initialized
fi

extract_resource_zips
seed_index115
```

比 xiaoya 模式少了 `update_movie` 和 `update_xiaoya_data`。

---

## 11. 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `INSTALL` | new | 安装模式：new/docker/xiaoya/hostmode/native |
| `MEM_OPT` | -Xmx1024M | JVM 内存参数 |
| `ALIST_PORT` | 5344 | AList 外部端口 |

---

## 12. 端口

| 端口 | 服务 | 说明 |
|------|------|------|
| 4567 | Spring Boot | TvBox 管理后台 Web UI + API |
| 80 | nginx | AList 面板（反向代理 → 5244） |
| 5244 | AList | AList 内核（Spring Boot 子进程管理） |
| 81 | httpd | 小雅静态资源 + CGI 服务 |

CMD 参数 `"81"` 传给 entrypoint.sh 作为 httpd 端口。

---

## 13. CI 构建

### build.yaml（master 分支触发）

```yaml
# 生成 data/version（不在 git 中）
echo $((($(date +%Y) - 2023) * 366 + $(date +%j))).$(date +%H%M) > data/version
echo "${{ github.event.head_commit.message }}" >> data/version
```

### release.yaml（tag 触发）

```yaml
echo "${{ github.ref_name }}" > data/version
```

---

## 14. 已知的上游设计约束

| 项目 | 约束 |
|------|------|
| `set -e` | entrypoint.sh 和所有 init 脚本顶部都有，任何命令失败即退出 |
| `/app_version` | 必须存在，`cat /app_version` 失败会被 `set -e` 杀死 |
| `/docker.version` | 必须存在，同上 |
| `/jre/bin/java` | 必须存在且可执行（haroldli/alist-base 提供） |
| `/h2-2.1.214.jar` | 必须存在（haroldli/alist-base 提供） |
| VOLUME | 只有 `/www/static`，`/data/` 是容器可写层不是卷 |
| nginx 路径 | Alpine: `/etc/nginx/http.d/`，Debian: `/etc/nginx/sites-enabled/` |
| Java classpath | 上游用 `BOOT-INF/classes:BOOT-INF/lib/*`（直接解压 JAR） |

---

## 15. 上游构建链

```
openlistteam/openlist-base-image (Alpine + Java)
    ↓
haroldli/alist (PowerList fork, 添加 AList 二进制 + xiaoya 数据)
    ↓ 包含 /var/lib/data.zip（xiaoya 数据包，含 data.db、CGI 脚本等）
haroldli/alist-base (Dockerfile-base, 添加 JRE + H2 + Spring Boot)
    ↓ 包含 /jre/bin/java、/h2-2.1.214.jar、/docker.version
haroldli/xiaoya-tvbox (Dockerfile-xiaoya, 添加资源文件 + 脚本)
    ↓ 包含 /data.zip、/tvbox.zip、/cat.zip 等
```

### 各镜像提供的关键文件

| 文件 | 来源镜像 | 我们的替代方案 |
|------|---------|-------------|
| `/var/lib/data.zip` | haroldli/alist | COPY --from=alist-source |
| `/jre/bin/java` | haroldli/alist-base | symlink → Debian OpenJDK |
| `/h2-2.1.214.jar` | haroldli/alist-base | 从 Maven Central 下载 |
| `/docker.version` | haroldli/alist-base | 用构建参数生成 |
| `/app_version` | 构建时生成 | 用构建参数生成 |
| `/bin/busybox-extras` | haroldli/alist-base | Debian busybox 包 + symlink |
| `/data.zip` 等资源 | Dockerfile-xiaoya COPY | 从上游源码 stage COPY |
| `/opt/alist/alist` | haroldli/alist | COPY --from=alist-source |

### 构建脚本

| 脚本 | 用途 |
|------|------|
| `build-base.sh` | 构建 haroldli/alist-base（mvn + Dockerfile-base） |
| `build-docker.sh` | 构建标准版 alist-tvbox（INSTALL=new） |
| `build-xiaoya.sh` | 构建小雅版 xiaoya-tvbox（INSTALL=xiaoya） |
| `build-app.sh` | 本地直接运行（非 Docker） |
