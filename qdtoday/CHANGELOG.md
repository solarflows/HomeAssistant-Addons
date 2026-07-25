### 20250803-build.43 (2026-07-25)
CI 工作流变更
无提交信息

### 20250803-build.42 (2026-07-25)
CI 工作流变更
无提交信息

### 20250803-build.41 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 20250803-build.40 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 20250803-build.39 (2026-07-24)
rootfs 脚本/配置变更
无提交信息

### 20250803-build.38 (2026-07-24)
rootfs 脚本/配置变更
无提交信息

### 20250803-build.37 (2026-07-24)
CI 工作流变更
无提交信息

### 20250803-build.36 (2026-07-24)
Dockerfile 变更
Merge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 20250803-build.35 (2026-07-24)
Dockerfile 变更
fix(qdtoday): use find to locate actual dist-packages path — no sysconfig scheme assumptions

### 20250803-build.34 (2026-07-24)
Dockerfile 变更
fix(qdtoday): use sysconfig scheme vars to compute correct /usr/local purelib path

### 20250803-build.33 (2026-07-24)
Dockerfile 变更
fix(qdtoday): .pth file in system dist-packages (guaranteed on sys.path), no glob/symlink/PYTHONPATH

### 20250803-build.32 (2026-07-24)
Dockerfile 变更
fix(qdtoday): use --target /opt/qd-deps + PYTHONPATH to avoid Debian dist-packages path issue entirely

### 20250803-build.31 (2026-07-24)
CI 工作流变更
fix(baihu): add BH_SERVER_URL_PREFIX for Ingress support; fix(ci): config/version.yaml changes no longer trigger rebuild

### 20250803-build.30 (2026-07-24)
Dockerfile 变更
fix(qdtoday): remove obsolete site-packages→dist-packages bridge — no longer needed with same-base builder

### 20250803-build.29 (2026-07-24)
CI 工作流变更
fix(ci): summary uses always() + remove imagetools; all healthchecks add -o /dev/null

### 20250803-build.28 (2026-07-24)
Dockerfile 变更
fix(qdtoday): skip pycurl in builder stage, compile only at runtime to avoid libcurl ABI mismatch

### 20250803-build.27 (2026-07-24)
Dockerfile 变更
build(uptime-kuma): Dockerfile 变更 → 2.4.0-build.16

### 20250803-build.26 (2026-07-24)
Dockerfile 变更
fix(qdtoday): force rebuild pycurl against runtime libcurl to fix CURLE_UNKNOWN_OPTION (48)

### 20250803-build.25 (2026-07-24)
Dockerfile 变更
fix(qdtoday): pycurl 用系统 libcurl4 编译 — 去掉全自编译链

### 20250803-build.24 (2026-07-24)
Dockerfile 变更
fix(qdtoday): 移除 apt curl + 强制 purge libcurl4/3-gnutls，消除 libcurl 冲突

### 20250803-build.23 (2026-07-24)
Dockerfile 变更
revert(qdtoday): ja3 → main 方案 (quictls openssl + curl 8.6.0 + pycurl)

### 20250803-build.22 (2026-07-24)
Dockerfile 变更
build(qdtoday): Dockerfile 变更 → 20250803-build.21

### 20250803-build.21 (2026-07-24)
Dockerfile 变更
fix(qdtoday): pycurl 编译需要 python3-dev (Python.h 头文件)

### 20250803-build.20 (2026-07-24)
Dockerfile 变更
fix(qdtoday): libcurl4 和 -dev 合并到同一个 apt-get update，消除版本漂移

### 20250803-build.19 (2026-07-24)
Dockerfile 变更
fix(qdtoday): pycurl 移到运行时编译，链接到实际 libcurl4

### 20250803-build.18 (2026-07-24)
Dockerfile 变更
fix(qdtoday): 移除 Ingress 改回外部端口访问 + 精简 TO_BOOL 补丁

### 20250803-build.17 (2026-07-24)
CI 工作流变更
fix(ci): 过滤 bot 提交避免 CI 自触发 config.yaml 循环重建

### 20250803-build.16 (2026-07-24)
CI 工作流变更
fix(ci): file_sha 在 commit 后更新，避免 CI 自触发的 config.yaml 循环重建

### 20250803-build.15 (2026-07-23)
Dockerfile 变更
build(qdtoday): Dockerfile 变更 → 20250803-build.14

### 20250803-build.14 (2026-07-23)
Dockerfile 变更
fix(qdtoday): safe_eval 补丁 — 添加 Python 3.12+ 新增的 TO_BOOL opcode

### 20250803-build.13 (2026-07-23)
CI 工作流变更
fix(s6): stage2_hook 后台轮询等待 legacy-services 就绪

### 20250803-build.12 (2026-07-23)
Dockerfile 变更
feat: S6_STAGE2_HOOK for all S6 addons

### 20250803-build.11 (2026-07-23)
config.yaml/version.yaml 变更
build(filebrowser-quantum): CI 工作流变更 → 1.5.0-stable-build.8

### 20250803-build.10 (2026-07-23)
CI 工作流变更
fix(s6): cont-init 末尾 rm down 文件，修复 legacy-services 不自动启动

### 20250803-build.9 (2026-07-23)
CI 工作流变更\nMerge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - Dockerfile 变更: fix(s6): run 脚本添加 SIGTERM trap，防止停止时产生孤儿进程

### 2026-07-23 - config.yaml/version.yaml 变更: build(lucky): CI 工作流变更 → 2.27.2-build.6

### 2026-07-23 - CI 工作流变更: docs(skills): ha-addon-conventions 精简为英文核心模式 (220→110行)

### 2026-07-23 - fix(ci): 三处增强保证 rootfs/workflow 变更触发构建

### 2026-07-23 - 手动触发强制重建

### 2026-07-23 - Merge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - 手动触发强制重建

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更

