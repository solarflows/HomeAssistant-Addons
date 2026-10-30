### 1.5.9 (2026-10-30)
# 更新日志 (v1.5.9)

### 2026.10.30 - Docker 容器异步初始化内建助手库、Node.js 内建通知健壮性加固与返回值支持、变量机密编辑框最后编辑时间展示

🎉 **新增功能与体验升级**
* **Docker 容器异步初始化内建助手库 (Docker & Core & Perf)**：
  - **非阻塞异步派发初始化**：在容器公共启动入口脚本中抽象并统一 `init_builtin_packages`，将 `baihu builtininstall` 派发至后台异步执行，主服务进程无需同步等待内置包编译安装即可极速启动对外提供服务；
  - **临时状态标记与锁文件防护**：通过 `/tmp/.baihu_builtin_installed` 标记与防并发锁文件记录已就绪版本，避免容器重启或多实例重复触发安装。
* **Node.js 内建助手库 `baihu.notify` 健壮性加固与返回值支持 (Builtin & Notify & Fix)**：
  - **支持 Promise / Await 获取发送回执**：重构 Node.js 内建 `notify` 模块，全面支持返回 Promise，用户可通过 `const res = await baihu.notify(...)` 结构化获取投递状态、HTTP 状态码及错误详情（[#203](https://github.com/engigu/baihu-panel/pull/203)）；
  - **异常拦截与错误透出**：彻底修复旧版本静默吞掉异常的缺陷，针对缺少配置环境变量（`BHPKG_NOTIFY_TOKEN` / `BHPKG_NOTIFY_CHANNEL`）、非法接口 URL 及网络请求超时错误进行前置校验与标准控制台报错输出；
  - **文档与示例同步更新**：同步更新官方指南文档与 Node.js 示例脚本中的推荐调用姿势。
* **环境变量与安全机密最后编辑时间展示 (Environments & Web & Feature)**：
  - **对齐紧凑 DevOps 排版规范**：在环境变量与安全机密编辑弹窗（`EditEnvDialog.vue`）左下角新增“最后编辑于”时间提示，鼠标悬浮展示完整时间戳，与任务编辑弹窗、代码仓库弹窗等既有设计规范保持完全一致（[#204](https://github.com/engigu/baihu-panel/pull/204)）。
* **应用任务行菜单文案优化 (Apps & Tasks & Web)**：
  - **语义精准化**：优化声明式应用受控任务列表项的更多操作菜单文案为“更新详情”，消除歧义并与实际跳转行为保持一致。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.9-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.8 (2026-10-27)
# 更新日志 (v1.5.8)

### 2026.10.27 - 语言安装下载镜像加速与 Mise 运行时镜像源配置、已装应用更新检测与无损升级中枢、OpenAPI 文件管理能力开放与全站安全加固

🎉 **新增功能与体验升级**
* **语言安装下载镜像加速与 Mise 运行时镜像源配置 (Languages & Mise & Perf)**：
  - **新增语言下载镜像加速**：在新增语言弹窗中集成 GitHub 镜像选择功能，内置 `gh-proxy.com (推荐)`、`ghfast.top`、`ghproxy.net`、`github.moeyy.xyz` 及自定义代理前缀选项，彻底解决境内服务器通过 GitHub Releases 安装 Python/Node/Go 等运行时下载超时失败的痛点（[#200](https://github.com/engigu/baihu-panel/issues/200)）；
  - **全局默认加速源持久化与多系统命令注入**：支持将所选镜像持久化写入 Mise 全局配置（`MISE_URL_REPLACEMENTS`），后续自动化或终端安装全量生效；同时安装终端根据底层操作系统（Linux/Windows）自适应注入环境变量加速执行；
  - **加速选项卡双区分类管理**：将“加速”页面划分为“运行时下载加速 (Mise Runtime)”与“包管理器依赖源 (Package Registry)”两大区域，支持一键配置 Mise GitHub 加速、Node.js 运行时镜像（`MISE_NODE_MIRROR_URL`）、Go 官方国内镜像（`MISE_GO_DOWNLOAD_MIRROR`）及 Python 编译源码镜像（`PYTHON_BUILD_MIRROR_URL`）；
  - **系统环境变量无损提取优化**：修复优化 `mise_service` 中环境变量解析逻辑，支持带有空格与 JSON 结构的变量值完整无损还原。
* **已装应用更新检测与一键无损升级中枢 (Apps & Scheduler & Feature)**：
  - **系统级更新检测与手动检测**：支持已安装应用的版本更新自检，内置系统级每日定时巡检与手动立即检测，发现新版本时联动系统通知中心发送更新提醒（[#201](https://github.com/engigu/baihu-panel/pull/201)）；
  - **版本漂移检测与无损升级闭环**：支持实时校验当前运行版本与应用清单最新定义的版本差异，提供一键无损升级能力，自动原子重构调度实体、系统环境变量、关联任务与依赖环境，保障升级过程平滑无缝。
* **OpenAPI 文件管理接口开放与 404 兜底修复 (OpenAPI & Web & Fix)**：
  - **开放文件写入与保存接口**：OpenAPI 正式开放文件保存与写入端点，支持第三方工具及 CI/CD 自动化流水线远程下发管理文件（[#202](https://github.com/engigu/baihu-panel/pull/202)）；
  - **静态资源与 SPA 路由 404 兜底机制完善**：修复优化前端路由与静态资源兜底响应行为。
* **全站核心依赖安全加固与 Dependabot 漏洞清零 (Security & Dependencies)**：
  - **核心工具链安全升级**：升级 `vite` 至 `^7.3.7`（Web 端）与 `^6.4.5`（Docs 端），彻底消除 `launch-editor` 命令注入与路径校验绕过漏洞；
  - **全链路依赖漏洞修复**：同步升级与覆盖 `dompurify` (`^3.4.17`)、`zod` (`^4.6.7`)、`undici` (`^7.30.1`)、`fast-uri` (`^4.2.3`)、`serialize-javascript` (`^7.1.4`)，实现主系统与文档站点全量 `npm audit` 0 漏洞，GitHub Dependabot 安全告警全部闭环清零。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.8-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.7-build.1 (2026-10-22)
底包更新至 9.5.1，无功能变更

### 1.5.7 (2026-10-21)
# 更新日志 (v1.5.7)

### 2026.10.21 - 任务日志自定义变量提取与通知模板注入、设置中心全局悬浮保存与改动追踪、脚本编辑终端重构及体验加固

🎉 **新增功能与体验升级**
* **任务日志自定义变量提取与通知模板注入 (Major Feature & Notify & Tasks)**：
  - **双轨提取引擎**：
    - **标准协议直出**：任务脚本可直接在标准输出打印 `[BHP_VAR] key=val`、GitHub Actions 兼容语法 `echo "::set-output name=key::val"` 或 `[BHP_JSON] {"key": "val"}`，自动完成结构化变量捕获；
    - **零侵入正则捕获**：无需修改原有脚本代码，在任务通知配置中配置自定义正则表达式（支持命名捕获组 `(?P<name>pattern)` 与单捕获组），从运行日志中无感提取关键指标（如订单号、签到积分、执行状态等）；
  - **五层变量叠加覆盖与安全防篡改**：按 `系统内置保留变量 < 协议直出变量 < 正则捕获变量 < 任务自身参数` 优先级自动合并注入通知模板占位符（如 `{{ .order_id }}`）；内置系统字段防篡改机制，保障通知模板稳定性；
  - **可视化配置与官方指南**：任务通知抽屉新增「变量正则提取」配置卡片，支持多条规则动态增删与格式验证；官方文档中心完善发布《任务日志变量提取与通知模板注入使用指南》（`docs/guide/notify.md`），提供 Shell/Python/Node.js/Go 全语言示例（#196）。
* **系统设置中心全局悬浮保存栏与改动追踪 (Settings & Web & UI)**：
  - **动态改动追踪器 (Settings Tracker)**：引入 `useSettingsTracker` 组合式状态追踪，深度对比各配置项初始状态，修改时实时在字段旁渲染高对比度「已修改」徽章标记（`ModifiedBadge.vue`）；
  - **全局悬浮保存栏 (FloatingSaveBar)**：站点设置、调度设置与单点登录页面长滚动时，自动在屏幕底部浮出毛玻璃悬浮操作栏，实时统计未保存改动计数，支持一键重置放弃修改或原子落库保存；
  - **通道测试布局调优**：优化各通知通道测试按钮与输入框的间距布局，提升表单视觉均衡性与操作容错率。
* **脚本代码编辑与底部终端面板体验重构 (Editor & Web & Fix)**：
  - **消除参照系内边距导致的巨大空白**：彻底移除容器错误的 `pb-[45%]`（原百分比 padding 按父容器宽度计算导致 298px 巨大空白挤压编辑器），底部控制台改为 Flex 布局内 `shrink-0`，高度统一由 flex 自适应分配（#197）；
  - **动画位移改为流式高度平滑过渡**：面板展开/收回由 translate 位移改为高度过渡（`h-0!` 到 `h-[45%]`），确保过渡全程面板高度与编辑器高度总和严格等于视口容器，消除背景裸露与抽搐闪烁；
  - **Monaco 1px 亚像素缝隙修复与重排兜底**：容器补充 `bg-[#1e1e1e]` 底色，解决 Monaco 高度取整在浅色背景下漏白线的瑕疵；引入 `ResizeObserver` 兜底监听，防止控制台最大化关闭后编辑器未触发重排。
* **系统全局资源隔离与环境变量/机密查询修复 (Env & Security & Fix)**：
  - **解除机密与环境变量 user_id 过滤**：移除环境变量与机密查询中针对 `user_id` 的限制，使其作为系统全局统一资源调度注入，彻底解决后台 Cron 及应用子任务在部分多用户上下文下无法正确获取全局机密与变量的问题。
* **登录日志 IP 详情弹窗排版与字体优化 (Logs & Web & Style)**：
  - **超长文本排版防溢出与截断**：优化国际运营商/组织超长文本展示，引入优雅截断与悬停 Tooltip 完整信息预览，解决弹窗在不同分辨率下的横向溢出与图标排版漂移；
  - **全站 Inter 字体规范与国旗 Emoji 保留**：IP 详情统一西文字体为 Inter，保证数字与字母等宽对齐；调优字体回退栈，保证各国国旗 Emoji 渲染不被降级丢失。
* **CI 流水线历史日志清理保护 (DevOps & CI)**：
  - **Actions 运行记录安全阈值**：优化 GitHub Actions 自动清理工作流，强制保留最近 100 条构建与部署日志，便于历史追踪与故障排查。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.7-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.6 (2026-10-17)
# 更新日志 (v1.5.6)

### 2026.10.17 - 运行时PageCache控存策略重构、容器入口标准化与公共库抽取、OIDC领域层解耦及前端交互优化

🎉 **新增功能与体验升级**
* **运行时内存与 PageCache 控存策略重大优化 (Major Perf & MemOpt)**：
  - **动静分离保护运行时底座**：彻底排除 `/usr/local/bin/mise`、`/opt/mise-base` 等核心母盘环境目录，杜绝高频任务执行完毕后触发底层母盘 PageCache 频繁冷清理导致的磁盘冷读高发与 Block I/O 读流量暴涨痛点；基础运行底座仅保留在冷启动阶段执行单次初始化清理；
  - **任务结束局部精准清理与防抖冷却**：`OnTaskFinished` 回调严格仅清理该任务自身 `workDir` 产生的瞬时生成物，移除级联全盘扫描；并引入 30 秒目录级清理防抖冷却（`TaskFinishedCooldown`），彻底消减每 30 秒或更高频的短周期定时任务造成的磁盘 I/O 震荡；
  - **无限额容器安全阈值**：针对未配置内存上限（`LimitBytes == 0`）的 Docker 容器环境，将自动回收触发水位线动态提升至 512MB 以上，杜绝无意义的内存回收循环。
* **Docker 容器初始化入口公共库抽取与日志标准化 (Docker & DevOps & Style)**：
  - **公共入口函数库抽取**：新增 `docker-entrypoint-common.sh`，抽象并统一日志色彩、Banner 横幅、目录初始化、Mise 环境同步、PATH 与运行时环境注入、组件版本自检与 Bash 自动补全逻辑，大幅精简标准版（`docker-entrypoint.sh`）、极简版（`docker-entrypoint.minimal.sh`）与开发版（`docker-entrypoint-dev.sh`）的冗余维护成本；
  - **规范化版本横幅与属性对齐**：容器启动自动展示系统平台架构（如 `linux/amd64`）、程序版本号与构建时间戳，属性采用 6 个汉字等宽冒号竖直对齐；
  - **日志紧凑精简与彻底去重**：严格对齐 `build-go.sh`（`[GoBuild]`）规范格式，去除重复运行模式标题与多余空行，保持流水线般的极致紧凑与专业度。
* **OIDC / OAuth 2.0 领域层解耦重构 (Architecture & Auth)**：
  - **独立 OIDC 领域包抽离**：抽离独立的 `internal/oidc` 领域包（`config.go`、`provider.go`、`service.go`、`user.go`），实现配置解析、JWKS 发现缓存、端点构造、用户信息规范化与控制器彻底解耦；
  - **统一常量与配置读取入口**：统一常量与配置读取入口，大幅提升单点登录认证模块的内聚性与单元测试覆盖率。
* **前端任务交互细节与目录树选择优化 (Web & UI & Fix)**：
  - **仓库任务行执行时间修复**：修复仓库任务行（`RepoTaskRow.vue`）中最近执行时间的显示异常（#195）；
  - **目录树选择器初次加载优化**：任务工作目录选择树（`DirTreeSelect.vue`）初次展开时仅精准定位到当前目录，不再全量深度展开全部子目录，提升大目录下的交互流畅度（#195）；
  - **系统设置文案同步**：更新系统设置中容器内存优化与工作区清理的说明文案。
* **公共配置接口并发防抖与双端内存微缓存 (Perf & Network)**：
  - **前端 Promise In-Flight 去重与单页生命周期缓存**：针对系统设置页及其嵌入的多个子卡片（密码、2FA、单点登录）与登录页同一毫秒并发调用 `/api/v1/public/settings` 的网络浪费问题，在前端 API 层引入 Promise In-Flight 请求合并与 SPA 内存缓存，同一瞬间的多次调用直接复用首个请求，请求量直降 66%~75%，路由内二次读取 0 网络请求，并在保存设置时主动失效保证实时性；
  - **服务端常驻内存微缓存与 0ms 主动失效 (Public Cache)**：在 `internal/cache` 抽象独立的公共设置内存缓存（`public_cache.go`），在面板保存配置时通过 `SetSection` / `Set` 触发 0ms 瞬间主动失效；同时配置 30 秒安全兜底 TTL，兼顾了高并发下 0ms 亚毫秒级极速响应（<0.05ms）与运维手动直接改库场景下的自动感知与刷新。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.6-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.5 (2026-10-16)
# 更新日志 (v1.5.5)

### 2026.10.16 - 多身份源单点登录并行共存架构、SSO 独立路由与凭据解耦、移动端响应式与视觉体验打磨

🎉 **新增功能与体验升级**
* **多身份源单点登录并行共存与认证架构深度重构 (Major Feature & Auth & SSO)**：
  - **多身份源并行启用 (Multi-IdP Coexistence)**：彻底打破标准 OIDC 与通用 OAuth 2.0 之间的互斥限制，支持企业级 OIDC（Pocket ID / Keycloak / Authentik）与主流通用 OAuth 2.0（GitHub / Gitee / GitLab 等）双通道同时独立开启与并行运行；
  - **配置与安全凭据物理解耦**：拆分为独立的启用开关（`oidc_enabled` 与 `oauth2_enabled`），各自的 Client ID、Client Secret（均受掩码脱敏与安全加密存储保护）、作用域（Scopes）、自动建号策略（`auto_create`）及默认角色物理隔离，支持在面板底部一键原子落库；
  - **独立路由组与接口重构**：新增通用 OAuth 2.0 独立路由组（`GET /api/v1/auth/oauth2/login`、`GET /api/v1/auth/oauth2/callback`、`POST /api/v1/auth/oauth2/test`）；重构公共站点配置为 `/public/settings`（挂载于独立 `PublicController`），支持多身份源元数据聚合发现并保持全量向后兼容；
  - **登录页多 SSO 聚合入口**：登录界面自动检测并聚合展示所有已激活的快捷登录入口（例如 OIDC 图标与 GitHub 闪电图标并列呈现），用户可自由选配登录通道；
  - **安全 Reader 优雅抽象**：重构服务端配置读取体系，引入专用的 `securityReader` 辅助抽象，支持变长参数回退链（Fallback Chain）、类型安全转换与 Scope 解析去重，彻底消除冗余 if 样板代码；
  - **Provider 动态缓存与防脏缓存**：优化 `oidcCache` 全局缓存机制，仅缓存耗时昂贵的远程发现文档与 JWKS 验签器，`oauth2.Config` 始终根据当前请求动态构造，彻底杜绝多域名反代或密钥修改时 `RedirectURL` 脏缓存导致的 `redirect_uri_mismatch` 故障；
  - **Subject 命名空间防碰撞**：自动注入通道命名空间前缀（`oauth2:<id>` 与 `oidc:<sub>`），杜绝不同提供方纯数字 ID 碰撞串登，并对历史存量账号实现无感平滑升级；
  - **端点测试健壮性与超时防护**：通用 OAuth 2.0 测试端点探测增加 5s 超时控制与定制 UA 标识，解决参数自动识别与网络挂起风险。
* **OIDC 回跳与发现文档路径容错 (Fix & OIDC)**：
  - **登录回跳 State 校验修复**：修复携带重定向回跳路径（`redirect` 参数）时 Cookie 中 state 校验失败的缺陷（#194）；
  - **Issuer 路径自动规范化**：自动剔除用户误填的 `/.well-known/openid-configuration` 后缀与多余斜杠，并优化 404 排障指引。
* **移动端小屏响应式排版与视觉细节打磨 (Style & Mobile & UI)**：
  - **数据仪表盘状态徽章位置优化**：在小屏及窄视口下将数据仪表卡片的服务状态徽章移至右上角固定定位，彻底解决标题行在小屏设备下被挤压换行的排版痛点；
  - **仪表盘文本单行精炼**：优化仪表盘小屏副标题文案，保持单行紧凑对齐；
  - **首页水印与设置中心自适应**：优化首页动态水印在各视口下的防遮挡表现，统一移动端设置面板间距；
  - **UI 视觉图标规范化**：移除设置项提示中突兀的 Emoji 字符，统一替换为系统规范的 Lucide 图标组件（`<HelpCircle>`）。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.5-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。



# 更新日志 (v1.5.5)

### 2026.10.16 - 多身份源单点登录并行共存架构、SSO 独立路由与凭据解耦、移动端响应式与视觉体验打磨

🎉 **新增功能与体验升级**
* **多身份源单点登录并行共存与认证架构深度重构 (Major Feature & Auth & SSO)**：
  - **多身份源并行启用 (Multi-IdP Coexistence)**：彻底打破标准 OIDC 与通用 OAuth 2.0 之间的互斥限制，支持企业级 OIDC（Pocket ID / Keycloak / Authentik）与主流通用 OAuth 2.0（GitHub / Gitee / GitLab 等）双通道同时独立开启与并行运行；
  - **配置与安全凭据物理解耦**：拆分为独立的启用开关（`oidc_enabled` 与 `oauth2_enabled`），各自的 Client ID、Client Secret（均受掩码脱敏与安全加密存储保护）、作用域（Scopes）、自动建号策略（`auto_create`）及默认角色物理隔离，支持在面板底部一键原子落库；
  - **独立路由组与接口重构**：新增通用 OAuth 2.0 独立路由组（`GET /api/v1/auth/oauth2/login`、`GET /api/v1/auth/oauth2/callback`、`POST /api/v1/auth/oauth2/test`）；重构公共站点配置为 `/public/settings`（挂载于独立 `PublicController`），支持多身份源元数据聚合发现并保持全量向后兼容；
  - **登录页多 SSO 聚合入口**：登录界面自动检测并聚合展示所有已激活的快捷登录入口（例如 OIDC 图标与 GitHub 闪电图标并列呈现），用户可自由选配登录通道；
  - **安全 Reader 优雅抽象**：重构服务端配置读取体系，引入专用的 `securityReader` 辅助抽象，支持变长参数回退链（Fallback Chain）、类型安全转换与 Scope 解析去重，彻底消除冗余 if 样板代码；
  - **Provider 动态缓存与防脏缓存**：优化 `oidcCache` 全局缓存机制，仅缓存耗时昂贵的远程发现文档与 JWKS 验签器，`oauth2.Config` 始终根据当前请求动态构造，彻底杜绝多域名反代或密钥修改时 `RedirectURL` 脏缓存导致的 `redirect_uri_mismatch` 故障；
  - **Subject 命名空间防碰撞**：自动注入通道命名空间前缀（`oauth2:<id>` 与 `oidc:<sub>`），杜绝不同提供方纯数字 ID 碰撞串登，并对历史存量账号实现无感平滑升级；
  - **端点测试健壮性与超时防护**：通用 OAuth 2.0 测试端点探测增加 5s 超时控制与定制 UA 标识，解决参数自动识别与网络挂起风险。
* **OIDC 回跳与发现文档路径容错 (Fix & OIDC)**：
  - **登录回跳 State 校验修复**：修复携带重定向回跳路径（`redirect` 参数）时 Cookie 中 state 校验失败的缺陷（#194）；
  - **Issuer 路径自动规范化**：自动剔除用户误填的 `/.well-known/openid-configuration` 后缀与多余斜杠，并优化 404 排障指引。
* **移动端小屏响应式排版与视觉细节打磨 (Style & Mobile & UI)**：
  - **数据仪表盘状态徽章位置优化**：在小屏及窄视口下将数据仪表卡片的服务状态徽章移至右上角固定定位，彻底解决标题行在小屏设备下被挤压换行的排版痛点；
  - **仪表盘文本单行精炼**：优化仪表盘小屏副标题文案，保持单行紧凑对齐；
  - **首页水印与设置中心自适应**：优化首页动态水印在各视口下的防遮挡表现，统一移动端设置面板间距；
  - **UI 视觉图标规范化**：移除设置项提示中突兀的 Emoji 字符，统一替换为系统规范的 Lucide 图标组件（`<HelpCircle>`）。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.5-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.4 (2026-10-15)
# 更新日志 (v1.5.4)

### 2026.10.15 - MCP 双传输共存架构 (Streamable HTTP + SSE)、通用 OAuth 2.0 单点登录与全站 Inter 字体排版

🎉 **新增功能与体验升级**
* **MCP 协议双传输共存架构 (Streamable HTTP + HTTP/SSE) (Major Feature & AI & MCP)**：
  - **Streamable HTTP 单端点现行规范集成**：全面支持 2025-03-26 MCP 现行官方标准规范，单端点（`/open2api/v1/mcp`）统一通信，支持即时 JSON-RPC 响应与渐进式流式传输，会话基于标准请求头 `Mcp-Session-Id`，天然穿透企业网关与反向代理，无缝适配 OpenCode 2、Cursor、Claude Desktop、DSH、Cline 等现代 AI 客户端（#193）；
  - **HTTP + SSE 双端点兼容模式**：完整保留 2024-11-05 早期双端点规范（`GET /open2api/v1/mcp/sse` 与 `POST /open2api/v1/mcp/messages`），为仅支持旧版协议的客户端提供无缝向下兼容；
  - **底层共享与长连接防爆熔断**：两种传输通道共享同一个底层 `NewBaihuMCPServer` 业务与工具实例，统一复用现有 OpenAPI Bearer Token 及 `?token=` 鉴权；保留 SSE 活跃连接数限制（最多支持 3 个长连接会话并发维持），防止海量空闲长连接耗尽系统协程资源；
  - **前端双协议切换与配置指引**：系统设置中“AI 客户端连接 (MCP)”卡片新增 Streamable HTTP 与 HTTP + SSE 协议快捷切换器，支持动态显示对应端点 URL 并一键复制客户端配置 JSON；
  - **文档与测试全量就绪**：补齐完整的 MCP 自动化集成测试套件（15 个测试 100% PASS），同步更新官方接入指南文档。
* **通用 OAuth 2.0 单点登录协议集成与互联折叠面板 (Feature & Auth & UI)**：
  - **通用 OAuth 2.0 原生集成**：在原有 OIDC 基础上扩展支持通用 OAuth 2.0 协议标准（Authorization Code Flow），支持自定义授权端点、令牌端点、用户信息端点、作用域（Scopes）与用户唯一标识键（兼容 GitHub、Gitee、GitLab 等任意主流 OAuth 2.0 平台）；
  - **互联风格折叠配置卡片**：安全设置中单点登录配置升级为优雅的折叠抽屉卡片，并自动自适应协议类型展示对应配置项；
  - **登录页无感双模适配**：登录界面根据后端配置自动适配 OIDC 或 OAuth 2.0 快捷登录入口，展示定制平台名称与直观的授权跳转。
* **全局 Inter 现代字体与执行历史排版优化 (Style & UI)**：
  - **全站现代 Inter 字体栈统一**：全站默认英文与数字字体升级为现代 `Inter` 字体，强化数字 `tabular-nums` 等宽渲染，呈现精致克制的高级感排版；
  - **执行历史底栏排版统一**：移除执行历史列表多余的空白撑开，分页器与筛选状态直接吸附在表格底栏，全量与其他核心业务页面保持一致。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.4-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.3 (2026-10-15)
# 更新日志 (v1.5.3)

### 2026.10.15 - 原生 OIDC / Pocket ID 单点登录、任务批量设置多类型混选重构、表格分页数独立持久化与演示模式全面加固

🎉 **新增功能与体验升级**
* **原生 OIDC / Pocket ID 单点登录支持 (Feature & Auth & Security)**：
  - **主流 OIDC 协议原生集成**：支持基于 OpenID Connect (OIDC) 规范的单点登录 (SSO) 认证体系，深度适配并无缝兼容 Pocket ID、Keycloak、Authelia 等自建与主流开源 IAM 身份认证平台（#191）；
  - **双轨登录架构支持**：支持传统管理员账密与 OIDC 单点登录双轨并行，支持在系统设置中一键开启/停用 OIDC 并配置 Client ID、Client Secret 及 Endpoints；
  - **全链路安全防护与会话闭环**：前端提供一键快捷跳转授权，后端严格校验 PKCE / State 防 CSRF 攻击，全自动置换授权码并完成用户身份识别与 JWT 签名签发；
  - **单点登录与两步验证指南**：官方文档中心补充发布《两步验证 (OTP) 与单点登录 (OIDC) 完整安全指南》，涵盖 Pocket ID 详细配置、回调重定向 URI 与排障步骤。
* **任务多类型混选批量参数设置重构 (Tasks & Feature & UI)**：
  - **多类型混选智能兼容**：重构任务批量设置交互，全面解决白虎应用 (App)、仓库同步 (Repo) 与普通脚本 (Task) 在多选/全选批量操作时的参数冲突与类型歧义问题（#192）；
  - **模块化结构分类定义**：
    - **通用参数 (Common)**：超时时间、批量标签管理、调度重试与随机延迟、全量环境变量注入（支持全部任务类型）；
    - **运行时环境 (Language)**：运行时多语言环境 Mise（独立分类，按所选任务支持情况智能生效）；
    - **执行位置 (Agent)**：统一执行位置 Agent 节点（严格限制仅对普通脚本任务生效，并在界面提供明确的适用性标签与禁用说明）；
  - **批量操作栏与动画平滑优化**：移除多余的 CLI Hooks 指令设置，优化小屏与桌面端批量浮动操作栏的布局与交互。
* **表格每页条数独立持久化与分页体验升级 (Pagination & Web & UI)**：
  - **解耦全局 PageSize 依赖**：移除站点设置中对全局 `pageSize` 的强约束，各表格页面通过 `localStorage` 独立持久化记住用户的每页条数偏好；
  - **9 大核心表格全量覆盖**：定时任务、环境变量/机密、标签管理、执行历史以及系统所有日志 Tab 均实现独立的每页分页偏好记忆，互不干扰；
  - **卡片内嵌式底栏排版统一**：修复环境变量页面与任务列表页面的分页条脱落浮空缺陷，全量统一为紧凑内嵌式底栏设计，消除多余空隙与深浅色底色割裂；
  - **Inter 字体排版与精炼视觉**：页码及数据指示器全面应用 `Inter` 字体栈配合 `tabular-nums` 等宽特性，移除冗余的区间文本显示，呈现更加紧凑高级的现代微排版。
* **演示模式全方位安全加固 (Security & Demo)**：
  - **敏感配置与服务全链路锁定**：在演示模式（`BH_DEMO_MODE=true`）下全面拦截并禁用敏感接口与写操作：禁用 OTP 两步验证与 OIDC 单点登录配置、禁用 OpenAPI 接口调用与凭据重置、禁用 MCP 远程协议与客户端连接、禁用容器内存缓存优化与调度核心参数调整；
  - **前端交互状态防范**：前端表单输入项自动禁用并标明“演示模式禁用”醒目标记，彻底杜绝公开演示站点数据外泄与参数篡改风险。
* **视觉体验与流畅度综合打磨 (Perf & Style & Fix)**：
  - **暗色模式 Anti-FOUC 极速探测**：增加内联 Anti-FOUC 探测脚本，在 HTML 解析首帧毫秒级应用 `dark` 类，彻底根治暗色主题下页面刷新瞬间闪白的顽疾；
  - **弹窗动效去冗与极速响应**：移除 Dialog / AlertDialog 拖沓的缩放动画（`zoom-in-95`/`zoom-out-95`）与延迟，优化遮罩层渲染，使弹窗弹出与关闭极速干脆；
  - **应用市场多分支源容错**：仅在目标分支为 `main` 时优先读取 GitHub Pages 静态预编译源，避免 `dev` 等开发分支配置失效；
  - **UI 细节优化**：优化通知渠道卡片测试发送图标为纸飞机 `Send`，优化运行环境配置弹窗视觉与字体排版。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.3-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.2 (2026-10-13)
# 更新日志 (v1.5.2)

### 2026.10.12 - 容器PageCache自适应回收与点杀、tini僵尸进程回收、树形目录批量加载与小屏代码编辑优化

🎉 **新增功能与体验升级**
* **容器与进程生命周期健壮性增强 (Docker & Core & Fix)**：
  - **tini 僵尸进程回收**：Docker 镜像入口升级引入 `tini` 作为 1 号 init 进程，彻底解决长时间多任务频繁派生可能产生的孤儿进程堆积与僵尸进程未回收问题（#188）；
  - **移除冗余 data/bin 软链目录**：移除无意义的 `data/bin` 软链创建，改由终端环境直连白虎主程序所在物理目录；Dockerfile 固化 `BH_ROOT_DIR=/app`，彻底消除无用目录与文件系统残留。
* **任务编辑与工作目录批量展开 (Tasks & API & Fix)**：
  - **批量子目录预获取**：新增批量获取下级文件树接口，解决定时任务编辑弹窗中复杂深层工作目录初次展开失败及多层目录逐级请求卡顿问题（#189）。
* **任务执行日志与排版渲染优化 (Logs & Web & Fix)**：
  - **Emoji 字符重叠修复**：修复脚本执行日志终端输出包含特定 Emoji 符号时与紧随其后的文字相互重叠排版的缺陷（#190）；
  - **日志操作栏一键复制**：日志卡片详情顶部工具栏新增便捷复制全文按钮，统一并发池与终端监控头部视觉风格。
* **移动端与代码编辑器体验重构 (Editor & Mobile & UI)**：
  - **移动端小屏横滑与下拉防击穿**：代码编辑器注入 `touchAction` 与 `overscroll-contain`，彻底消除移动端小屏左右拖动时误触发全局下拉刷新击穿的痛点；
  - **自动换行/横滑自由切换**：工具栏新增轻量切换按钮（“换行”/“横滑”），满足手机与桌面不同场景的代码浏览与编辑需求；
  - **滚动条小屏常驻**：小屏设备下 Monaco 编辑器横向与纵向滚动条保持常驻可见并调优高对比度滑块。
* **容器 Page Cache 智能自适应回收与点杀优化 (MemOpt & Cgroup & Docker)**：
  - **深层环境目录遍历与核心二进制点杀**：将容器缓存目录扫描最大深度从 3 层扩展至 6 层，彻底解决 Mise 环境下多语言核心可执行程序（如 `node`、`python`、`dotnet` 位于 `installs/<tool>/<ver>/bin/<tool>` 第 4 层）被深度限制遗漏导致巨额 Active Page Cache 常驻问题；在遍历中智能跳过 `include`、`share`、`doc`、`man` 等无关头文件与文档目录，大幅减少磁盘 I/O 开销与遍历耗时；
  - **联动 cgroup v2 原生快速回收机制**：在系统启动就绪阶段与常规工作区回收前优先调用 `TryReclaimCgroupMemory`（写入 `/sys/fs/cgroup/memory.reclaim`），实现毫秒级批量卸载容器可回收 Slab 目录项与非映射 Page Cache；
  - **高水位与半载智能防护策略**：建立容器内存高警戒水位（默认 80%）与半载活跃缓存重型任务（60%）双轨自适应回收策略，充裕状态下静默放行保证读写性能，紧张状态自动介入；
  - **任务结束防抖与尾部合并**：挂载 EventBus 任务结束事件监听器，引入 `DirDebouncer` 尾部合并防抖器，同目录多任务高频/连续结束时自动合并为最后一次统一回收，避免高频 I/O 抖动；
  - **自适应回收日志合并对比**：重构并精简自适应内存回收日志，单行透明输出前后全量指标对比（总占用百分比、文件缓存总额、活跃/非活跃变化、Docker 官方口径真实物理占用）。
* **监控大盘视觉与现代排印重构 (Monitor & Style & UI)**：
  - **字体层级与现代排印重构**：监控面板全面统一引入 Inter 字体，核心指标与图表强化数字加粗渲染与 `tabular-nums` 等宽特性，消除数值跳变抖动；针对移动端小屏设备强化粗体渲染；
  - **色彩降噪与仪表盘卡片重构**：收敛监控面板整体色彩，去除仪表盘与 Worker 卡片中的重复与冗余指标，强化视觉质感与信息层级清晰度；
  - **图表右上角指标徽章与视觉细节**：图表卡片右上角增加动态指标徽章，优化坐标轴与折线/柱状图视觉展现。
* **文档与更新大纲体验升级 (Docs & Changelog)**：
  - 文档中心更新日志的时间与版本号提升为二级大纲，优化 VitePress 侧边目录导航的层级切换与快速跳转体验。

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

  直接运行附件中的安装程序 `BaihuPanel-Setup-v1.5.2-windows-amd64.exe` 完成安装，程序将自动完成桌面快捷方式创建、开机自启配置与 `127.0.0.1 baihu.local` 域名绑定。安装完成后通过桌面图标或任务栏右下角托盘图标即可直接打开 `http://baihu.local:38052`。

* **方式二：二进制单文件运行（免安装/便携版）**

  解压下载好的 `.zip` 压缩包（如 `baihu-windows-amd64.zip`），进入解压目录并在 PowerShell 中运行：

  ```powershell
  .\baihu.exe server
  ```

---

**访问面板：**
* 启动后访问：`http://baihu.local:38052` 或 `http://localhost:38052` (或单文件默认端口 `http://localhost:8052`)
* **默认账号**：用户名 `admin`，密码见面板首次启动时的控制台日志。

### 1.5.1-build.3 (2026-10-10)
CI 变更
- fix(ci): 修复 CHANGELOG 采集到无关历史提交并清理既有噪音

### 1.5.1-build.2 (2026-10-10)
CI 变更
（本次构建无代码变更）

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



