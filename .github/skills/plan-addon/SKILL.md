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
- 数据持久化：`/app/data` $	o$ `/config/<slug>/data`（于 `00-init.sh` 中创建软链接）。
- 工作目录敏感性：排查应用是否依赖特定 CWD 解析相对路径。
- 构建期文件探测：排查应用是否依赖 `/app_version` 或 `/docker.version` 等镜像层硬编码标识。

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

filesystem:
  persistent_dirs:
    - container: /app/data
      ha: /config/<slug>/data
      type: symlink
      reason: Upstream VOLUME /app/data
  hardcoded_paths:
    - path: /app_version
      ha: /config/<slug>/app_version
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
  - 启动项使用 /app/data 保存数据，在 00-init.sh 中软链接至 /config/<slug>/data
```
