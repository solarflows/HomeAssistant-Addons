### 1.5.1-build.1 (2026-10-10)
CI 变更
- chore(baihu-panel): upstream 1.5.0 → 1.5.1

### 1.5.1 (2026-10-09)
# 更新日志 (v1.5.1)

### 2026.10.09 - Windows托盘无黑窗静默运行、容器内存口径对齐Docker Stats、OpenAPI MCP服务健壮性加固

🎉 **新增功能与体验升级**
* **Windows 系统托盘无黑窗静默运行与更新检测优化 (Tray & Windows & Perf)**：
  - **全链路无黑窗静默执行**：封装 `silentCmd` 底层命令执行工具，统一注入 `HideWindow: true` 与 `CREATE_NO_WINDOW (0x08000000)` 标志位；彻底消除 Windows 系统托盘启动、后台定时检查更新 (`baihu.exe version`)、服务重启与停止 (`taskkill`)、自动升级批处理脚本触发时弹出的黑控制台/黑屏闪烁问题；
  - **版本号缓存优化**：引入 `sync.Once` 本地版本号单例缓存机制，避免后台 2 小时定时器或右键菜单重复唤起外部进程获取版本。
* **容器内存优化与 Docker Stats 官方相减算法对齐 (MemOpt & Docker & Perf)**：
  - **Docker Stats 真实占用口径对齐**：引入 Docker CLI 官方标准的相减计算规则 `docker_stats_used = total_usage - inactive_file`，彻底解决控制台日志所报 Page Cache 与宿主机 `docker stats` 显示严重对不上的口径错位问题；
  - **cgroup v1/v2 双架构真实账本解析**：结构化提取 `memory.current` / `memory.usage_in_bytes`、`memory.max` / `memory.limit_in_bytes` 与 `memory.stat` 完整账本；
  - **自适应控存巡检日志重构**：容器自适应巡检日志透明并列输出 Docker 真实物理占用、内存上限使用率及 Page Cache 缓存回收效果；
  - **安全文件类型断言**：增加 `IsRegular` 普通文件类型断言，遍历缓存清理时安全跳过特殊设备、管道及 Unix 套接字文件，杜绝异常 IO；
  - **服务启动时序调优**：收拢 Mise 环境扫描读盘缓存的首次回收至 Web 服务对外监听之前；Docker 启动脚本新增 `dropcache` 主动卸载镜像启动初期的读盘缓存；
  - **架构深度收敛**：移除 `utils/runtime` 空壳层，底层内存管理与优化模块彻底收敛统一至 `internal/memopt`。
* **OpenAPI 与 MCP 协议服务健壮性加固 (MCP & OpenAPI & Fix)**：
  - **依赖注入空指针修复**：修复在 OpenAPI 模式下调用 MCP SSE 路由时，因未完整挂载 `FileService`、`AppService`、`NotifyService` 引发的 nil 指针 Panic 缺陷（[#187](https://github.com/engigu/baihu-panel/issues/187)）；
  - **自动兜底补全与全局恢复**：引入基于 `cmp.Or` 与惰性初始化的 `EnsureDefaults()` 依赖补全兜底机制；挂载 `server.WithRecovery()` 全局恢复中间件，保障 MCP 服务的极致高可用与容错。
* **DevOps 现代紧凑风格任务耗时与运行时长优化 (Task & Settings & Style)**：
  - **任务耗时 DevOps 紧凑化**：全链路将定时任务执行耗时重构为现代化紧凑格式（如 `1m 23s`、`450ms`），直观清晰；
  - **服务运行时长前端统一格式化**：关于页面后端仅返回服务运行秒数数值，由前端统一实现紧凑/完整时长自适应排版及悬停 Tooltip 提示，并移除冗余版本标签。
* **声明式应用 YAML 清单预览、复制与导出 (AppStore & Tasks & UI)**：
  - **应用市场清单查看**：应用市场详情弹窗支持直接预览应用标准化 `app.yaml` 清单，提供一键复制与下载能力；
  - **配置导出统一复用**：定时任务列表“导出应用配置”弹窗全面复用应用市场专业 YAML 代码高亮预览组件。
* **系统调度与连接池自适应缩容 (Goroutine & DB & Perf)**：
  - **后台清理任务统一收拢**：将系统定期垃圾回收、日志归档与空闲资源清理任务收拢至统一的 `SysCron` 调度架构；
  - **数据库连接池空闲缩容**：根据系统空闲周期动态缩容数据库空闲连接，降低低峰期系统句柄与常驻内存开销。
* **加速源与镜像矩阵统一 (Mirrors & Network)**：
  - 前后端统一封装加速源与镜像矩阵，首选 `gh-proxy` 并标准化浏览器 User-Agent 请求头。

---

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件/安装包部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为安装包 `.exe` 或 `.zip`）。

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

* **方式一：使用 GUI 安装包安装（推荐）**

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.1-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.0 (2026-10-07)
# 更新日志 (v1.5.0)

### 2026.10.07 - 原生内置 Model Context Protocol (MCP) 服务、Server酱推送通道、向导式通知渠道网格、文件树懒加载与全局检索、Agent 实时同步与 Windows 二进制支持

🎉 **新增功能与体验升级**
* **原生内置 Model Context Protocol (MCP) 协议服务支持 (Major Feature & AI)**：
  - **全套原子运维工具集**：原生集成 24 个全生命周期原子运维工具，包含定时任务管理（增删改查、手动执行、超时强制终止）、声明式应用与官方应用商店全流程管控（检索、安装、切换运行场景、级联卸载）、环境变量安全脱敏读写、脚本沙箱文件管理、执行历史日志与空间清理、Git 仓库绑定与即时拉取、多渠道消息通知连通性自检与自定义告警推送（[#182](https://github.com/engigu/baihu-panel/pull/182)）；
  - **7 组上下文资源与智能诊断 Prompt 模板**：提供系统运行状态、通知渠道、已装应用、Git仓库、任务模型、执行日志及脚本源码的 URI 资源引入；内置任务失败智能归因排查 (`diagnose_task_failure`) 与自然语言生成定时任务 (`create_scheduled_task`) Prompt 模板；
  - **双传输协议支持**：支持远程网络传输（SSE/HTTP）与 CLI Stdio 子进程本地管道传输，自动隔离控制台输出保障标准 JSON-RPC 纯净通信；
  - **严格并发与协程控制**：内置 `ToolConcurrencyLimiter(4)` 中间件限制并发调用，排队超时自动熔断；限制活跃 SSE 连接数（$\le 3$），单客户端仅占用 2 协程，零任务常驻协程；
  - **可视化设置与指南**：站点设置中心新增“AI 客户端连接 (MCP)”指引面板，支持一键复制 SSE 链接与客户端配置 JSON，并提供官方文档。
* **ServerChan（Server酱）消息推送通道支持 (Feature & Notify)**：
  - 消息通知中心原生集成 ServerChan（Server酱·Turbo版）通知渠道，支持 SendKey 配置与连通性即时自检（[#183](https://github.com/engigu/baihu-panel/pull/183)）。
* **通知渠道添加流程交互重构 (UI & Refactor)**：
  - 将通知渠道选择升级为现代向导式卡片网格，醒目展示品牌图标、定位用途与特性支持；精简配置项并优化表单分组，大幅降低配置门槛。
* **脚本文件管理全流程重构 (Files & Editor & OpenAPI)**：
  - **文件树按需懒加载 (Lazy Load)**：重构文件树加载机制为按需懒加载，大幅提升海量脚本与深层嵌套目录下的浏览性能与首屏渲染速度；
  - **全盘模糊检索**：支持脚本目录树全局文件名与相对路径模糊搜索，前端设置中心新增搜索结果数量上限调节；
  - **OpenAPI 深度集成**：脚本文件树遍历、源码读取、沙箱写入与安全删除能力全量开放接入 OpenAPI 接口。
* **集群 Agent 深度演进与 Windows 客户端支持 (Agent & Windows)**：
  - **实时增量同步体系**：新增 Agent 脚本多目录精准实时变动监听与增量同步机制，支持防抖事件合并与监听休眠机制，避免无效 IO；
  - **物理内存深度优化**：优化 Agent 进程驻留内存管理，高频修改后主动触发物理内存回收与系统句柄释放；
  - **Windows Agent 正式发布**：CI/CD 产物流水线正式集成 Windows 二进制 Agent 打包；重构下载弹窗为全平台分类标签，提供一键复制的完整初始化命令集。

✨ **问题修复与细节打磨**
* **日志详情终端自适应排版修复 (Web & Fix)**：
  - 修复任务执行日志详情弹窗/侧边栏展开瞬间列宽未稳定导致的 5 字窄折行与右侧留白问题；新增 `fitAndRefresh` 列宽动态监测与多阶段尺寸校准，列宽变化时自动按真实全宽重新平铺渲染；
  - 优化日志 SSE 瞬时并发落库时的防抖查库与系统提示回车换行格式。
* **界面细节与小屏响应式排版优化 (Style & UI)**：
  - 优化“关于”页面在移动端小屏设备下的卡片网格排版与文本对齐；
  - 统一站点设置中心小屏设备下的按钮间距与表单交互风格。
* **安全依赖升级与 Dependabot 漏洞清零 (Security)**：
  - 升级 `vue` 至 `3.5.43`，修复 `@vue/server-renderer` XSS 漏洞；
  - 锁定升级 `source-map-js`（1.2.2）、`brace-expansion`（5.0.12）、`fast-uri`（3.1.8）、`dompurify`（3.4.16）；
  - 修正 `nanoid` 为 CommonJS 兼容版本 `3.3.20`，彻底消除 7 项安全漏洞告警。

---

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件/安装包部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为安装包 `.exe` 或 `.zip`）。

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

* **方式一：使用 GUI 安装包安装（推荐）**

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.0-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.4.2 (2026-09-30)
# 更新日志 (v1.4.2)

### 2026.10.01 - 系统设置全模块视觉与交互重构、声明式应用卸载级联清理与标签自动回收、Windows托盘更新弹窗优化

🎉 **新增功能与体验升级**
* **系统设置全模块视觉与交互体验深度重构 (Feature & UI & Refactor)**：
  - **安全设置解耦与 2FA 体验升级**：彻底解耦原有嵌套套娃卡片结构，将管理员凭据独立为身份卡并支持密码明密文快捷切换；2FA 两步验证新增安全盾安全等级评估、主流身份验证器客户端配置指引与极简状态卡；
  - **站点设置模块化布局与体验打磨**：站点设置重构为 2x2 模块化对称网格布局（站点外观、OpenAPI 开放接口、日志生命周期与自动清理、配置保存与生效）；优化日志清理策略为横向行式条目，数字输入框去除原生调节箭头并优化单位贴合排版；
  - **前端定制主题画廊网格与防白屏救生命令**：废弃冗长表格，升级为现代主题画廊卡片网格，展示主题名称、作者、版本及一键预览切换；新增终端防白屏应急恢复命令一键复制功能，支持现代拖拽上传；
  - **调度设置参数矩阵与硬件规格一键套用**：重组为核心并发参数与机制指南双列卡片，新增基于服务器硬件规格（1C1G、2C2G、4C4G 等）的推荐配置矩阵与一键套用功能；
  - **备份恢复双卡片并排与拖拽上传**：重构为系统快照与数据恢复双卡片并排，集成备份状态指示器与交互式拖拽区，简化操作链路；
  - **关于页面品牌质感提升**：采用单/双卡片一体化视觉，引入 Inter 字体现代排印的高质感数值卡，恢复完整开源免责声明并优化排版；
  - **代码规范与样式告警清理**：清理容器与子组件未使用的图标与变量，补充标准 `appearance` 兼容性属性，消除所有 TypeScript 与 CSS 兼容性告警。
* **声明式应用卸载级联清理与标签自动回收 (Feature & App)**：
  - **环境变量安全级联清理**：卸载应用时支持 `CleanEnvs` 选项，精准分析并安全清理未被其他任务复用的关联环境变量，避免变量遗留与数据冗余；
  - **孤儿标签自动回收**：新增孤儿标签自动清理机制，卸载应用后自动识别并删除无外部引用的任务标签与环境变量标签；
  - **调度器精准同步注销**：卸载应用时同步从底层调度器 (`CronManager`) 中移除主任务及所有受控子任务的 Cron 计划与执行上下文。

✨ **问题修复与交互体验优化**
* **Checkbox 默认勾选修复与弹窗交互体验增强 (UI & Fix)**：
  - 修复底层 Checkbox 组件默认勾选无效缺陷，应用卸载确认弹窗默认勾选“级联清理关联环境变量”；
  - 任务与应用删除弹窗接入统一 Loading 状态与防重复点击保护，增强操作交互反馈；
  - 修复 DialogContent 背景残留导致的 WAI-ARIA `aria-hidden` 控制台警告。
* **Windows 托盘更新弹窗优化 (Fix & Tray)**：
  - 优化 Windows 系统托盘程序的新版本更新提示弹窗，支持内容区域平滑滚动，保证长更新日志能够完整清晰展示。

---

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件/安装包部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为安装包 `.exe` 或 `.zip`）。

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

* **方式一：使用 GUI 安装包安装（推荐）**

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.4.2-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.4.1 (2026-09-30)
# 更新日志 (v1.4.1)

### 2026.09.30 - 远程 Agent 工作目录解析修复、Windows Agent Shell 免依赖回退、Bark 动态参数覆盖与安全加固

🎉 **新增功能与体验升级**
* **Windows Agent Shell 免依赖降级回退支持 (Feature & Agent)**：
  - **自动回退内置 PowerShell**：针对 Windows 远程 Agent 节点开放 Shell 降级策略，当受控机器未安装 PowerShell 7 (`pwsh.exe`) 时自动回退使用系统自带的 `powershell.exe`，实现单二进制零依赖开箱即用（主面板服务端仍保持 `pwsh` 强校验）。
* **Bark 推送动态参数覆盖与内置 SDK 增强 (Feature)**：
  - **发送级个性化参数覆盖**：Bark 通知渠道支持在调用发送接口时通过 `options` 动态传入额外参数（如 `group`、`icon`、`url`、`sound`、`level`、`badge` 等），按需灵活覆盖渠道全局默认配置（[#179](https://github.com/engigu/baihu-panel/pull/179)）；
  - **多语言内置 SDK 同步升级**：同步更新内置 Python (`notify.py`) 与 Node.js (`notify.js`) 通知助手库及使用文档，无缝支持透传渠道扩展参数。
* **演示模式备份安全加固与文档升级 (Security & Docs)**：
  - **演示模式严禁备份导出**：在演示模式下（`BH_DEMO_MODE=true`）全面拦截并禁止创建与下载系统备份文件，防止公共演示环境数据或配置通过备份接口外泄；
  - **文档与 README 视觉排版优化**：重构 README 排版结构，采用 GitHub 原生告警块与轻量矢量徽章，新增贡献者头像墙与社区交流群入口。

✨ **问题修复与交互体验优化**
* **远程 Agent 任务工作目录解析修复与执行优化 (Fix & Agent)**：
  - **消除 `$SCRIPTS_DIR$` 占位符污染**：修复 Agent 远程任务在创建、更新及切换启用开关时工作目录被错误归一化为面板本地 `$SCRIPTS_DIR$` 占位符（导致远程节点启动进程报错 `no such file or directory`）的缺陷，并对数据库历史存量脏数据实现全链路自动清洗与无损还原；
  - **跨平台盘符路径精准识别**：新增跨平台绝对路径识别，修复 Linux 服务端向 Windows Agent 下发盘符路径（如 `C:\...`）时被误判为相对路径并错误拼接 `$SCRIPTS_DIR$/` 前缀的问题；
  - **禁用任务手动触发与实时目录透传**：修复禁用状态或未配置 Cron 表达式的 Agent 任务无法通过面板点击“立即运行”的问题，并在下发立即执行指令时实时透传最新工作目录。
* **全局时间显示统一与界面细节打磨 (UI & Fix)**：
  - **时间格式化与状态展示优化**：统一应用市场、任务编辑、运行日志、通知渠道、系统监控及备份列表的时间友好度显示；禁用状态的任务隐藏无意义的“下次运行时间”；登录日志查询 IP 归属地失败时静默处理不再弹窗打扰（[#180](https://github.com/engigu/baihu-panel/pull/180)）。

---

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件/安装包部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为安装包 `.exe` 或 `.zip`）。

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

* **方式一：使用 GUI 安装包安装（推荐）**

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.4.1-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.4.0 (2026-09-29)
# 更新日志 (v1.4.0)

### 2026.09.29 - RESTful 状态码与业务码双轨对齐、Bark 端到端加密推送、任务深层目录展开、安全防护与体验全面升级

🎉 **新增功能与架构改进**
* **HTTP 状态码与业务码双轨对齐规范 (Architecture & API)**：
  - **双轨标准化对齐**：全面重构系统响应信封，彻底消除冗余嵌套，统一收敛至 7 大核心标准 HTTP 状态码（200 OK、201 Created、204 No Content、400 Bad Request、401 Unauthorized、403 Forbidden、500 Internal Server Error），使得 HTTP 层面的传输状态与 JSON 信封内的业务业务码严格一致（[#174](https://github.com/engigu/baihu-panel/pull/174)）；
  - **清晰规范的错误回传**：统一错误响应结构，完善错误捕获并透出真实底层原因，极大增强 OpenAPI 及前端数据消费的稳健性。
* **Bark 推送端到端加密与动态表单能力增强 (Feature)**：
  - **现代高强度加密通道**：Bark 渠道全新支持基于 AES 算法的端到端数据传输加密，兼容 ECB、CBC 与现代 GCM 认证加密模式，支持自动生成高强度随机 IV，杜绝消息明文被任何网络中间节点监听窃视（[#177](https://github.com/engigu/baihu-panel/pull/177)）；
  - **通知表单动态组件扩充**：通知渠道配置表单支持 `Switch` 开关和 `Select` 下拉选择控件，为渠道参数定制提供更优雅的用户交互体验。
* **演示模式安全防护增强 (Security)**：
  - **备份恢复严防恶意覆写**：在演示模式下（`BH_DEMO_MODE=true`）后端与前端全面拦截并禁用“数据恢复”功能，前端增加醒目标签与风险提示，杜绝公共演示站点被恶意篡改或覆盖系统快照数据。
* **历史明文机密全量脱敏保护与安全加固 (Security)**：
  - **日志防泄露兜底**：系统将历史未加密明文机密统一自动纳入脱敏安全词典，在任务执行输出、调度历史与推送通知中自动打码遮罩，杜绝凭据无意泄露（[#175](https://github.com/engigu/baihu-panel/pull/175)）；
  - **管理员防重复初始化**：当系统已存在 `role=admin` 账号时自动跳过管理员初始化逻辑，避免修改默认用户名后被恶意重置（[#172](https://github.com/engigu/baihu-panel/pull/172)）；
  - **禁用环境变量严密隔离**：任务调度执行引擎在注入环境变量时，对处于“禁用”状态的变量彻底跳过注入，确保禁用即生效。

✨ **交互体验优化与问题修复**
* **任务编辑目录层级深层自动展开 (UI & Fix)**：
  - 任务编辑抽屉中的目录树选择器（`DirTreeSelect.vue`）支持依据当前绑定路径自动展开所有上级父目录，彻底解决深层目录无法自动展开、回显被遮挡的痛点（[#178](https://github.com/engigu/baihu-panel/pull/178)）；
  - 移除了武断的绝对路径末尾匹配逻辑，保障各种层级下的工作目录均能精准高亮定位。
* **任务编辑通知时机选择修复 (Fix)**：
  - 修复任务编辑弹窗中勾选通知时机（成功、失败、结束）时状态回显异常的问题（[#176](https://github.com/engigu/baihu-panel/pull/176)）。
* **多层级脚本目录长名称显示优化 (Style)**：
  - 解决左侧脚本文件目录在深度嵌套场景下长名称被过度截断挤压的问题，保证目录结构清晰易辨。
* **Windows 系统托盘自动静默更新与工作集优化 (Tray & Perf)**：
  - Windows 系统托盘程序支持全量安装包自动静默下载与平滑覆盖升级，并大幅精简后台工作集内存开销。
* **时间排版与核心指标排版体验 (Style)**：
  - 全局优化时间显示友好度，控制面板核心指标数字采用 Inter 字体并配合 `tabular-nums` 表格式特性，彻底消除数值变动时的抖动。

---

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件/安装包部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为安装包 `.exe` 或 `.zip`）。

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

* **方式一：使用 GUI 安装包安装（推荐）**

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.4.0-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.3.0-build.1 (2026-09-27)
底包更新至 9.5.0，无功能变更

### 1.3.0 (2026-09-23)
# 更新日志 (v1.3.0)

### 2026.09.23 - 机密端到端安全解密查看 (ECDH+AES-GCM)、日志表冗余任务名称、应用全量变量注入与文档体验升级

🎉 **新增功能与架构改进**
* **现代椭圆曲线 ECDH + AES-GCM 机密端到端安全解密查看 (Security & Feature)**：
  - **端到端加密传输**：前端动态生成 ECDH (P-256) 临时密钥对，后端利用 ECDH 密钥交换算法派生会话密钥，并通过 AES-GCM 加密回传机密明文，网络通信链路全流程绝无明文凭证，杜绝抓包截获与中间人窃密风险（[#171](https://github.com/engigu/baihu-panel/pull/171)）；
  - **二级凭据安全鉴权**：解密查看前强制触发登录密码二次核验，弹窗表单进行域隔离，彻底杜绝浏览器密码管理器自动填充污染背景其他表单；
  - **可视交互与定时遮罩保护**：支持一键快速复制明文与便捷显隐切换，离开视口或超时后自动恢复星号遮罩保护。
* **日志表冗余任务名称与已删除任务状态追溯 (Feature & Perf)**：
  - **数据库字段冗余设计**：在 `baihu_task_logs` 数据表中持久化冗余 `task_name` 字段，彻底解决定时任务删除或更新后历史日志呈现空名称、不可读 ID 的痛点（[#170](https://github.com/engigu/baihu-panel/pull/170)）；
  - **生命周期清晰辨识**：前端日志列表智能识别已被物理删除的任务，并在任务名前醒目标注 `(已删除)` 状态徽章；
  - **检索性能显著提升**：支持在执行历史中直接按原任务名称精准/模糊查询历史归档日志，不再强依赖连表实时解析。
* **声明式应用全量环境变量注入规范强化 (Architecture & Fix)**：
  - **统一调度策略规范**：受控子任务（Child Tasks）严格遵循白虎面板调度规范，在 `UnifiedConfig` 中显式设置 `common.task_all_envs = true` 与 `task_concurrency = 0`，使应用编排出的全部子任务默认无缝获得全量环境变量与解密机密注入；
  - **杜绝 ID 冗余绑定**：移除向子任务 `Envs` 字段写入具体 ID 字符串的多余逻辑，保持 `tasks` 与 `DataRelation` 表的高性能与轻量解耦。

✨ **文档增强与体验优化**
* **在线动态加载与渲染应用商店文档 (Docs)**：
  - 文档中心全新支持免跨域实时拉取与动态解析渲染 GitHub 远端应用商店 `README.md` 与生态规范文档；
  - 远程 Markdown 渲染引擎全面支持 Monokai 代码高亮配色、目录锚点平滑滚动跳转以及代码块右上角一键复制反馈。
* **移动端响应式排版优化 (Style)**：
  - 应用市场顶部控制栏响应式重构，优化在移动端小屏/窄屏视口下的搜索框、刷新按钮与分类标签排版，彻底解决小屏排版溢出与换行挤压问题。

---

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件/安装包部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为安装包 `.exe` 或 `.zip`）。

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

* **方式一：使用 GUI 安装包安装（推荐）**

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.3.0-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.2.0 (2026-09-22)
No changelog available.

### 1.1.30 (2026-09-11)
# 更新日志 (v1.1.30)

### 2026.09.11 - 标签关联资源穿透与跳转、输入法体验修复、调度引擎稳定性调优与安全升级

🎉 **新增与优化**
* **标签关联资源穿透与一键跳转 (New)**：在“标签管理”页面点击关联资源计数即可弹窗查看该标签关联的所有任务与环境变量明细，并支持直接点击资源名称快捷跳转至对应管理页进行编辑。

✨ **修复与改进**
* **标签输入组件末尾字符丢失修复 (Fix)**：修复了前端 `TagInput.vue` 组件在按下回车确认添加标签时，输入法缓冲区末尾字符意外丢失的问题。
* **任务结束时序与实时日志竞态修复 (Fix)**：优化任务执行结束时的日志压缩与状态入库时序，修复超短任务及高频并发下实时日志流与状态落库存在竞态导致前端显示不同步的问题。
* **Cron 注册数据库查询性能调优 (Perf)**：优化仓库同步任务在 Cron 注册阶段的数据库查询开销，提升调度器整体性能并适度放宽内部通信超时时间。
* **依赖安全漏洞升级 (Security)**：升级 `golang.org/x/crypto` 至 `v0.55.0`，彻底修复已知安全隐患（[#165](https://github.com/engigu/baihu-panel/issues/165)）。

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件/安装包部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为安装包 `.exe` 或 `.zip`）。

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

* **方式一：使用 GUI 安装包安装（推荐）**

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.1.29-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.1.29 (2026-09-08)
# 更新日志 (v1.1.29)

### 2026.09.08 - Windows 原生 ConPTY 伪终端重构、hosts 自动化域名映射、托盘 Modern UI 升级与仓库代理支持

🎉 **新增与优化**
* **Windows 原生 ConPTY 伪终端重构 (New)**：伪终端底层重构为 `github.com/ActiveState/termtest/conpty` 官方库，彻底解决了 Windows 托盘与无控制台模式下管道被占用导致终端卡在“已连接”/黑屏的问题；优化了 `pwsh.exe` 启动参数。
* **Windows 安装包 hosts 自动化映射 (New)**：Inno Setup 安装包 (`build/windows/installer.iss`) 全新集成 Pascal 自动处理脚本，在安装时自动写入 `127.0.0.1 baihu.local` 且保证完全幂等与唯一性，卸载时静默清理；Windows 托盘一键打开默认切换为 `http://baihu.local:38052`。
* **Windows 系统托盘 Modern 沉浸式 UI 升级 (New)**：使用系统 `uxtheme` 激活了 Windows 10 1903+ / Win11 原生沉浸式深色 Modern 菜单主题；优化了菜单层级与加粗样式，并支持在任务栏双击托盘图标直接打开控制台。
* **仓库同步 HTTP 代理支持 (New)**：仓库同步任务全新支持配置 HTTP 代理，方便在网络限制环境下流畅同步 Git 远程代码库（[#164](https://github.com/engigu/baihu-panel/pull/164)）。
* **首页控制台按今日筛选任务日志 (New)**：首页 Dashboard 日志列表新增“按今日”时间维度快速筛选日志功能（[#23](https://github.com/engigu/baihu-panel/issues/23)）。

**✨ 修复与改进**
* **Web 终端断开锁屏与重连修复 (Fix)**：修复了点击终端右上角刷新按钮重连时由于旧连接异步关闭事件导致提示“连接已断开”误覆盖的 Bug；并在连接中断时自动锁定终端键盘输入（`disableStdin = true`）防盲打。
* **站点配置默认值回退修复 (Fix)**：修复了站点设置项在值为零/空时无法正常回退到系统默认默认值的 Bug，并重构清理了冗余硬编码。

> 💡 **提示**：出于安全及环境隔离考虑，推荐使用 Docker/Compose 部署方式。[镜像地址](https://github.com/engigu/baihu-panel/pkgs/container/baihu)

### 🐳 方式一：Docker 部署 (推荐)
[部署文档](https://github.com/engigu/baihu-panel?tab=readme-ov-file#%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2)

---

### 🚀 方式二：单文件/安装包部署 (Linux / Windows)
从当前 Release 的附件中下载对应架构和平台的部署压缩包（Linux 为 `.tar.gz`，Windows 为安装包 `.exe` 或 `.zip`）。

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

* **方式一：使用 GUI 安装包安装（推荐）**

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.1.29-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

---

## What's Changed
* feat(repo): 仓库同步任务支持HTTP代理 by @hotlcc in https://github.com/engigu/baihu-panel/pull/164

## New Contributors
* @hotlcc made their first contribution in https://github.com/engigu/baihu-panel/pull/164

**Full Changelog**: https://github.com/engigu/baihu-panel/compare/v1.1.28...v1.1.29

### 1.1.28 (2026-09-04)
# 更新日志 (v1.1.28)

### 2026.09.04 - IDE 底部 Terminal 控制台、运行环境持久化、任务配置批量更新、ConPTY 重叠修复与安全升级

🎉 **新增与优化**
* **VSCode 沉浸式 Terminal 控制台 (New)**：将代码编辑器的运行终端由中心模态弹窗改造为 VSCode 风格的底部抽屉控制台，实现代码编辑与终端输出同屏协同。提供【重新运行】、【清空控制台】、【最大化/还原】及【关闭】控制按钮，并优化了初始命令输出的格式与回车体验。
* **运行环境持久化与直接执行 (New)**：运行配置（Mise 语言及版本）将自动持久化到本地存储。首次配置后，后续点击【运行】即可直接启动底部 Terminal 执行，无需频繁确认弹窗；同时在编辑器头部与 Terminal 工具栏保留了快捷配置按钮。
* **任务与仓库批量配置修改 (New)**：任务列表与仓库列表新增“批量修改配置”功能，采用弹窗内下拉 + 搜索多选形式，支持批量选择配置运行环境和高级选项，未选字段保持原配置不覆盖。

**✨ 修复与改进**
* **Windows ConPTY 视口防抖与命令重叠修复 (Fix)**：为网页终端尺寸调整请求引入 150ms 防抖机制，优化了 initialCommand 发送时效，彻底解决了 Windows 原生伪终端在窗口初始化和动画过渡阶段因高频触发 `ResizePseudoConsole` 导致命令行文本在视口中被多次重绘与重叠打印的问题。
* **仓库同步 Git 跟踪文件过滤优化 (Fix)**：优化 `reposync` 同步筛选逻辑，只自动过滤和清理受 Git 管理跟踪的文件，非 Git 跟踪及本地生成文件不受影响。
* **依赖安全漏洞升级 (Security)**：升级了 `kin-openapi` (v0.149.0)、`fast-uri`、`browserslist` 及多个前端 NPM 依赖，彻底修复了 Dependabot 监测出的 CVE 漏洞与安全告警。

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

### 1.1.27 (2026-08-21)
# 更新日志 (v1.1.27)

### 2026.08.21 - 通知过滤与小屏适配、文件查看下载优化与 CLI 命令行文档增强

🎉 **新增与优化**
* **通知过滤与响应式优化 (New)**：新增全局与任务级的通知通道过滤选项，并对中小屏幕/移动端的页面样式及响应式适配进行了细节微调与体验优化。
* **文件查看与下载体验提升 (New)**：重构了编辑器中二进制文件与图片文件的处理逻辑，优化了其在前端的加载与直接下载操作，避免查看特殊非文本文件时引发的网页卡顿及浏览器强制下载弹窗问题。
* **移动端日志像素级平滑滑动 (New)**：将移动端日志拖拽逻辑升级为直接操控底层 Xterm 视口的像素级原生滚动，结合 2.5x 灵敏度加速，使触屏拖拽极其顺滑。
* **CLI 命令行文档增强 (Docs)**：充实了 CLI 实用的参数用例说明，明确规范了脚本文件的元数据头部注释格式（Script Header Comments），方便自动提取和注册定时任务。

**✨ 修复与改进**
* **小屏任务页面及细节展示优化 (Fix)**：优化移动端各卡片内部间距与图标对齐；修复了窄屏下任务工具栏新建/批量删除等动作按钮溢出被截断问题；解决了超长任务名称在日志详情侧边栏内导致的排版重叠和布局挤压。
* **Web 编译与构建修复 (Fix)**：清除了 Web 前端多余未使用的 `ShieldAlert` 图标引用，彻底解决因 TS 类型检查严格而导致的构建打包失败报错。

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

### 1.1.26-build.1 (2026-08-18)
底包更新至 9.4.0，无功能变更

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



