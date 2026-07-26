---
name: plan-addon
description: 分析上游项目并填充 analysis.yaml。在 create-addon 创建骨架后运行。
---

# Addon Planning Guide

> **Purpose**: Investigate an upstream project and fill the `analysis.yaml` created by `create-addon`.
> **Prerequisite**: `create-addon` skill already created `<addon-slug>/` skeleton with empty `analysis.yaml`.
> **Output**: Filled `<addon-slug>/analysis.yaml` — the single source of truth for addon configuration.

## Workflow

```
create-addon: create skeleton + empty analysis.yaml
  ↓
plan-addon: investigate upstream → fill analysis.yaml
  ↓
User/manual: fill config.yaml, Dockerfile, scripts based on analysis.yaml
  ↓
User: push to main → CI auto-builds
```

## Investigation Checklist

### 1. Upstream Info
- Fetch repo metadata: `repo`, `description`, `license`
- Check release mechanism: GitHub Releases (`source: github`) or Tags (`source: github_tags`)
- Read `version.yaml` of similar addons in this repo for reference
- Determine `tag_prefix` (e.g., `v` or empty)

### 2. Docker Analysis
Read these upstream files completely:
- **Dockerfile** — base image, build deps, multi-stage, VOLUME, EXPOSE, ENV, CMD
- **docker-compose.yml** (if exists) — ports, volumes, environment
- **entrypoint.sh** / docker-entrypoint.sh — hardcoded paths, CWD assumptions, config init logic
- **.dockerignore** — build context hints

Extract:
- Base image language: Node/Python/Go/Java/Rust/binary
- Build dependencies vs runtime dependencies
- VOLUME mounts → must become symlinks in HA
- EXPOSE ports → `ingress_port` in config.yaml
- ENV vars → configurable options or HA env passthrough

### 3. Build Strategy Selection

| Strategy | When | Example |
|---|---|---|
| `multi-stage` | OSS with build toolchain | qinglong (Node), qdtoday (Python), baihu-panel (Go) |
| `upstream-image` | Complex build, official image exists | flaresolverr, filebrowser-quantum |
| `binary-download` | Closed-source or simple binary | lucky |
| `release-jar` | Java/Spring Boot | alist-tvbox, alist-tvbox-standalone |

### 4. Filesystem Adaptation

For each upstream VOLUME or hardcoded path, determine HA mapping:

```
Upstream container path  →  HA path               →  Type
/app/data                →  /config/<slug>/data    →  symlink in 00-init.sh
/opt/app/config          →  /config/<slug>/config  →  symlink in 00-init.sh
/ql/                     →  /config/qinglong       →  symlink
```

Check:
- Does CWD matter? (Go/Node apps often derive data dir from CWD)
- Does upstream write version files at build time? (`/app_version`, `/docker.version`)
- Does entrypoint use `set -e`? (any missing file kills init)

**Audit checklist**:
1. Read upstream `Dockerfile` / `docker-compose.yml` for volume mounts or VOLUME directives
2. Read upstream `entrypoint.sh` for hardcoded paths (`/app/data`, `/jre/bin/java`, etc.)
3. Read upstream scripts for version files the app expects (`/app_version`, `/docker.version`)
4. Check if CWD matters (Go/Node apps often derive data dir from the working directory)

### 5. Config Options
Identify what should be configurable:
- Upstream ENV vars → HA addon `options` + `schema`
- Config files on mounted volumes → HA configurable path
- Port bindings → `ingress_port` + `network` in config.yaml

## Output Format: analysis.yaml

Write to `<addon-slug>/analysis.yaml`:

```yaml
# <addon-slug>/analysis.yaml
---
upstream:
  repo: owner/repo
  description: What this service does
  license: MIT

build:
  strategy: multi-stage          # multi-stage | binary-download | upstream-image | release-jar
  builder_image: node:22-bookworm-slim  # only for multi-stage
  apt_build_deps: []             # build-time apt packages
  build_steps:                   # shell commands for builder stage
    - npm ci
    - npm run build
  artifacts: dist/               # COPY from builder
  runtime_deps:                  # packages installed in runtime stage
    apt:
      - nodejs
    pip: []
  version_arg: APP_VERSION       # ARG name for version, if any

runtime:
  language: node                 # node | python | go | java | rust | binary
  entrypoint: node app.js
  working_dir: /app
  env:
    KEY: value
  data_dir: /app/data            # where app stores persistent data

network:
  port: 3001
  protocol: tcp

filesystem:
  persistent_dirs:               # upstream VOLUME → HA /config mapping
    - container: /app/data
      ha: /config/<slug>/data
      type: symlink
      reason: Upstream VOLUME /app/data
  hardcoded_paths:               # upstream hardcoded absolute paths
    - path: /app_version
      ha: /config/<slug>/app_version
      type: file
  cwd_matters: true              # does app derive paths from CWD?

config:
  options:
    log_level:
      type: str?
      default: info
      description: Log level
  schema:
    log_level: list(trace|debug|info|warn|error)

adaptations:
  - Entrypoint uses /app/data as data dir → symlink to /config/<slug>/data
  - CWD is /app, app stores config in ./config → symlink /app/config
```

## Common Investigation Commands

```bash
# Fetch upstream files
curl -s https://raw.githubusercontent.com/owner/repo/main/Dockerfile
curl -s https://raw.githubusercontent.com/owner/repo/main/docker-compose.yml
curl -s https://raw.githubusercontent.com/owner/repo/main/entrypoint.sh

# Check latest release
curl -s https://api.github.com/repos/owner/repo/releases/latest | jq .tag_name
```
