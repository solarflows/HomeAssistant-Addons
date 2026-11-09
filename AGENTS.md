# HomeAssistant-Addons

> Owner: solarflows | Maintainer: Husky
> Repo definition: `repository.yaml`

## Agent Working Rules

- Before editing, inspect `git status --short --branch` and preserve unrelated user changes.
- Prefer evidence in Dockerfiles, `rootfs/`, `config.yaml`, workflows, tests, and Git history. Treat `analysis.yaml`, summary tables, and upstream documentation as hypotheses until they match the current runtime files.
- Use repository-local `AGENTS.md`, `.github/instructions/`, `.github/skills/`, and `docs/` as the portable project knowledge base. Do not move project rules into user/plugin memory.
- Do not commit, push, rebase, merge, tag, or change branches unless the user explicitly asks.
- Do not manually update CI-owned metadata: `config.yaml.version`, `CHANGELOG.md`, or `version.yaml.tracking.file_sha` / `build_num`. See [addon-editing.instructions.md](.github/instructions/addon-editing.instructions.md).
- Before enabling or restoring Ingress, verify the pinned upstream version and relevant Git history, then test the HA subpath behavior, redirects, static assets, APIs, and WebSockets. Use direct `webui` and ports when support is not proven.

## Repository Shape

Each addon normally contains `analysis.yaml`, `config.yaml`, `Dockerfile`, `version.yaml`, `README.md`, `DOCS.md`, `CHANGELOG.md`, `translations/`, and `rootfs/`. Reusable skeletons are in [.github/templates/](.github/templates/) (`binary/`, `upstream-image/`, `source/`).

The repository has no single project-wide test command. The normal local verification is targeted YAML parsing, shell syntax checks, a single-platform Docker build, and a cold-start smoke test against the image health endpoint. See [Validation](#validation).

## Addons (14)

| slug | upstream | strategy | port | S6 |
|---|---|---|---|---|
| alist-tvbox | power721/alist-tvbox | JAR + haroldli/alist | 4567, 80→5344 | yes |
| alist-tvbox-standalone | same | JAR (no alist, no nginx) | 4567 | yes |
| lucky | gdy666/lucky | binary download | 16601 (host) | yes |
| flaresolverr | FlareSolverr/FlareSolverr | upstream image | 8191, 8192 | no |
| qdtoday | qd-today/qd | Python src build | 8923 | yes |
| qinglong | whyour/qinglong | Node.js src build | 5700 | yes |
| baihu-panel | engigu/baihu-panel | Go src build | 8052 | yes |
| filebrowser-quantum | gtsteffaniak/filebrowser | binary download | 8080 | yes |
| uptime-kuma | louislam/uptime-kuma | Node.js src build | 3001 | yes |
| cliproxyapi | router-for-me/CLIProxyAPI | binary download (+CPAMP light panel) | 8317 | yes |
| cliproxyapi-cpamp | same | binary download (+CPAMP manager server) | 8317, 18317 | yes |
| mcphub | samanhappy/mcphub | upstream image | 3000 | no |
| trawl | germondai/trawl | upstream image | 8191, 8192 | no |
| workbuddy2api-panel | linguo2625469/workbuddy2api-panel | binary download | 7863 | yes |

### Version prefixes

| slug | tag_prefix | example | config version |
|---|---|---|---|
| alist-tvbox | "" | 1.24.0 | 1.24.0 |
| lucky | "v" | v2.27.2 | 2.27.2 |
| flaresolverr | "v" | v3.5.0 | 3.5.0 |
| qdtoday | "" | 20250803 | 20250803 |
| qinglong | "v" | v2.21.0 | 2.21.0 |
| baihu-panel | "v" | v1.1.21 | 1.1.21 |
| filebrowser-quantum | "v" + transform | v1.4.0-stable | 1.4.0-stable |
| uptime-kuma | "v" | v2.4.0 | 2.4.0 |
| cliproxyapi | "v" | v8.0.23 | 8.0.23 |
| cliproxyapi-cpamp | "v" | v8.0.23 | 8.0.23-1.14.5 (suffix) |
| mcphub | "v" | v1.1.2 | 1.1.2 |
| trawl | "v" | v1.8.0 | 1.8.0 |
| workbuddy2api-panel | "v" | v1.13.0 | 1.13.0 |

## Quick Reference
- **Base**: `debian-base:9.3.0` (S6 built-in) | **Storage**: 对象化自定义路径挂载 (`type: app_config -> upstream native path`)，严格禁止软链中转
- **Build**: multi-stage source / upstream image adaptation / base+binary / base+JAR. Check the current Dockerfile before choosing a strategy.
- **CI**: `Version_Check (6h cron) -> Release -> multi-arch build -> ghcr.io -> independent metadata commits`; details are in [fix-ci/SKILL.md](.github/skills/fix-ci/SKILL.md).
- **Runtime**: S6 longruns must keep the application in the foreground and `exec` the real process. `flaresolverr`, `mcphub`, and `trawl` are the upstream-image exceptions and use wrapped upstream entrypoints.
- **Troubleshooting**: [addon-troubleshooting.instructions.md](.github/instructions/addon-troubleshooting.instructions.md) is auto-loaded for Dockerfiles, Shell, `config.yaml`, and `version.yaml`.

## Runtime Boundaries & Data Architecture

Home Assistant 加载项全面采用 **Supervisor 对象化自定义映射语法（Object Map Specification）**，彻底废弃将所有外部卷固定映射到 `/config` 再依赖 `00-init.sh` 建立软链接的旧模式。

### 1. 全新 Map 容器对象化语法规范 (HA Supervisor Object Map Specification)

基于 Home Assistant Supervisor 官方最新源码（`supervisor/apps/validate.py` 与 `supervisor/docker/app.py`），`map` 字段自 2023.11 起正式引入 Dict 对象语法以支持自定义路径（`allow path configuration`）。在 `config.yaml` 中，严禁使用简写字符串（如 `addon_config:rw` 或旧版 `config:rw`），必须统一采用对象化声明：

```yaml
map:
  - type: app_config              # 官方 2026.07 起全面强制标准类型（取代弃用告警的 legacy 'addon_config'）
    path: <upstream_native_path>   # 外部宿主独立目录直穿上游应用原生持久路径（如 /goodluck, /ql/data, /opt/uptime-kuma/data）
    read_only: false              # 必须显式声明！Supervisor Schema 默认值为 True（只读）
  - type: homeassistant_config    # 存量历史数据双轨自愈探测挂载（平滑迁移过渡使用）
    path: /legacy_ha
    read_only: false
  # 按需挂载共享或证书卷：
  - type: share
    path: /share
    read_only: false
  - type: ssl
    path: /ssl
    read_only: true
```

- **官方底层 Schema 校验事实（`supervisor/apps/validate.py`）**：
  ```python
  vol.Optional(ATTR_MAP, default=list): [
      vol.Schema({
          vol.Required(ATTR_TYPE): vol.Coerce(MappingType),
          vol.Optional(ATTR_READ_ONLY, default=True): bool,
          vol.Optional(ATTR_PATH): str,
      })
  ]
  ```
  > [!CAUTION] 官方默认值陷阱（必须显式 `read_only: false`）
  > 官方 Voluptuous Schema 明确声明 `vol.Optional(ATTR_READ_ONLY, default=True): bool`。如果在对象化 `map` 中漏写 `read_only: false`，Supervisor 会强制将其挂载为**只读（RO）**，导致应用启动写数据库时直接报只读文件系统错误！所有需要读写的持久化目录必须显式写明 `read_only: false`。

- **官方底层 Docker 挂载构造机理（`supervisor/docker/app.py`）**：
  ```python
  target = app_mapping[config_mapping_type].path or PATH_PUBLIC_CONFIG.as_posix()
  mounts.append(DockerMount(
      type=MountType.BIND,
      source=self.app.path_extern_config.as_posix(), # 宿主 /mnt/data/supervisor/addon_configs/<slug>
      target=target,                                 # 自定义 path 覆盖默认 /config
      read_only=app_mapping[config_mapping_type].read_only,
  ))
  ```
  - 当指定 `path: <upstream_path>` 时，Docker 容器的 Target 挂载点直接成为该原生路径；
  - `homeassistant_config` 同样遵循 `target = app_mapping[...].path or PATH_HOMEASSISTANT_CONFIG.as_posix()`，可通过 `path: /legacy_ha` 挂至任意隔离探测位置。

- **官方类型枚举与互斥保护（`supervisor/apps/const.py`）**：
  - **最新标准类型**：`app_config`、`local_apps`、`all_app_configs`、`homeassistant_config`、`data`、`share`、`ssl`、`media`、`backup`；
  - **2026.07 弃用类型**：`addon_config`、`addons`、`all_addon_configs`；
  - **互斥规则**：旧版 `config` 与新版 `app_config` / `homeassistant_config` 绝对互斥；新旧同类映射混用时（如同时声明 `app_config` 与 `addon_config`），Supervisor 将强制忽略旧类型。

### 2. 四大架构设计铁律 (Four Architectural Invariants)

1. **零软链铁律 (Zero Symlink Policy)**：
   - 严禁在 `00-init.sh` 中使用 `rm -rf <path> && ln -s ...` 模拟运行目录。
   - 上游原生路径必须由 `app_config` 直挂。彻底消除 Go、Node.js、Python、SQLite 运行时在原子写入（`atomic rename()`、`unlink()`）、跨文件系统硬链接、文件锁（`flock()`）下因软链接解绑导致的配置重置、数据断链或 SQLite `CANTOPEN (14)` 崩溃。
2. **冷热与备份分级治理 (Storage Tiering & Backup Hygiene)**：
   - **配置与数据卷 (`app_config`)**：仅用于存放应用核心业务资产（数据库文件如 SQLite/LevelDB/H2、用户配置、认证凭据 Token/密钥）。严控体积，确保 HA 备份迅速且体积轻量。
   - **临时与高频数据隔离**：运行期日志（logs）、运行环境依赖（Node.js `node_modules`、Python `venv`）、前端构建缓存、解压临时目录严禁丢入 `app_config`；必须保留在容器只读层、内存临时层或独立的 `/data` 私有持久卷中，杜绝 HA 备份包体积膨胀与宿主机 Flash 寿命磨损。
3. **存量数据双轨平滑自愈机制 (Dual-Track Migration Protocol via `/legacy_ha`)**：
   - **双轨探测**：容器启动时，`00-init.sh` 先检测目标原生路径是否已有核心业务数据（如数据库文件）；若目标路径为空，且在 `/legacy_ha/<slug>` 中检测到历史遗留数据，则触发一次性安全增量迁移：
     ```bash
     cp -a /legacy_ha/<slug>/. <upstream_native_path>/
     touch <upstream_native_path>/.migrated_from_legacy
     ```
   - **安全延迟清理**：严禁在容器初始化阶段删除 `/legacy_ha/<slug>` 旧数据！必须在迁移目标目录中生成标记，由 S6 后台健康守护在确认应用主进程正常启动、端口正常响应、数据库连接成功后，方可由管理员确认清理或进入延时回收队列，确保迁移过程 100% 具备容灾回滚能力。
4. **S6 初始化与运行屏障锁 (Init-Run Barrier)**：
   - `00-init.sh` 脚本在完成数据目录检查、权限校准与迁移后，必须创建 `/run/<slug>-initialized` 屏障文件。
   - S6 服务的 `run` 脚本必须包含有界自旋等待（默认上限 60s），等待屏障文件就绪后再 `exec` 启动主进程，从根本上根除 S6 stage2 与 init 并发竞争导致的启动竞态（Race Condition）。
5. **基础运维守则**：
   - 复用上游初始化与启动逻辑：初始化留在 `00-init.sh`，前台常驻服务交由 S6 `run` 脚本 `exec` 托管。
   - `debian-base:9.3.0` 内置经典 S6，严禁新增不受支持的 `notification-fd` 或 `timeout-up`；保持现行 `S6_STAGE2_HOOK` 模式。
   - `COPY rootfs /` 之后，必须赋予 shell 脚本可执行权限（特别注意 Windows 检出环境）。
   - 严禁用 `|| true` 静默吞掉异常；非致命操作必须捕获退出码并显式输出原因。

### 3. 全量 14 个加载项上游原生持久化规范矩阵 (Upstream Path & Mount Matrix)

| 加载项 (slug) | 上游官方原生路径 | 映射类型 (map) | 核心存储特性与分级说明 |
|---|---|---|---|
| **baihu-panel** | `/app/data` | `app_config -> /app/data` | Go 纯静态。存储 `app.db`、`cache.db`、节点与用户配置。纯原生直挂，免除软链断裂 |
| **uptime-kuma** | `/opt/uptime-kuma/data` | `app_config -> /opt/uptime-kuma/data` | Node.js + SQLite。存储 `kuma.db`、证书与上传文件。消除 SQLite `rename()` 软链解绑 |
| **lucky** | `/goodluck` | `app_config -> /goodluck` | Go 二进制。存储 `lucky.conf`、动态 DNS 与规则。原生工作目录直挂 |
| **qinglong** | `/ql/data` | `app_config -> /ql/data` | Node.js + Python。上游 v2.10+ 标准持久目录（包含 `config`、`db`、`scripts`）。避免软链整卷替换 |
| **qdtoday** | `/usr/src/app/config` | `app_config -> /usr/src/app/config` | Python + SQLite。存储 `database.db` 与签到配置。保留上游工作目录直接持久化 |
| **filebrowser-quantum** | `/config` | `app_config -> /config`<br>`share -> /share` | Go 二进制。存储 `filebrowser.db` 与 `settings.json`；业务浏览挂载宿主 `/share` |
| **cliproxyapi** | `/config` | `app_config -> /config` | Go 二进制。存储 `config.yaml`、OAuth 凭据及代理路由配置 |
| **cliproxyapi-cpamp** | `/config` | `app_config -> /config` | Go + Node.js。存储 CLIProxy 规则与 CPAMP 管理器数据库 `cpamp.db` |
| **mcphub** | `/app/data` | `app_config -> /app/data` | 上游镜像。存储 MCP 服务器清单与服务配置，直通原生路径 |
| **workbuddy2api-panel** | `/app/data` | `app_config -> /app/data` | Go 二进制。存储 `app.db` 与 API 配置 |
| **alist-tvbox** | `/config` | `app_config -> /config`<br>`/data -> /data` (私有卷) | Java + AList。`-Datv.data.dir=/config` 存储核心数据库；`/index` 挂载私有卷 `/data/index` 避开备份 |
| **alist-tvbox-standalone**| `/config` | `app_config -> /config` | 纯 Java。原生 `-Datv.data.dir=/config`，纯物理路径零软链 |
| **trawl** | `/app/data` | `app_config -> /app/data` | 上游镜像。持久化存储抓取规则与状态，按需开启 |
| **flaresolverr** | *(无状态)* | *(可选内存/tmp)* | Python + Chromium。会话内存维持，无需配置持久化，零膨胀 |

## Version and CI Contract

- **`config.yaml.version` mirrors the upstream version** and must equal the pushed image tag (HA requires this). CI derives it as:
  `<composed version>[-build.N]`
  - `<composed version>` — derived via optional `version.yaml.version_template` (e.g. `"${PANEL_VERSION}-${version}"` or `"${version}-${PANEL_VERSION}"`, allowing arbitrary component order and delimiters). Falls back to `<upstream version>[-<version_suffix>]` when `version_template` is omitted.
  - `-build.N` — added **only** when a build is triggered without an upstream version change (Dockerfile/rootfs/base-image workflow changes), so HA still detects the update.
  - Then sanitized for HA: must start with a digit, only `[0-9A-Za-z.-]` kept, truncated at the first invalid character (e.g. `1.2.3+build` → `1.2.3`).
- `version.yaml.version` is always the clean upstream comparison version (never the composed/sanitized one); it is what `Version_Check` compares against upstream and what `TAG=v<version>` uses for changelog lookups.
- `version.yaml.strategy` (optional, default `release`): specifies how upstream versions are extracted:
  - `release`: GitHub latest release tag (default)
  - `tags`: latest Git Tag (tag-only repos)
  - `date`: latest commit date `YYYYMMDD` (for rolling releases / unversioned projects)
  - `commits`: total commit count `0.0.N`
  - `asset`: updated timestamp `YYYYMMDD` of release asset
- `version.yaml.dependencies` supports monitoring arbitrary N secondary/upstream repositories (e.g. `KEY: { repo: owner/repo, strategy: release }`). When any dependency has a new release, `Version_Check` triggers release with `updated_deps`, and `Release.yml` updates `build_args` and `version.yaml`.
- Every `version.yaml.build_args` key must match a Dockerfile `ARG`. Check tag prefixes and transformations per addon before changing version logic.
- `Version_Check.yml` runs every six hours and on manual dispatch; `Release.yml` builds the matrix for the configured architectures and pushes `ghcr.io/solarflows/<addon-slug>`.
- **Edit `Release.yml` triggers a full rebuild of every addon** (the path filter treats a pipeline change as invalidating all cached metadata). Expect unrelated addons to get a `-build.N` bump.
- The current push path filter watches addon `Dockerfile`, addon `rootfs/**`, `Release.yml`, `.github/actions/**`, and `.github/scripts/**`. Do not assume a config-only or version-only change will trigger a build; inspect [Version_Check.yml](.github/workflows/Version_Check.yml) when the trigger matters.
- Build args and GitHub Actions outputs are structured data. Preserve the existing `yq -> JSON -> jq` flow and heredoc format for multiline `GITHUB_OUTPUT` values.
- `reason` values can be **composite** (comma-joined, e.g. `version_changed,dockerfile,rootfs` for a new addon's first build). Always split on commas before matching — never prefix-match (`case "$REASON" in dockerfile*`).

## Validation

For a changed addon, use the smallest useful check first:

1. Parse `repository.yaml`, the target `config.yaml`, `version.yaml`, and `analysis.yaml` with `yq`.
2. Run `bash -n` (or `shellcheck` when available) on changed `rootfs` scripts and verify executable permissions in the Dockerfile.
3. Run a single-platform Buildx build for `linux/amd64`, passing every build argument declared in the target `version.yaml`:

	 ```bash
	 docker buildx build --platform linux/amd64 \
		 --build-arg <ARG>=<value> \
		 -f <addon>/Dockerfile <addon> --load --tag local/<addon>:check
	 ```

4. Start the image with an empty data directory and exercise the declared `HEALTHCHECK`, primary port, and any secondary service ports. For web applications, check redirects, static assets, API calls, and WebSockets when Ingress or a reverse proxy is involved.
5. Do not describe a build or runtime behavior as verified when Docker, the required upstream network access, or a Home Assistant environment was unavailable.

## Navigation

| Need | Read |
|---|---|
| Create a new addon | [create-addon/SKILL.md](.github/skills/create-addon/SKILL.md) |
| Analyze an upstream project | [plan-addon/SKILL.md](.github/skills/plan-addon/SKILL.md) |
| Update an existing addon | [update-addon/SKILL.md](.github/skills/update-addon/SKILL.md) |
| Diagnose CI or release failures | [fix-ci/SKILL.md](.github/skills/fix-ci/SKILL.md) |
| Edit addon manifests, Ingress, init, or Dockerfiles | [addon-editing.instructions.md](.github/instructions/addon-editing.instructions.md) |
| Review known build/runtime pitfalls | [addon-troubleshooting.instructions.md](.github/instructions/addon-troubleshooting.instructions.md) |
| Understand an addon’s user-facing behavior | `<addon>/DOCS.md` and `<addon>/README.md` |
| Check repository metadata and workflows | [repository.yaml](repository.yaml), [Version_Check.yml](.github/workflows/Version_Check.yml), [Release.yml](.github/workflows/Release.yml) |

## Skills
| Skill | File | Use when |
|---|---|---|
| create-addon | `.github/skills/create-addon/SKILL.md` | Scaffold new addon skeleton with empty analysis.yaml (run first) |
| plan-addon | `.github/skills/plan-addon/SKILL.md` | Analyze upstream service & fill analysis.yaml (run after create-addon) |
| update-addon | `.github/skills/update-addon/SKILL.md` | Manually update existing addon for upstream changes |
| fix-ci | `.github/skills/fix-ci/SKILL.md` | Debug CI/CD failures |
