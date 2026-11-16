---
name: create-addon
description: 新建 HA 加载项。从模板创建骨架目录，后续由 plan-addon 填充上游分析数据。
---

# 新建加载项指南

> **步骤 1**：按策略复制模板目录 → `cp -r .github/templates/<binary|upstream-image|source>/ <addon-slug>/`
> **步骤 2**：全局替换 `ADDON_SLUG` 为实际 slug
> **步骤 3**：运行 `plan-addon` 技能分析上游并核验 `analysis.yaml`
> **步骤 4**：依据 `analysis.yaml` 补齐 `config.yaml`、`Dockerfile` 及 `rootfs` 脚本
> **步骤 5**：本地 buildx 验证后推送到 main 分支，CI 自动触发构建

## 架构模板选型

仓库在 `.github/templates/` 维护 3 套生产级骨架模板（详见 [.github/templates/README.md](.github/templates/README.md)）：

| 模板路径 | 适用场景 | 核心特征 |
|---|---|---|
| `.github/templates/binary/` | 上游 Release 提供预编译二进制（推荐首选） | debian-base + S6 overlay + 自动多架构映射与下载重试 |
| `.github/templates/upstream-image/` | 上游环境极其复杂且已提供优质 Docker 镜像 | 无 S6 + dumb-init + ha-entrypoint 注入环境 |
| `.github/templates/source/` | 上游仅提供源码，需自主编译 | 多阶段构建（内置 GOPROXY 多代理容灾）+ debian-base 运行时 |

## 目录骨架结构 (以 binary 模板为例)

所有占位符统一使用 `ADDON_SLUG`：

```
.github/templates/binary/
├── analysis.yaml              # 上游分析产物（由 plan-addon 填充）
├── config.yaml                # 加载项基础清单
├── Dockerfile                 # 多架构下载与装配文件 (含规范 HEALTHCHECK)
├── version.yaml               # 版本与依赖追踪
├── rootfs/etc/cont-init.d/
│   └── 00-init.sh             # 纯本地离线秒级初始化与存量自愈探测
├── rootfs/etc/s6-overlay/s6-rc.d/
│   ├── ADDON_SLUG/            # 业务服务 longrun 拓扑 (需重命名为目标 <slug>)
│   │   ├── dependencies.d/
│   │   │   └── legacy-cont-init # 声明式依赖：强约束 cont-init 退出 0 后拉起
│   │   ├── finish             # 原生退出捕获与 5 次熔断保护器
│   │   ├── run                # 前台阻塞启动脚本 (exec 挂载)
│   │   └── type               # 文件内容为: longrun
│   └── user/
│       └── contents.d/
│           └── ADDON_SLUG     # 纳管注册点 (需同步重命名为目标 <slug>)
├── translations/
│   ├── en.yaml
│   └── zh-Hans.yaml
├── README.md
└── CHANGELOG.md               # 由 CI 自动生成与维护
```

## 快速上手命令

```bash
# 1. 复制模板（根据策略选用 binary, upstream-image 或 source）
cp -r .github/templates/binary/ <addon-slug>/

# 2. 全局替换占位符（config.yaml slug, Dockerfile, 00-init.sh, run, translations, README）

# 3. 若使用 binary 或 source 模板，重命名 S6 业务服务目录与 user contents 注册点：
mv <addon-slug>/rootfs/etc/s6-overlay/s6-rc.d/ADDON_SLUG \
   <addon-slug>/rootfs/etc/s6-overlay/s6-rc.d/<slug>
mv <addon-slug>/rootfs/etc/s6-overlay/s6-rc.d/user/contents.d/ADDON_SLUG \
   <addon-slug>/rootfs/etc/s6-overlay/s6-rc.d/user/contents.d/<slug>

# 4. 完善 config.yaml（map 对象化声明、url、webui、ports、description）
# 5. 实现 Dockerfile 构建逻辑，并填入 plan-addon 合成的标准 HEALTHCHECK（必须带 --noproxy '*' 与语言阶梯 start-period）
# 6. 配置 00-init.sh 执行纯本地离线播种与存量自愈探测（严禁外网网络请求，严禁写 ln -s 软链接）
# 7. 配置 run 脚本前台 exec 主程序（参数直指原生直挂路径，零后台进程 &）
# 8. 本地验证无误后登记至 AGENTS.md 列表
```

## version.yaml 声明范例
```yaml
version: "0.0.0"
repo: owner/repo
# strategy: release (默认) | tags | date (无版本号/滚动更新) | commits | asset
build_args:
  APP_VERSION: "${version}"
# 可选：多仓库组合版本号拼接控制 (可自由控制组件次序与分隔符，如 "${PANEL_VERSION}-${version}")
# version_template: "${version}-${PANEL_VERSION}"
# version_suffix: "${PANEL_VERSION}"  # 旧版语法，向后兼容
# dependencies:
#   PANEL_VERSION:
#     repo: owner/panel-repo
#     strategy: release
changelog:
  source: release_body
```
