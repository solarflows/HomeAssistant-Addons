### 2.21.0-build.27 (2026-07-25)
CI 变更
- build(qinglong): CI 工作流变更 → 2.21.0-build.26

### 2.21.0-build.26 (2026-07-25)
CI 工作流变更
无提交信息

### 2.21.0-build.25 (2026-07-25)
CI 工作流变更
无提交信息

### 2.21.0-build.24 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 2.21.0-build.23 (2026-07-24)
CI 工作流变更
无提交信息

### 2.21.0-build.22 (2026-07-24)
CI 工作流变更
fix(baihu): add BH_SERVER_URL_PREFIX for Ingress support; fix(ci): config/version.yaml changes no longer trigger rebuild

### 2.21.0-build.21 (2026-07-24)
CI 工作流变更
fix(ci): show per-architecture compressed size using regctl in build summary

### 2.21.0-build.20 (2026-07-24)
CI 工作流变更
fix(ci): list built architectures in summary using jq from raw manifest

### 2.21.0-build.19 (2026-07-24)
CI 工作流变更
fix(ci): summary uses always() + remove imagetools; all healthchecks add -o /dev/null

### 2.21.0-build.18 (2026-07-24)
Dockerfile 变更
feat: ja3 curl-impersonate + pycurl-ja3 + sign labels

### 2.21.0-build.17 (2026-07-24)
CI 工作流变更
fix(ci): 过滤 bot 提交避免 CI 自触发 config.yaml 循环重建

### 2.21.0-build.16 (2026-07-24)
CI 工作流变更
fix(ci): file_sha 在 commit 后更新，避免 CI 自触发的 config.yaml 循环重建

### 2.21.0-build.15 (2026-07-23)
config.yaml/version.yaml 变更
build(qdtoday): Dockerfile 变更 → 20250803-build.14

### 2.21.0-build.14 (2026-07-23)
CI 工作流变更
fix(s6): stage2_hook 后台轮询等待 legacy-services 就绪

### 2.21.0-build.13 (2026-07-23)
Dockerfile 变更
feat: S6_STAGE2_HOOK for all S6 addons

### 2.21.0-build.12 (2026-07-23)
config.yaml/version.yaml 变更
build(filebrowser-quantum): CI 工作流变更 → 1.5.0-stable-build.8

### 2.21.0-build.11 (2026-07-23)
CI 工作流变更
fix(s6): cont-init 末尾 rm down 文件，修复 legacy-services 不自动启动

### 2.21.0-build.10 (2026-07-23)
CI 工作流变更\nMerge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - rootfs 脚本/配置变更: fix(s6): run 脚本添加 SIGTERM trap，防止停止时产生孤儿进程

### 2026-07-23 - config.yaml/version.yaml 变更: build(lucky): CI 工作流变更 → 2.27.2-build.6

### 2026-07-23 - CI 工作流变更: docs(skills): ha-addon-conventions 精简为英文核心模式 (220→110行)

### 2026-07-23 - fix(ci): 三处增强保证 rootfs/workflow 变更触发构建

### 2026-07-23 - 手动触发强制重建

### 2026-07-23 - Merge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - fix(qinglong): npm run build 不存在，改为 pnpm run build:front && build:back

### 2026-07-23 - 手动触发强制重建

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更

