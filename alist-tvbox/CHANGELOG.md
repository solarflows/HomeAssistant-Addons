### 1.28.0-build.17 (2026-07-25)
rootfs 变更
- debug: init 脚本添加诊断日志（pre/post init 状态检查）
- build(alist-tvbox): Dockerfile + rootfs 变更 → 1.28.0-build.16

### 1.28.0-build.16 (2026-07-25)
Dockerfile + rootfs 变更
- Merge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons
- fix: data.zip 备份到 /opt/，清空 data 后自动恢复 data.sql
- build(alist-tvbox): Dockerfile + rootfs 变更 → 1.28.0-build.15

### 1.28.0-build.15 (2026-07-25)
Dockerfile + rootfs 变更
- fix: 创建 /jre/bin/java symlink，修复上游 H2 升级脚本找不到 java
- fix: 创建 /data/atv/config/ 目录，修复清空 data 后 Spring Boot 启动失败
- build(alist-tvbox): CI 变更 → 1.28.0-build.14

### 1.28.0-build.14 (2026-07-25)
CI 变更
- fix: 修复小雅数据未导入 + CI CHANGELOG commit message 提取
- build(alist-tvbox): Dockerfile 变更 → 1.28.0-build.13

### 1.28.0-build.13 (2026-07-26)
- 修复 init-xiaoya.sh 因缺少 `/app_version` 导致 `set -e` 中断，小雅数据未导入
- Dockerfile: 生成 `/app_version` 和 `/docker.version`（上游 CI 构建时生成，git 仓库中不存在）
- 修复 Release CI: CHANGELOG 提取 commit message 失败（通过 matrix 传递，不再依赖 shallow clone 中的 SHA）
- 改进 CI: 支持复合触发原因（如同时改 Dockerfile + rootfs → "Dockerfile + rootfs 变更"）

### 1.28.0-build.12 (2026-07-25)
- fix: config.json 创建移到 init-xiaoya.sh 之后，避免跳过数据库建表

### 1.28.0-build.11 (2026-07-25)
- fix: 修复 nginx 配置路径（Debian 用 sites-enabled/ 非 http.d/）

### 1.28.0-build.10 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 1.28.0-build.9 (2026-07-25)
CI 工作流变更
无提交信息

### 1.28.0-build.8 (2026-07-25)
CI 工作流变更
无提交信息

### 1.28.0-build.7 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 1.28.0-build.6 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 1.28.0-build.5 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 1.28.0-build.4 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 1.28.0-build.3 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 1.28.0-build.2 (2026-07-25)
Dockerfile 变更
无提交信息

### 1.28.0-build.1 (2026-07-25)
Dockerfile 变更
无提交信息

### 1.28.0 (2026-07-25)
# Release Notes - 1.28.0

## 修复

- 修复剧集季目录（如 `S01`）在播放列表详情中显示为季标记或误匹配其他影视名称的问题，并兼容点号分隔的中文目录名
- 修复 Atvp 对延迟解析分享链接处理不完整，导致部分分享内容无法正确打开的问题

### 1.27.0-build.4 (2026-07-24)
CI 工作流变更
无提交信息

### 1.27.0-build.3 (2026-07-24)
CI 工作流变更
fix(baihu): add BH_SERVER_URL_PREFIX for Ingress support; fix(ci): config/version.yaml changes no longer trigger rebuild

### 1.27.0-build.2 (2026-07-24)
CI 工作流变更
fix(ci): show per-architecture compressed size using regctl in build summary

### 1.27.0-build.1 (2026-07-24)
CI 工作流变更
fix(ci): list built architectures in summary using jq from raw manifest

### 1.27.0 (2026-07-24)
# Release Notes - 1.27.0

## 新增

- 新增「盘搜配置」独立页面，支持配置搜索并发数、刷新、返回结果数、过滤等参数，并持久化保存
- 盘搜链接检测支持按网盘类型选择检测范围，可单独勾选需要检测的盘类型
- 新增本地资源自动更新功能，定时检查并自动下载 packages / index / douban / 115 资源（含夜间随机抖动，避免高峰）

## 优化

- 盘搜「链接检测」入口调整至基础配置，标签页重命名为「盘搜配置」
- 优化电报频道展示效果
- 更新百度网盘 UA

## 修复

- 修复电报标题装饰前缀未正确剥离的问题

### 1.26.0-build.16 (2026-07-24)
Dockerfile 变更
feat: ja3 curl-impersonate + pycurl-ja3 + sign labels

### 1.26.0-build.15 (2026-07-24)
CI 工作流变更
fix(ci): 过滤 bot 提交避免 CI 自触发 config.yaml 循环重建

### 1.26.0-build.14 (2026-07-24)
CI 工作流变更
fix(ci): file_sha 在 commit 后更新，避免 CI 自触发的 config.yaml 循环重建

### 1.26.0-build.13 (2026-07-23)
config.yaml/version.yaml 变更
build(qdtoday): Dockerfile 变更 → 20250803-build.14

### 1.26.0-build.12 (2026-07-23)
CI 工作流变更
fix(s6): stage2_hook 后台轮询等待 legacy-services 就绪

### 1.26.0-build.11 (2026-07-23)
Dockerfile 变更
feat: S6_STAGE2_HOOK for all S6 addons

### 1.26.0-build.10 (2026-07-23)
config.yaml/version.yaml 变更
build(filebrowser-quantum): CI 工作流变更 → 1.5.0-stable-build.8

### 1.26.0-build.9 (2026-07-23)
CI 工作流变更
fix(s6): cont-init 末尾 rm down 文件，修复 legacy-services 不自动启动

### 1.26.0-build.8 (2026-07-23)
CI 工作流变更\nMerge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - rootfs 脚本/配置变更: fix(s6): run 脚本添加 SIGTERM trap，防止停止时产生孤儿进程

### 2026-07-23 - config.yaml/version.yaml 变更: build(lucky): CI 工作流变更 → 2.27.2-build.6

### 2026-07-23 - CI 工作流变更: docs(skills): ha-addon-conventions 精简为英文核心模式 (220→110行)

### 2026-07-23 - fix(ci): 三处增强保证 rootfs/workflow 变更触发构建

### 2026-07-23 - 手动触发强制重建

### 2026-07-23 - 手动触发强制重建

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更

### 1.26.0 (2026-07-21)
# Release Notes - 1.26.0

## 新增

- 支持 UC 网盘、夸克网盘分享链接的「免转存」直链播放

