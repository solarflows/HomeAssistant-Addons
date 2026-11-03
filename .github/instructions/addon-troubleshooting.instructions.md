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
- **配置持久同步 sidecar 机制**：采用 `/config/<slug>/options_applied.json` 记录已应用选项；首次启动跳过同步以防覆盖，非空且变更时覆写对应配置。
- **冷启动与看门狗窗口**：ARM 设备冷启动高负载服务（如 JVM）需 150~200s；Dockerfile `HEALTHCHECK` 必须设置 `start-period=300s, retries=5`，防止 Supervisor 看门狗提前杀进程。
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

## 上游路径适配清单

| 加载项 | 硬编码上游路径 | 适配方案 |
|---|---|---|
| alist-tvbox | `/jre/bin/java`, `/app_version`, `/docker.version` | Dockerfile 软链接与文件补齐 |
| alist-tvbox | `/opt/atv/BOOT-INF/lib/h2-*.jar` | snapshot-dependencies 执行 `find + ln -sf` |
| alist-tvbox | `/h2-2.1.214.jar` | Dockerfile 中 `curl` 预下载 |
| alist-tvbox | `/var/lib/data.zip` | `COPY --from=alist-source` |
| alist-tvbox | `/alist.json` | `COPY --from=source /src/config/alist.json` |
| alist-tvbox | `/index` | Dockerfile 及 00-init.sh 软链接至 `/data/index` |
| alist-tvbox | `pkill` (AList 优雅终止) | Dockerfile 预装 `procps` |
| alist-tvbox-standalone | Spring `file:/data/atv/config/` | 00-init.sh 中 `mkdir -p` |
| baihu-panel | `/app/data`, `/app/configs`, `/app/envs` | 00-init.sh 软链接至 `/data` 或 `/config` |
| qinglong | `/ql/` | 软链接 `/ql -> /config/qinglong` |
| qdtoday | `/usr/src/app/config` | 00-init.sh 软链接 |
| uptime-kuma | `/opt/uptime-kuma/data` | 00-init.sh 软链接 |

## S6 进程监督约束
- **严禁新增不支持的服务文件**：`debian-base:9.3.0` 内置老版本 S6；严禁添加 `notification-fd` 或 `timeout-up`，否则服务被静默跳过。
- **Stage 2 Hook 必需**：依赖 `S6_STAGE2_HOOK` 环境变量与对应 hook 脚本清理 `down` 标记文件；严禁在 cont-init 中执行 `rm -f down`。
- **消除 hook 与 cont-init 竞态**：S6 longrun `run` 脚本在 `exec` 真实进程前，必须加入有界等待（≤30s），等待 cont-init 生成必要配置文件。
- **容器层执行权限固化**：在 Dockerfile 执行 `COPY rootfs /` 后，必须紧跟 `RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh`。

## Chromium 容器约束
- 仅在文档明确要求 Chromium 运行依赖时才授予 `SYS_ADMIN` 或 `IPC_LOCK` 特权。
- Chromium 140+ 包装脚本包含 Bash 特有条件判断时，入口必须强制使用 `/bin/bash` 解释执行。

## 数据持久化与路径映射
- `/data/` 为 Supervisor 挂载的独立持久卷；`/config/` 为共享备份卷。
- 容器重启会丢弃非卷目录；上游硬编码于 `/opt` 等目录的读写数据，必须在 `00-init.sh` 中软链接至 `/data/` 或 `/config/`。
- 跨进程环境变量无法通过 `export` 穿透；S6 `run` 脚本中必须使用 `bashio::config` 直接读取用户配置。
