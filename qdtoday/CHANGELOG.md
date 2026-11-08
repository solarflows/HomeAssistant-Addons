### 20261108-build.1 (2026-11-08)
Dockerfile 变更
- fix(qdtoday): compile pycurl from source and add DNS_SERVERS error handling to resolve CURLE_UNKNOWN_OPTION (48)
- fix(ci): 补齐 qdtoday 20261108 CHANGELOG、优化抓取源并加固 summary 汇报 [skip-rebuild]

### 20261108 (2026-11-08)
### Features

1. Feature(push): 🚀 新增 WxPusher 极简模式推送支持, 降低推送配置门槛 (#632)
2. Feature(update): 🚀 `-v` 支持指定 tag / commit / 分支切换代码; 网络访问点支持镜像源参数
3. Feature(update): 🚀 依赖按 libc 形态分流安装, 版本未变时跳过下载与安装, 解释器版本不足时自动补齐; `update.sh` 在容器外也可自行安装依赖
4. Feature(tools): 🛠️ 新增离线密钥轮换工具, 支持 SQLite 与 MySQL
5. Feature(image): 🐳 新增 `Dockerfile.ja3-lite` 变体, 四条镜像线统一骨架
6. Feature(compliance): 📄 镜像内随附第三方许可证文书; FOSSA 改用 CLI 上传, 一个项目覆盖 Python 层与随包原生库
7. Feature(update): 🚀 声明 `<服务目录>/.venv` 虚拟环境并支持 PATH 优先级提升（默认临时生效, `QD_VENV_PERSIST=1` 可持久化）; 支持 `QD_HOME` 指定服务目录

### Changed

1. Change(depends): 📦 依赖管理迁移到 `pyproject.toml` + `uv.lock`, 依赖安装到 `.venv`; 移除 Pipfile / Pipfile.lock / requirements.txt
2. Change(image): 🏗️ 镜像基座改为纯 Alpine + wheelhouse, 去掉构建时 clone, 依赖来源改为显式契约
3. Change(ci): 🛠️ 多架构构建流程重构, 新增构建计划 / 清单组装 / 标签分配脚本、冒烟闸门与派生 Dockerfile 一致性校验
4. Change(depends): ⬆️ 前后端依赖升级并清理失效依赖与旧构建工具; 节日致贺文案按法定口径调整
5. Docs: 📚 补充镜像标签说明、裸 Alpine 部署、密钥轮换用法、GitHub 加速源与许可声明索引; 修正 python-version badge 与 README 许可段

### Fixed

1. Bugfix(db): 🐛 修复公共模板在 MySQL 下因字段存储上限导致的更新失败
2. Bugfix(ghcr): 🐛 修复多架构发布中标签互相覆盖与清单清理引起的空壳标签 (issue #642), 发布校验同时覆盖清单完整性
3. Bugfix(update): 🐛 修复容器内热更新失效, 以及 glibc 分支、代码包路径、venv 判定、依赖安装回退等边界问题
4. Bugfix(ci): 🐛 修复 push 事件的平台判定、构建输出传递、checkout 缺失与标签分配条件
5. Bugfix(tools): 🐛 修复密钥轮换工具在 SQLite 备份路径与调用方式上的问题
6. Bugfix(fossa): 🐛 FOSSA CLI 安装位置改为按 PATH 解析
7. Bugfix(update): 🐛 修复 BSD / macOS 平台兼容（readlink、getopt、sed -i、mktemp）, 主流程收进 `main()` 避免脚本自更新时执行错位, 更新失败不再返回成功退出码

### Security

1. Security(config): 🔒 会话签名密钥改用 `COOKIE_SIGN_SECRET` 显式配置, 未配置时每次启动随机生成 (`COOKIE_SECRET` 已弃用); `AES_KEY` 变更须先通过 `tools/rotate_aes_key.py` 迁移存量数据, 可用 `AES_KEY_STRICT` 启用严格校验
2. Security(safe_eval): 🔒 收紧模板表达式求值的操作码与可用模块白名单, 适配 Python 3.12~3.14 的字节码变更并补充回归测试
3. Security(web): 🔒 `qs` 升级至 `^6.16.2`（锁定 6.17.1）并同步重新打包随仓库提交的 webpack bundle, 修复该依赖的已知安全问题; 前端依赖补充 `pnpm.overrides` 约束并清理失效依赖
4. Security(deploy): 🔒 清理部署链路中不再使用的凭据与镜像内多余组件, 修正容器内热更新失效


### 20250803-build.52 (2026-11-03)
CI 变更
（本次构建无代码变更）

### 20250803-build.51 (2026-11-03)
CI 变更
（本次构建无代码变更）

### 20250803-build.50 (2026-11-03)
CI 变更
（本次构建无代码变更）

### 20250803-build.49 (2026-10-10)
CI 变更
- fix(ci): 修复 CHANGELOG 采集到无关历史提交并清理既有噪音

### 20250803-build.48 (2026-10-10)
CI 变更
（本次构建无代码变更）

### 20250803-build.44 (2026-07-25)
CI 工作流变更
无提交信息

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

