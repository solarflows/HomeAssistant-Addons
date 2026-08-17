### 1.1.26 (2026-08-17)
# 更新日志 (v1.1.26)

### 2026.08.17 - 通知内容统一与 Options SDK 支持、SSE 实时流状态帧协议、日志全屏删除修复与 Go 1.26 升级

🎉 **新增与优化**
* **通知内容统一与 Options SDK 支持 (New)**：后端全面统一通知内容字段为 `content`（同时兼容历史旧版本 `text` 入参），并新增 `format` 格式定义（`text`/`markdown`/`html`）（#161）；Node.js (`builtin/nodejs/notify.js`) 及 Python (`builtin/python/baihu/notify.py`) 内置 SDK 均统一采用 Options 模式设计（`notify(title, content, options)`），支持多渠道及富文本渲染，且保持完全向下兼容。
* **日志 SSE Stream-as-State 协议 (New)**：重构了任务执行实时日志 SSE 通信机制，引入结构化 `finish` 帧实现任务状态与实时日志流在前端的强一致性联动同步，解决了并发场景下的执行状态延迟和刷新不及时问题。

**✨ 修复与改进**
* **历史日志全屏删除修复 (Fix)**：修复了执行历史中全屏日志查看弹窗（`LogViewer.vue`）因未向外层透传 `@delete` 事件导致删除历史日志不生效的缺陷（#157）。
* **调度器稳定性与锁优化 (Fix)**：修复了取消订阅日志流时偶发的 channel 重复关闭 panic；对 cron 触发读取 scheduler 调度器指针增加读锁保护；优化了重载配置时的锁范围以避免潜在死锁。
* **运行环境与依赖升级**：全面升级 Go 运行时至 1.26，并将两步验证 (`otp`) 升级为直接依赖。

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为 `.zip`）。

#### 🐧 Linux 平台

**1. 安装前置依赖 `mise`**

单文件直接运行依赖宿主机系统环境，请务必先安装 [mise](https://mise.jdx.dev/getting-started.html) 供任务调度及环境管理使用：

```bash
curl https://mise.run | sh
export PATH="~/.local/share/mise/bin:~/.local/share/mise/shims:$PATH"
```

**2. 运行面板**

```bash
tar -xzvf baihu-linux-amd64.tar.gz
chmod +x baihu-linux-amd64
./baihu-linux-amd64 server
```

#### 🪟 Windows 平台

**1. 安装前置依赖**

* **安装 `mise`**（用于统一依赖和运行时环境管理）：

  在 PowerShell 中运行以下命令使用 `winget` 安装：
  ```powershell
  winget install jdx.mise
  ```

* **安装 `pwsh`**（PowerShell 7.6+，用于执行后台任务）：

  白虎面板在 Windows 下运行任务和工具链强依赖 PowerShell 7+。请参考 [微软官方 PowerShell 安装文档](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6) 安装，或通过 `winget` 快捷安装：
  ```powershell
  winget install Microsoft.PowerShell
  ```

**2. 运行面板**

解压下载好的 `.zip` 压缩包，进入解压目录并打开 PowerShell，运行：

```powershell
.\baihu.exe server
```

---

**访问面板：**
* 启动后访问：`http://localhost:8052`
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。



### 1.1.25 (2026-08-10)
# 更新日志 (v1.1.25)

### 2026.08.10 - 企业微信应用通知、备份恢复自动调度刷新与安全漏洞修复

🎉 **新增与优化**
* **企业微信应用通道支持 (New)**：消息推送原生集成企业微信应用（QyWeiXinApp）通知渠道（#152），支持更全面的企业级推送能力。

**✨ 修复与改进**
* **备份恢复调度自动加载 (Fix)**：修复了从备份中恢复任务后，定时任务必须重新禁用启用才生效的 Bug（#153）。现在备份恢复成功后会自动向事件总线发布事件，以刷新并重新加载内存中的定时任务调度。
* **依赖安全漏洞修复 (Security)**：升级了 `fast-uri`、`dompurify`、`nanoid`、`brace-expansion` 等受漏洞影响的第三方依赖，彻底修复了 Dependabot 检测出的 4 个安全漏洞。

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为 `.zip`）。

#### 🐧 Linux 平台

**1. 安装前置依赖 `mise`**

单文件直接运行依赖宿主机系统环境，请务必先安装 [mise](https://mise.jdx.dev/getting-started.html) 供任务调度及环境管理使用：

```bash
curl https://mise.run | sh
export PATH="~/.local/share/mise/bin:~/.local/share/mise/shims:$PATH"
```

**2. 运行面板**

```bash
tar -xzvf baihu-linux-amd64.tar.gz
chmod +x baihu-linux-amd64
./baihu-linux-amd64 server
```

#### 🪟 Windows 平台

**1. 安装前置依赖**

* **安装 `mise`**（用于统一依赖和运行时环境管理）：

  在 PowerShell 中运行以下命令使用 `winget` 安装：
  ```powershell
  winget install jdx.mise
  ```

* **安装 `pwsh`**（PowerShell 7.6+，用于执行后台任务）：

  白虎面板在 Windows 下运行任务和工具链强依赖 PowerShell 7+。请参考 [微软官方 PowerShell 安装文档](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6) 安装，或通过 `winget` 快捷安装：
  ```powershell
  winget install Microsoft.PowerShell
  ```

**2. 运行面板**

解压下载好的 `.zip` 压缩包，进入解压目录并打开 PowerShell，运行：

```powershell
.\baihu.exe server
```

---

**访问面板：**
* 启动后访问：`http://localhost:8052`
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.1.24 (2026-07-31)
# 更新日志 (v1.1.24)

### 2026.07.31 - 标签管理、编辑器多语言高亮、登录两步验证与响应式布局优化

🎉 **新增与优化**
* **全新标签管理功能 (New)**：新增了独立的“标签管理”后台服务及前端控制页，支持对系统内任务标签（`task_tag`）与环境变量标签（`env_tag`）进行创建、重命名、删除、分页、过滤等操作，并引入了标签名称的全局排重机制。
* **Monaco 多语言语法高亮支持 (New)**：编辑器组件扩展支持了 Python, JavaScript/TypeScript, Go, Shell/Bash 等多种主流语言的开箱即用语法高亮，优化了编辑器编码体验。
* **登录 2FA/OTP 二步验证 (New)**：系统全新集成了两步验证（OTP/2FA），支持管理员账号在系统设置页绑定和启用/停用 OTP，并配套重构了登录界面、OTP 验证码拦截以及安全防爆破拦截。同时在后台重构并平坦化了 OTP 设置页的移动端自适应排版。
* **极简图标与响应式布局升级**：重新设计了标签类型标识，舍弃了传统的徽章卡片背景 and 文字，直接以蓝色终端图标（任务）和橙色变量图标（变量）做纯视觉区分；针对移动端/小屏模式重构优化了控制工具栏、按钮的排列换行方式；并统筹统一了“环境变量”及“定时任务”页面移动端卡片底栏网格动作按钮的间距和贴边排版。
* **互联管理控制栏优化**：修复了“互联管理”页面在小屏宽度下由于没有换行导致“同步”页签按钮被半截截断溢出的 UI Bug；设计了两行自适应移动端布局，实现了搜索输入框、刷新按钮与各操作页签的上下视觉平衡，且在切换至无搜索框的“同步”标签时，自动收缩为空行以避免排版漏洞。

**✨ 修复与改进**
* **修复登录接口多重 JSON 响应 Bug**：修复了登录校验失败时后端可能同时吐出多个 JSON 结构体导致的 JSON 序列化损坏及前端无响应 Bug，完善了前端错误捕获提醒。
* **其他细节修复与依赖升级**：修复了推送日志清理按钮偶尔无响应的问题（#23）；升级了多处有安全漏洞的 npm 依赖项以消除 Dependabot 警报。

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为 `.zip`）。

#### 🐧 Linux 平台

**1. 安装前置依赖 `mise`**

单文件直接运行依赖宿主机系统环境，请务必先安装 [mise](https://mise.jdx.dev/getting-started.html) 供任务调度及环境管理使用：

```bash
curl https://mise.run | sh
export PATH="~/.local/share/mise/bin:~/.local/share/mise/shims:$PATH"
```

**2. 运行面板**

```bash
tar -xzvf baihu-linux-amd64.tar.gz
chmod +x baihu-linux-amd64
./baihu-linux-amd64 server
```

#### 🪟 Windows 平台

**1. 安装前置依赖**

* **安装 `mise`**（用于统一依赖和运行时环境管理）：

  在 PowerShell 中运行以下命令使用 `winget` 安装：
  ```powershell
  winget install jdx.mise
  ```

* **安装 `pwsh`**（PowerShell 7.6+，用于执行后台任务）：

  白虎面板在 Windows 下运行任务和工具链强依赖 PowerShell 7+。请参考 [微软官方 PowerShell 安装文档](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6) 安装，或通过 `winget` 快捷安装：
  ```powershell
  winget install Microsoft.PowerShell
  ```

**2. 运行面板**

解压下载好的 `.zip` 压缩包，进入解压目录并打开 PowerShell，运行：

```powershell
.\baihu.exe server
```

---

**访问面板：**
* 启动后访问：`http://localhost:8052`
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.1.23-build.10 (2026-07-28)
Dockerfile + rootfs 变更
- fix(baihu-panel): healthcheck 使用原生 /api/v1/ping 端点
- fix(baihu-panel): 修复 Ingress 子路径并持久化到 /config/baihu-panel/
- fix(baihu-panel): 修复 Ingress 静态资源加载并清理内部配置暴露
- docs: 为所有 9 个加载项添加/更新 analysis.yaml 文档
- fix: standalone 创建 /data/atv/config/ + baihu /app/data 持久化 symlink

### 1.1.23-build.9 (2026-07-28)
Dockerfile + rootfs 变更
- fix(baihu-panel): healthcheck 使用原生 /api/v1/ping 端点

### 1.1.23-build.8 (2026-07-28)
Dockerfile + rootfs 变更
- fix(baihu-panel): 修复 Ingress 子路径并持久化到 /config/baihu-panel/

### 1.1.23-build.7 (2026-07-27)
Dockerfile + rootfs 变更
- fix(baihu-panel): 修复 Ingress 静态资源加载并清理内部配置暴露
- docs: 为所有 9 个加载项添加/更新 analysis.yaml 文档

### 1.1.23-build.6 (2026-07-25)
rootfs 变更
- fix: standalone 创建 /data/atv/config/ + baihu /app/data 持久化 symlink
- build(baihu-panel): CI 变更 → 1.1.23-build.5

### 1.1.23-build.5 (2026-07-25)
CI 变更
- build(baihu-panel): CI 变更 → 1.1.23-build.4

### 1.1.23-build.4 (2026-07-25)
CI 变更
- build(baihu-panel): CI 工作流变更 → 1.1.23-build.3

### 1.1.23-build.3 (2026-07-25)
CI 工作流变更
无提交信息

### 1.1.23-build.2 (2026-07-25)
CI 工作流变更
无提交信息

### 1.1.23-build.1 (2026-07-25)
CI 工作流变更
无提交信息

### 1.1.23 (2026-07-25)
# 更新日志 (v1.1.23)

### 2026.07.23 - Windows GUI 安装包与系统托盘守护程序

🎉 **新增与优化**
* **Windows GUI 安装包 (New)**：新增了 Inno Setup 打包脚本 (`build/windows/installer.iss`)，可自动打出 Windows 标准 `.exe` 安装向导（支持引导界面、桌面快捷方式创建、自动注册系统自启与卸载）。
* **Windows 系统托盘守护程序 (New)**：新增了 Golang 后台托盘 GUI 辅助程序 (`cmd/tray/main.go` -> `baihu-tray.exe`)，支持任务栏右下角菜单交互（一键打开网页面板、服务重启、状态监控、开机自启开关）。
* **Makefile & Release CI 集成**：更新了 `Makefile` 构建目标（`release-windows-tray` 与 `pack-windows-installer`），并在 GitHub Actions 发布工作流中引入 `action-innosetup`，每次 Tag 发布时将自动编译并打包导出安装包产物 (`BaihuPanel-Setup-v*.exe`)。

---

### 2026.07.20 - Windows 平台深度适配、网页终端 Ctrl+C 中止与 Linux PTY 回退机制修复

🎉 **新增与优化**
* **Windows 平台适配包重构**：新建并集成了后端 `internal/windows` 与前端 `web/src/windows` 专有包，统一收拢 Windows 的特异性环境检测、PSReadline 影响规避、PATH 优先级修复 (FixPathEnv) 等底层逻辑，大幅提升了在 Windows 平台直接运行时的环境稳定性与规范度。
* **网页终端 Ctrl+C 中断支持**：支持了 Windows 网页终端下通过快捷键 `Ctrl+C` 中止运行中程序，后端会拦截 `\x03` 信号并调用 `taskkill /F /T` 强行递归终结前台子进程树，并保持外层 Shell 会话完好，与 Linux/macOS 的体验全面看齐。
* **Monaco 编辑器高亮与检测**：前端编辑器新增了保存脚本时的风险警告拦截审查 (`scriptCheck.ts`)，针对 `timeout` 或 `pause` 等后台挂起指令给出安全平替建议；同时为 Monaco 编辑器补齐了 `.bat`、`.cmd`、`.ps1` 等 Windows 脚本语言的语法高亮支持。
* **编译与自动化发布**：在 `Makefile` 中添加了跨平台编译 Windows 二进制的 `release-windows` 目标；重构了 GitHub Actions 自动发布工作流 `.github/workflows/release.yml`，在发布时自动编译并打包 Windows 平台的单文件发布包 (`baihu-windows-amd64.zip`) 并自动上传 Release 附件。
* **xterm 终端换行 Bug 修复**：开启了终端组件的 `convertEol: true` 自动换行翻译配置，彻底解决了 Windows 管道重定向模式下，因 Shell 回显单 `\n` 导致首行输出排版乱折行的排版问题。
* **Windows 部署使用文档**：更新了部署说明文档，新增了“二进制单文件运行 (Linux / Windows)”专栏，细化了 `mise` 以及 `pwsh 7+` 工具链的安装指导。

**✨ 修复与改进**
* **脚本执行参数校验**：修复了在“测试运行” Windows 脚本时，即便不需要运行环境也会强行拼接 `python` / `node` 执行器前缀导致命令无法执行的缺陷。
* **Linux PTY 回退机制修复**：修复了 Linux 环境下 PTY 分配失败（如 `ioctl` 错误）时，因 `exec.Cmd` 实例被占用重用触发 `already started` 导致的崩溃挂起，同时确保回退后的命令完整保留超时控制。

---

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为 `.zip`）。

#### 🐧 Linux 平台

**1. 安装前置依赖 `mise`**

单文件直接运行依赖宿主机系统环境，请务必先安装 [mise](https://mise.jdx.dev/getting-started.html) 供任务调度及环境管理使用：

```bash
curl https://mise.run | sh
export PATH="~/.local/share/mise/bin:~/.local/share/mise/shims:$PATH"
```

**2. 运行面板**

```bash
tar -xzvf baihu-linux-amd64.tar.gz
chmod +x baihu-linux-amd64
./baihu-linux-amd64 server
```

#### 🪟 Windows 平台

**1. 安装前置依赖**

* **安装 `mise`**（用于统一依赖和运行时环境管理）：

  在 PowerShell 中运行以下命令使用 `winget` 安装：
  ```powershell
  winget install jdx.mise
  ```

* **安装 `pwsh`**（PowerShell 7.6+，用于执行后台任务）：

  白虎面板在 Windows 下运行任务和工具链强依赖 PowerShell 7+。请参考 [微软官方 PowerShell 安装文档](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6) 安装，或通过 `winget` 快捷安装：
  ```powershell
  winget install Microsoft.PowerShell
  ```

**2. 运行面板**

解压下载好的 `.zip` 压缩包，进入解压目录并打开 PowerShell，运行：

```powershell
.\baihu.exe server
```

---

**访问面板：**
* 启动后访问：`http://localhost:8052`
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.1.22-build.26 (2026-07-25)
Dockerfile 变更
无提交信息

### 1.1.22-build.25 (2026-07-24)
CI 工作流变更
无提交信息

### 1.1.22-build.24 (2026-07-24)
rootfs 脚本/配置变更
build(baihu-panel): rootfs 脚本/配置变更 → 1.1.22-build.23

### 1.1.22-build.23 (2026-07-24)
rootfs 脚本/配置变更
fix(qdtoday): revert to --prefix with safe shell-glob bridge for dist-packages

### 1.1.22-build.22 (2026-07-24)
CI 工作流变更
fix(baihu): add BH_SERVER_URL_PREFIX for Ingress support; fix(ci): config/version.yaml changes no longer trigger rebuild

### 1.1.22-build.21 (2026-07-24)
Dockerfile 变更
fix(qdtoday): remove obsolete site-packages→dist-packages bridge — no longer needed with same-base builder

### 1.1.22-build.20 (2026-07-24)
CI 工作流变更
fix(ci): show per-architecture compressed size using regctl in build summary

### 1.1.22-build.19 (2026-07-24)
CI 工作流变更
fix(ci): list built architectures in summary using jq from raw manifest

### 1.1.22-build.18 (2026-07-24)
CI 工作流变更
fix(ci): summary uses always() + remove imagetools; all healthchecks add -o /dev/null

### 1.1.22-build.17 (2026-07-24)
Dockerfile 变更
feat: ja3 curl-impersonate + pycurl-ja3 + sign labels

### 1.1.22-build.16 (2026-07-24)
CI 工作流变更
fix(ci): 过滤 bot 提交避免 CI 自触发 config.yaml 循环重建

### 1.1.22-build.15 (2026-07-24)
CI 工作流变更
fix(ci): file_sha 在 commit 后更新，避免 CI 自触发的 config.yaml 循环重建

### 1.1.22-build.14 (2026-07-23)
config.yaml/version.yaml 变更
build(qdtoday): Dockerfile 变更 → 20250803-build.14

### 1.1.22-build.13 (2026-07-23)
CI 工作流变更
fix(s6): stage2_hook 后台轮询等待 legacy-services 就绪

### 1.1.22-build.12 (2026-07-23)
Dockerfile 变更
feat: S6_STAGE2_HOOK for all S6 addons

### 1.1.22-build.11 (2026-07-23)
config.yaml/version.yaml 变更
build(filebrowser-quantum): CI 工作流变更 → 1.5.0-stable-build.8

### 1.1.22-build.10 (2026-07-23)
CI 工作流变更
fix(s6): cont-init 末尾 rm down 文件，修复 legacy-services 不自动启动

### 1.1.22-build.9 (2026-07-23)
CI 工作流变更\nMerge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - rootfs 脚本/配置变更: fix(s6): run 脚本添加 SIGTERM trap，防止停止时产生孤儿进程

### 2026-07-23 - config.yaml/version.yaml 变更: build(lucky): CI 工作流变更 → 2.27.2-build.6

### 2026-07-23 - CI 工作流变更: docs(skills): ha-addon-conventions 精简为英文核心模式 (220→110行)

### 2026-07-23 - fix(ci): 三处增强保证 rootfs/workflow 变更触发构建

### 2026-07-23 - 手动触发强制重建

### 2026-07-23 - Merge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - 手动触发强制重建

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更


### 1.1.22 (2026-07-21)
# 更新日志 (v1.1.22)

### 2026.07.20 - Windows 平台深度适配、网页终端 Ctrl+C 中止与 Linux PTY 回退机制修复

🎉 **新增与优化**
* **Windows 平台适配包重构**：新建并集成了后端 `internal/windows` 与前端 `web/src/windows` 专有包，统一收拢 Windows 的特异性环境检测、PSReadline 影响规避、PATH 优先级修复 (FixPathEnv) 等底层逻辑，大幅提升了在 Windows 平台直接运行时的环境稳定性与规范度。
* **网页终端 Ctrl+C 中断支持**：支持了 Windows 网页终端下通过快捷键 `Ctrl+C` 中止运行中程序，后端会拦截 `\x03` 信号并调用 `taskkill /F /T` 强行递归终结前台子进程树，并保持外层 Shell 会话完好，与 Linux/macOS 的体验全面看齐。
* **Monaco 编辑器高亮与检测**：前端编辑器新增了保存脚本时的风险警告拦截审查 (`scriptCheck.ts`)，针对 `timeout` 或 `pause` 等后台挂起指令给出安全平替建议；同时为 Monaco 编辑器补齐了 `.bat`、`.cmd`、`.ps1` 等 Windows 脚本语言的语法高亮支持。
* **编译与自动化发布**：在 `Makefile` 中添加了跨平台编译 Windows 二进制的 `release-windows` 目标；重构了 GitHub Actions 自动发布工作流 `.github/workflows/release.yml`，在发布时自动编译并打包 Windows 平台的单文件发布包 (`baihu-windows-amd64.zip`) 并自动上传 Release 附件。
* **xterm 终端换行 Bug 修复**：开启了终端组件的 `convertEol: true` 自动换行翻译配置，彻底解决了 Windows 管道重定向模式下，因 Shell 回显单 `\n` 导致首行输出排版乱折行的排版问题。
* **Windows 部署使用文档**：更新了部署说明文档，新增了“二进制单文件运行 (Linux / Windows)”专栏，细化了 `mise` 以及 `pwsh 7+` 工具链的安装指导。

**✨ 修复与改进**
* **脚本执行参数校验**：修复了在“测试运行” Windows 脚本时，即便不需要运行环境也会强行拼接 `python` / `node` 执行器前缀导致命令无法执行的缺陷。
* **Linux PTY 回退机制修复**：修复了 Linux 环境下 PTY 分配失败（如 `ioctl` 错误）时，因 `exec.Cmd` 实例被占用重用触发 `already started` 导致的崩溃挂起，同时确保回退后的命令完整保留超时控制。

---

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为 `.zip`）。

#### 🐧 Linux 平台

**1. 安装前置依赖 `mise`**

单文件直接运行依赖宿主机系统环境，请务必先安装 [mise](https://mise.jdx.dev/getting-started.html) 供任务调度及环境管理使用：

```bash
curl https://mise.run | sh
export PATH="~/.local/share/mise/bin:~/.local/share/mise/shims:$PATH"
```

**2. 运行面板**

```bash
tar -xzvf baihu-linux-amd64.tar.gz
chmod +x baihu-linux-amd64
./baihu-linux-amd64 server
```

#### 🪟 Windows 平台

**1. 安装前置依赖**

* **安装 `mise`**（用于统一依赖和运行时环境管理）：

  在 PowerShell 中运行以下命令使用 `winget` 安装：
  ```powershell
  winget install jdx.mise
  ```

* **安装 `pwsh`**（PowerShell 7.6+，用于执行后台任务）：

  白虎面板在 Windows 下运行任务和工具链强依赖 PowerShell 7+。请参考 [微软官方 PowerShell 安装文档](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6) 安装，或通过 `winget` 快捷安装：
  ```powershell
  winget install Microsoft.PowerShell
  ```

**2. 运行面板**

解压下载好的 `.zip` 压缩包，进入解压目录并打开 PowerShell，运行：

```powershell
.\baihu.exe server
```

---

**访问面板：**
* 启动后访问：`http://localhost:8052`
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。



