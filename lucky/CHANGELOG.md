### 3.5.0 (2026-10-29)
2026-10-26 · v3.5.0
1. 修复 Docker 管理和群晖插件适配的已知问题。
2. 网络唤醒新增分组管理，支持通过 SSH 控制设备、检测状态。
3. Cloudflared 更新至 2026.10.4。
4. 修复群晖套件已知问题
重申一下：
Lucky 是我维护的个人自用小工具，精力有限，合理的建议会听取但也不代表能满足所有人的喜好，AI再厉害Lucky也成为不了所谓安全网关，网络安全形势越来越严峻，希望大家多留个心，多了解一些防护知识。
请把 Lucky 保存的所有信息，都视为系统被攻破或文件泄露后可能被获取。 一旦系统被入侵，或配置、备份文件泄露，请按全部信息可能已泄露处理：更换所有已保存的密码，以及其他服务中复用的密码；撤销或重置相关令牌、密钥。
不同账号、网站和设备尽量各用各的强密码，别一套密码到处用。建议使用密码管理器并开启双因素验证（2FA），不同账号也不要共用同一份 2FA 密钥。
如有遗漏遇到新问题，欢迎继续反馈。
Docker 镜像已更新，群晖 DSM 6.x / 7.x SPK 安装包已提供下载。
群晖软件源：
- release.66666.host/spk
- lucky666.cn/spk
v3.5.0 下载：
- release.66666.host/v3.5.0
- lucky666.cn/release/v3.5.0

### 2.27.2-build.34 (2026-10-22)
底包更新至 9.5.1，无功能变更

### 2.27.2-build.33 (2026-10-10)
CI 变更
- fix(ci): 修复 CHANGELOG 采集到无关历史提交并清理既有噪音

### 2.27.2-build.32 (2026-10-10)
CI 变更
（本次构建无代码变更）

### 2.27.2-build.30 (2026-09-27)
底包更新至 9.5.0，无功能变更

### 2.27.2-build.29 (2026-08-18)
底包更新至 9.4.0，无功能变更

### 2.27.2-build.26 (2026-07-25)
CI 工作流变更
无提交信息

### 2.27.2-build.25 (2026-07-25)
CI 工作流变更
无提交信息

### 2.27.2-build.24 (2026-07-25)
CI 工作流变更
无提交信息

### 2.27.2-build.23 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 2.27.2-build.22 (2026-07-24)
CI 工作流变更
无提交信息

### 2.27.2-build.21 (2026-07-24)
CI 工作流变更
fix(baihu): add BH_SERVER_URL_PREFIX for Ingress support; fix(ci): config/version.yaml changes no longer trigger rebuild

### 2.27.2-build.20 (2026-07-24)
CI 工作流变更
fix(ci): show per-architecture compressed size using regctl in build summary

### 2.27.2-build.19 (2026-07-24)
CI 工作流变更
fix(ci): list built architectures in summary using jq from raw manifest

### 2.27.2-build.18 (2026-07-24)
CI 工作流变更
fix(ci): summary uses always() + remove imagetools; all healthchecks add -o /dev/null

### 2.27.2-build.17 (2026-07-24)
Dockerfile 变更
feat: ja3 curl-impersonate + pycurl-ja3 + sign labels

### 2.27.2-build.16 (2026-07-24)
CI 工作流变更
fix(ci): 过滤 bot 提交避免 CI 自触发 config.yaml 循环重建

### 2.27.2-build.15 (2026-07-24)
CI 工作流变更
fix(ci): file_sha 在 commit 后更新，避免 CI 自触发的 config.yaml 循环重建

### 2.27.2-build.14 (2026-07-23)
config.yaml/version.yaml 变更
build(qdtoday): Dockerfile 变更 → 20250803-build.14

### 2.27.2-build.13 (2026-07-23)
CI 工作流变更
fix(s6): stage2_hook 后台轮询等待 legacy-services 就绪

### 2.27.2-build.12 (2026-07-23)
Dockerfile 变更
feat: S6_STAGE2_HOOK for all S6 addons

### 2.27.2-build.11 (2026-07-23)
config.yaml/version.yaml 变更
build(filebrowser-quantum): CI 工作流变更 → 1.5.0-stable-build.8

### 2.27.2-build.10 (2026-07-23)
CI 工作流变更
fix(s6): cont-init 末尾 rm down 文件，修复 legacy-services 不自动启动

### 2.27.2-build.9 (2026-07-23)
CI 工作流变更\nMerge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - rootfs 脚本/配置变更: fix(s6): run 脚本添加 SIGTERM trap，防止停止时产生孤儿进程

### 2026-07-23 - config.yaml/version.yaml 变更: build(lucky): CI 工作流变更 → 2.27.2-build.6

### 2026-07-23 - CI 工作流变更: docs(skills): ha-addon-conventions 精简为英文核心模式 (220→110行)

### 2026-07-23 - fix(ci): 三处增强保证 rootfs/workflow 变更触发构建

### 2026-07-23 - 手动触发强制重建

### 2026-07-23 - Merge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - 手动触发强制重建

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更

