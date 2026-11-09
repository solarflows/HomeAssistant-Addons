---
name: addon-troubleshooting
description: "HomeAssistant-Addons 的 Dockerfile、Shell、config.yaml、version.yaml 构建或运行故障经验与原子化排障规范。"
applyTo: ["**/*.sh", "**/Dockerfile", "**/config.yaml", "**/version.yaml"]
---

# 加载项故障排查与规范

> 新增故障记录时，按 `现象 -> 根因 -> 规约` 格式追加至对应分类。

## 全局与 CI 规约
- **Dockerfile 下载重试**：严禁裸写 `ADD https://`；强制在 Dockerfile 中使用 `curl --retry 3 --retry-all-errors`。
- **复合原因触发判断**：`Version_Check` 产生的 `REASON` 包含逗号拼接（如 `version_changed,dockerfile`）；`Release.yml` 必须先切分提取 `IS_VERSION_CHANGE` 与 `IS_FILE_TRIGGER`，严禁使用前缀匹配。
- **跨 GHA 步骤变量传递**：GitHub Actions 各步骤为独立 Shell；跨步骤读取的变量必须输出至 `$GITHUB_OUTPUT`，后续步骤通过 `${{ steps.<id>.outputs.<key> }}` 消费。
- **变更日志范围精准截取**：提交日志严格基于 `file_sha..HEAD` 范围获取并过滤 `chore(<addon>): upstream`；严禁使用无界 `-10` 兜底导致混入无关历史。
- **图标静态资产免触发**：`icon.png` 与 `logo.png` 置于加载项根目录；不纳入 CI 监控路径，增删图标不触发镜像重构。
- **服务配置默认端口**：应用配置若无默认端口会绑定 `:0` 导致端口映射失效；生成初始配置时必须显式填入有效默认端口（如 `8317`）。
- **合并回填加载项选项**：调用 `POST /addons/self/options` 会全量覆盖选项；必须先读取合并后再执行单次请求，严禁连续分散请求。
- **配置持久同步 sidecar 机制**：采用 `/config/options_applied.json`（或未映射 `app_config` 时使用 `/data/options_applied.json`）记录已应用选项；首次启动跳过同步以防覆盖，非空且变更时覆写对应配置。
- **冷启动与看门狗窗口**：ARM 设备冷启动高负载服务（如 JVM）需 150~200s；Dockerfile `HEALTHCHECK` 必须设置 `start-period=300s, retries=5`，防止 Supervisor 看门狗提前杀进程。
- **健康检查与探活免刷屏**：优先使用上游原生免鉴权静默健康检查路由（如 `/health`, `/healthz`, `/api/v1/ping`），严禁请求前端根路径或需要加载全量静态资源/渲染 SPA 页面的路径；无原生健康端点的服务，在 S6 运行时监控中采用 Bash 原生零日志 TCP 握手探活 `(exec 3<>/dev/tcp/127.0.0.1/<PORT> && exec 3>&-)`，彻底杜绝 HTTP 访问日志污染与代理环境变量反噬。
- **初始化与运行串行化**：`cont-init.d/00-init.sh` 结束时创建 `/run/<slug>-initialized`；S6 `run` 脚本必须有界循环等待该标记，严禁二者无序争抢 CPU/IO。

## 语言构建策略规范

### Python (如 qdtoday)
- C 扩展库（如 `pycurl`、`ddddocr`）必须在运行时阶段编译，禁止直接从 builder 复制。
- 使用 `pip --prefix` 时，builder 与 runtime 的 Python 次版本必须完全一致。

### Node.js (如 qinglong, uptime-kuma)
- 原生模块（如 `sqlite3`、`cpu-features`）必须在运行时阶段执行 `npm rebuild`。
- builder 与 runtime 阶段若共享原生模块，必须基于相同 libc 族系；严禁将 Alpine/musl 模块复制至 Debian/glibc 环境。

### Go (如 baihu-panel, lucky)
- 强制使用 `CGO_ENABLED=0` 生成纯静态二进制；跨 stage 复制无需依赖任何宿主动态链接库。
- 构建时增加重试与代理回退，防范海外网络模块拉取中断。

### Java (如 alist-tvbox, alist-tvbox-standalone)
- Spring Boot `additional-location` 遇到不存在的路径会静默忽略；必须在 `00-init.sh` 中提前 `mkdir -p` 对应配置目录。

## 上游路径适配规范矩阵

| 加载项 | 上游原生路径 | 规范适配方案 (零软链 Direct Mount) |
|---|---|---|
| baihu-panel | `/app/data` | `app_config -> /app/data` 原生直挂，彻底消除 SQLite `rename()` 软链解绑 |
| uptime-kuma | `/opt/uptime-kuma/data` | `app_config -> /opt/uptime-kuma/data` 原生直挂，直通 `kuma.db` 与静态文件 |
| lucky | `/goodluck` | `app_config -> /goodluck` 原生工作目录直挂，直通 `lucky.conf` |
| qinglong | `/ql/data` | `app_config -> /ql/data` 原生持久目录直挂，避免全量软链覆盖 |
| qdtoday | `/usr/src/app/config` | `app_config -> /usr/src/app/config` 原生直挂，直通 `database.db` |
| filebrowser-quantum | `/config` | `app_config -> /config` 原生直挂；浏览目录使用 `share -> /share` |
| cliproxyapi | `/config` | `app_config -> /config` 原生直挂，存放 `config.yaml` 与 OAuth 凭据 |
| cliproxyapi-cpamp | `/config` | `app_config -> /config` 原生直挂，存放代理配置与 `cpamp.db` |
| mcphub | `/app/data` | `app_config -> /app/data` 原生直挂，存放 MCP 注册表与服务清单 |
| workbuddy2api-panel | `/app/data` | `app_config -> /app/data` 原生直挂，直通 `app.db` |
| alist-tvbox | `/config` | `app_config -> /config` 原生 `-Datv.data.dir` 直挂；`/index` 挂载私有卷 `/data/index` 避开备份 |
| alist-tvbox-standalone | `/config` | `app_config -> /config` 纯 Java 原生 `-Datv.data.dir` 直挂，纯物理路径零软链 |
| trawl | `/app/data` | `app_config -> /app/data` 原生直挂，存放抓取规则 |
| flaresolverr | *(无状态)* | 会话内存维持，无需配置持久化，零膨胀 |

## S6 进程监督约束
- **严禁新增不支持的服务文件**：`debian-base:9.3.0` 内置老版本 S6；严禁添加 `notification-fd` 或 `timeout-up`，否则服务被静默跳过。
- **Stage 2 Hook 必需**：依赖 `S6_STAGE2_HOOK` 环境变量与对应 hook 脚本清理 `down` 标记文件；严禁在 cont-init 中执行 `rm -f down`。
- **消除 hook 与 cont-init 竞态**：S6 longrun `run` 脚本在 `exec` 真实进程前，必须加入有界等待（≤30s），等待 cont-init 生成必要配置文件。
- **容器层执行权限固化**：在 Dockerfile 执行 `COPY rootfs /` 后，必须紧跟 `RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh`。

## Chromium 容器约束
- 仅在文档明确要求 Chromium 运行依赖时才授予 `SYS_ADMIN` 或 `IPC_LOCK` 特权。
- Chromium 140+ 包装脚本包含 Bash 特有条件判断时，入口必须强制使用 `/bin/bash` 解释执行。

## 数据持久化与路径映射 (Object Map 规范)
- `/data/` 为 Supervisor 挂载的每个加载项独立私有持久卷（宿主 `/usr/share/hassio/addons/data/<slug>/`），不纳入普通备份，适宜存放非关键缓存与索引。
- **全新 Map 容器对象化语法**：`config.yaml` 必须采用对象语法（`type: app_config, path: <upstream_path>`；注：旧称 `addon_config` 已被 Supervisor 弃用），由 Supervisor 将宿主独立配置目录（`/mnt/data/supervisor/addon_configs/<slug>/`，HAOS 终端为 `/homeassistant/addon_configs/<slug>/`）直接原子绑定至上游应用的原生路径。
- **read_only 默认只读陷阱**：Supervisor Schema 中 `read_only` 缺省默认为 `true`；若漏配 `read_only: false`，应用写入数据库时会遭遇 `Read-only file system` 或 SQLite 挂死，排查时优先复核映射声明。
- **零软链铁律**：严禁在 `00-init.sh` 中使用 `rm -rf <path> && ln -s ...` 模拟运行目录，杜绝 Node.js/Go/Python/SQLite 在原子写入（`rename`）时的解绑断链故障。
- **存量历史自愈探测与平滑迁移**：在 `map` 中声明挂载 `type: homeassistant_config, path: /legacy_ha`；`00-init.sh` 仅在目标原生目录为空且 `/legacy_ha/<slug>` 存在存量数据时执行一次性迁移（`cp -a /legacy_ha/<slug>/. <upstream_path>/`），并写入 `.migrated_from_legacy` 标记。
- **严禁提前清理旧数据**：迁移暂存后，必须等 S6 守护确认服务端口/健康检查完全就绪，方可安全延时清理旧数据，防止启动失败导致不可逆损坏。
- **S6 初始化屏障**：`00-init.sh` 退出前生成 `/run/<slug>-initialized`；S6 `run` 必须自旋等待该锁文件放行，彻底消除并发竞态。
