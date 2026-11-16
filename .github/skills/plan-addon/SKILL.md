---
name: plan-addon
description: 分析上游项目并填充 analysis.yaml。在 create-addon 创建骨架后运行。
---

# 上游分析与规划指南

> **目标**：全面调研上游项目架构，填充 `create-addon` 生成的 `<addon-slug>/analysis.yaml`。
> **前置条件**：已通过 `create-addon` 技能创建骨架目录。
> **交付物**：完整的 `<addon-slug>/analysis.yaml`（作为加载项配置与构建的单一事实来源）。

## 工作流时序

```
create-addon: 创建骨架与空白 analysis.yaml
  ↓
plan-addon: 探查上游架构 → 填充 analysis.yaml
  ↓
人工确认: 依据 analysis.yaml 完善 config.yaml / Dockerfile / 脚本
  ↓
推送验证: push 至 main → CI 自动触发构建
```

## 调研检查清单

### 1. 上游元数据
- 获取仓库基础信息：`repo`、`description`、`license`。
- 确认发布机制：GitHub Releases (`source: github`) 或 Git Tags (`source: github_tags`)。
- 确认版本标签前缀 `tag_prefix`（如 `v` 或留空）。

### 2. Docker 与启动逻辑分析
完整核验上游仓库的核心文件：
- **Dockerfile**：提取基础镜像、构建工具、多阶段流程、VOLUME、EXPOSE、ENV、CMD。
- **docker-compose.yml**：提取端口、挂载卷、环境变量。
- **entrypoint.sh**：排查硬编码路径、工作目录依赖及配置生成逻辑。

### 3. 构建策略选型

| 策略模式 | 适用场景 | 代表范例 |
|---|---|---|
| `multi-stage` | 开源项目，需在构建期编译 | qinglong (Node), qdtoday (Python), baihu-panel (Go) |
| `upstream-image` | 构建极度复杂，官方已提供优化镜像 | flaresolverr, filebrowser-quantum |
| `binary-download` | 闭源商业软件或预编译独立二进制 | lucky |
| `release-jar` | Java / Spring Boot 胖包应用 | alist-tvbox, alist-tvbox-standalone |

### 4. 文件系统与持久化适配
针对上游 VOLUME 与硬编码路径，建立 Home Assistant 映射规则：
- 数据持久化：`/app/data` $\to$ 通过 `config.yaml` 的 `type: app_config, path: /app/data` 原生直挂，严禁软链接。
- 工作目录敏感性：排查应用是否依赖特定 CWD 解析相对路径。
- 构建期文件探测：排查应用是否依赖 `/app_version` 或 `/docker.version` 等镜像层硬编码标识。

### 5. 部署时序与 S6 服务拓扑推断 (Deployment Timing & Topology)
Agent 必须根据上游进程架构推导最佳部署模式：
- **单服务 vs 多服务解耦**：
  - 若为单一进程（如大多数 Go/Rust/Node 二进制）：采用单 longrun 服务，声明 `dependencies.d/legacy-cont-init`；
  - 若包含辅助进程（如 Nginx 反代网关、CGI 引擎、多后端）：严禁在单个 Shell 脚本中用 `&` 杂凑启动！必须拆分为独立的 S6-rc `longrun` 服务，并在 `dependencies.d/` 建立显式依赖有向图（DAG），并全部注册至 `user/contents.d/`。
- **纯本地初始化铁律 (Offline-First Initialization)**：
  - `cont-init.d/00-init.sh` 严禁包含任何公网网络下载（`curl`/`wget` 远端文件）；
  - 基础数据、模板、初始数据库必须在构建期打入镜像，首次启动仅做纯本地解包与播种；
  - 任何非阻塞式周期性同步（如规则库更新、索引拉取）必须作为独立的延迟后台守护进程运行（挂载依赖主服务），严禁阻塞主服务拉起。

### 6. 最优 Healthcheck 自动推断引擎 (Healthcheck Synthesis Engine)
Agent 分析上游 API 与进程特征时，必须按以下决策树自动推导出最优 `HEALTHCHECK`：
1. **端点优先级嗅探**：
   - 优先搜索上游代码中的免鉴权原生探活端点：`/(health|healthz|ping|status)`；
   - 次选：轻量根路径 `/`（必须确保无需 Cookie/Bearer 鉴权，且不会触发大体积 SPA 静态资源加载）；
2. **运行时启动时间窗阶梯 (start-period Gradient)**：
   - `go` / `rust` / 预编译二进制 $\to$ `start-period: 30s, timeout: 5s, interval: 30s, retries: 3`
   - `python` / `node` $\to$ `start-period: 60s, timeout: 5s, interval: 30s, retries: 3`
   - `chromium` / `playwright` / 大数据迁移 $\to$ `start-period: 90s~180s, timeout: 10s, interval: 30s, retries: 5`
   - `java` / `spring-boot` $\to$ `start-period: 300s, timeout: 10s, interval: 30s, retries: 5`
3. **安全与防劫持硬参数**：
   - 必须强制追加 `--noproxy '*'`，彻底切断宿主/容器全局代理变量对本地回环 `127.0.0.1` 的劫持；
   - 必须强制追加 `--max-time <timeout>`，提供进程级超时双保险；
   - 统一使用 `-sfo /dev/null` 静默报错并丢弃响应体。
4. **多网关级联探活**：
   - 若拆分了前端反代网关与后端微服务（如 `Nginx:80` + `App:4567`），必须串联双轨校验：`curl ... :4567 && curl ... :80`，防止网关瘫痪出现监控黑洞。

## analysis.yaml 规范格式

输出并保存至 `<addon-slug>/analysis.yaml`：

```yaml
# <addon-slug>/analysis.yaml
---
upstream:
  repo: owner/repo
  description: 服务功能简述
  license: MIT

build:
  strategy: multi-stage          # multi-stage | binary-download | upstream-image | release-jar
  builder_image: node:22-bookworm-slim
  apt_build_deps: []
  build_steps:
    - npm ci
    - npm run build
  artifacts: dist/
  runtime_deps:
    apt:
      - nodejs
    pip: []
  version_arg: APP_VERSION

runtime:
  language: node                 # node | python | go | java | rust | binary
  entrypoint: node app.js
  working_dir: /app
  env:
    KEY: value
  data_dir: /app/data

network:
  port: 3001
  protocol: tcp

lifecycle:
  init_mode: offline_only        # 纯本地离线播种，严禁公网网络阻塞
  topology: single_longrun       # single_longrun | multi_service_dag
  services:
    - name: ADDON_SLUG
      type: longrun
      dependencies:
        - legacy-cont-init

healthcheck:
  type: http                     # http | dual_http | tcp
  endpoint: /health              # 嗅探出的免鉴权探活端点
  port: 3001
  start_period: 60s              # 按语言运行时自动定界的启动时间窗
  timeout: 5s
  interval: 30s
  retries: 3
  command: "curl -sfo /dev/null --noproxy '*' --max-time 5 \"http://127.0.0.1:3001/health\" || exit 1"

filesystem:
  persistent_dirs:
    - container: /app/data
      ha: app_config
      type: direct_mount
      read_only: false
      reason: Upstream VOLUME /app/data
  hardcoded_paths:
    - path: /app_version
      ha: /config/app_version
      type: file
  cwd_matters: true

config:
  options:
    log_level:
      type: str?
      default: info
      description: 日志级别
  schema:
    log_level: list(trace|debug|info|warn|error)

adaptations:
  - 数据持久化采用 app_config 原生直挂至 /app/data，零软链架构
  - S6 overlay 纳管主进程为 longrun 服务，声明式依赖 legacy-cont-init
  - Healthcheck 绑定 /health 免鉴权端点，注入 --noproxy '*' 与 60s 冷启动窗口
```
