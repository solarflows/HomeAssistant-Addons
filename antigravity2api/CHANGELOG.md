### 0.1.11 (2026-11-22)

#### 下载

| 系统 | 推荐 | 其他 |
| --- | --- | --- |
| Windows 10 及以上 | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.11/antigravity2api-v0.1.11-windows-amd64.zip) | — |
| macOS（Apple 芯片与 Intel） | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.11/antigravity2api-desktop-v0.1.11-darwin-universal.tar.gz) | — |
| Linux 桌面 | [x64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.11/antigravity2api-desktop-v0.1.11-linux-amd64.tar.gz) · [ARM64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.11/antigravity2api-desktop-v0.1.11-linux-arm64.tar.gz) | — |
| Linux 服务器 | [x64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.11/antigravity2api-v0.1.11-linux-amd64.tar.gz) · [ARM64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.11/antigravity2api-v0.1.11-linux-arm64.tar.gz) | Docker 镜像 ghcr.io/mag1cfall/antigravity2api:v0.1.11 |
| macOS 命令行 | [Apple 芯片](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.11/antigravity2api-v0.1.11-darwin-arm64.tar.gz) · [Intel](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.11/antigravity2api-v0.1.11-darwin-amd64.tar.gz) | — |

桌面版与命令行版启动后都在 `http://127.0.0.1:8017` 提供管理页面与 API，解压即用。

#### 修复

- Live 语音模式把问题转交智能体时服务崩溃退出（[#8](https://github.com/Mag1cFall/Antigravity2API/issues/8)）
- 回答输出一部分后上游断开或异常结束时，以已输出的内容为前缀续写，客户端收到一份连贯的回答
- 原请求与备用请求中先返回的一方被过滤时由另一方接管；重新生成时先换到其他空闲账户
- 读额度时上游答复账户缺少产品许可，该账户停止接收请求并在管理端显示原因，之后读额度成功时自动恢复
- 每周额度用完的额度组不再按 5 小时额度继续调度
- 函数结果按调用 ID 对应到调用的函数名；换账户后为该账户另起会话
- 发给 Claude 模型的超大图片（单边超过 8000 像素或超过 5 MiB）先缩小再发送，透明背景铺白
- 函数参数与结果中的大整数 ID 原样发给上游
- 账户受限通知出现后，同一请求不再发到其他账户
- 上游按请求内容拒绝的 429 改为 400，并说明不是额度或限速问题

#### 拒绝句规则

- 补入 Hermes、pi、WorkBuddy、Claude Code（交互模式与不带逗号的身份句）、OpenCode 与结对编程提示中上游会拒绝的句子，这些客户端的请求不再返回 429
- 以 `。`、`！`、`？` 结尾的句子和 Windows 换行（CRLF）的文本按整句删除

#### 协议与客户端

- Codex 的 `tool_search`（客户端执行）可用，加载的工具并入本次请求的声明
- Anthropic 请求中 user 与 assistant 消息里的工具增删块（`tool_addition`、`tool_removal`）与 system 消息中的一样生效
- Claude Code 与 OpenCode 以请求头给出的会话标识用于归入同一会话
- 上下文超出模型上限时 Responses 返回 `context_length_exceeded`，Codex 据此自动压缩
- 接受 gzip 与 zstd 压缩的请求体
- 模型名带 `[1m]` 等上下文窗口后缀时按基础模型处理
- Claude 模型不接受的函数调用 ID（含不允许的字符、过长或重复）自动改写，函数结果随之对应

#### 管理端

- 请求列表的失败记录写明原因类别（容量不足、额度用完、需要验证、内容被拒）与已试过的账户数
- 在线更新前显示新版本的更新内容
- 接入页 Claude Code 可单独指定 Fable 对应的模型；导出的 OpenCode 与 pi 配置带各模型可选的思考档位
- 添加账户时可指定登录使用的代理，命令行为 `login --proxy`
- API key 可设备注名，key 列表、接入页、用量与请求详情显示备注名
- 从其他电脑访问管理端时，导出的文件由浏览器下载
- 模型映射与代理池列表限高，可滚动

#### 桌面版与命令行

- 切换官方客户端账户时先正常关闭官方客户端，再以原参数重新打开
- 命令行 `import` 读取官方 agy CLI 保存的凭据
- 检查更新最多等待 10 秒；更新后新版本没有启动时提示查看日志目录；上次运行异常退出时，启动日志写出崩溃原因与 `crash.log` 路径

#### 官方客户端对齐

- 跟进官方客户端新版本的 Orchestrator 会话事件与智能体监控配置
- macOS 上的终端命令自动执行策略与系统名与官方客户端一致

**完整变更**：[v0.1.10...v0.1.11](https://github.com/Mag1cFall/Antigravity2API/compare/v0.1.10...v0.1.11)

---

### 0.1.10 (2026-11-19)

#### 下载

| 系统 | 推荐 | 其他 |
| --- | --- | --- |
| Windows 10 及以上 | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.10/antigravity2api-v0.1.10-windows-amd64.zip) | — |
| macOS（Apple 芯片与 Intel） | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.10/antigravity2api-desktop-v0.1.10-darwin-universal.tar.gz) | — |
| Linux 桌面 | [x64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.10/antigravity2api-desktop-v0.1.10-linux-amd64.tar.gz) · [ARM64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.10/antigravity2api-desktop-v0.1.10-linux-arm64.tar.gz) | — |
| Linux 服务器 | [x64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.10/antigravity2api-v0.1.10-linux-amd64.tar.gz) · [ARM64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.10/antigravity2api-v0.1.10-linux-arm64.tar.gz) | Docker 镜像 ghcr.io/mag1cfall/antigravity2api:v0.1.10 |
| macOS 命令行 | [Apple 芯片](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.10/antigravity2api-v0.1.10-darwin-arm64.tar.gz) · [Intel](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.10/antigravity2api-v0.1.10-darwin-amd64.tar.gz) | — |

桌面版与命令行版启动后都在 `http://127.0.0.1:8017` 提供管理页面与 API，解压即用。

#### 修复

- 刷新额度或启动时遇到违反服务条款或需要验证的账户，停用或标为需要验证（[#2](https://github.com/Mag1cFall/Antigravity2API/issues/2)）
- 上游只输出了思考就断开时重新生成；长输出续接后断开时从断点续接（[#5](https://github.com/Mag1cFall/Antigravity2API/issues/5)）
- 上游以“账户受限”通知拒绝请求时，通知不再作为回答输出，该账户停用并换账户回答
- 个别账户对某个模型返回 404 时换账户回答
- 两个独立账户在同一时刻开始计时被当成共用额度，一个用完时另一个也被冷却
- 本地时区变化后启动时请求账本重建卡住
- 重试后被丢弃的尝试的用量重复计入账本
- 函数调用缺少必填参数或调用了未声明的函数时重新生成；最后一次仍缺参数时原样交给客户端处理
- 完整的函数调用之后上游以内容策略原因结束时，这次调用被丢弃并重新生成；现在按正常完成交付
- Gemini 流式响应的心跳改为官方 SDK 会跳过的空帧，Google Gen AI Go SDK 长时间等待后不再断开
- 客户端改写过上一轮函数调用的对话，计数多算上一轮的思考
- 用量页筛选不出账户为空的记录
- 通过 HTTP 远程访问管理端时复制按钮没有反应
- 管理端与服务的连接断开重连后日志页被清空
- 窄屏下搜索框的清空按钮压住输入的文字
- 窗口所在的显示器断开后，从托盘打开的窗口仍在原位置，看不到

#### 拒绝句规则

- 上游会拒绝的句子放在规则文件 `rules/rejected.txt`，服务启动时与每小时从 GitHub 取用最新版本，规则更新不需要升级软件；设置页可以查看当前规则、立即检查更新，并添加自己的规则
- 补入 omp 打开全部工具后的 3 句与 OpenCode 使用 Claude 模型时的 1 句，这些客户端的请求不再返回 429

#### 会话与调度

- 原样重发、回退改写、改写中间消息，以及中途改变系统提示或工具声明（omp 挂载技能、压缩上下文）的请求都留在原会话，上游缓存继续命中（[#6](https://github.com/Mag1cFall/Antigravity2API/issues/6)、[#7](https://github.com/Mag1cFall/Antigravity2API/pull/7)）
- 同一会话的下一轮使用上一轮成功生成的账户
- 新会话的伴随请求在后台进行，生成请求不等它们
- 原请求与备用请求中先返回的一方在给出内容前断开时，由另一方接管
- 跟进官方客户端 2.33.0：版本号、各主机的 HTTP 版本与会话事件

#### 协议

- Gemini Live API（WebSocket）：转写模型实时转写语音，Agent 模型以官方语音模式对话并输出 24 kHz 语音（[#4](https://github.com/Mag1cFall/Antigravity2API/issues/4)）
- Gemini 接口在 `/v1` 下同样可用，Google Gen AI SDK 的默认配置可以直接使用
- 公开接口的错误统一为英文，不含账户邮箱；管理端请求记录保留完整原因
- 内容策略拦截的错误写明拦截发生的时刻与拦截前已输出的内容
- 新会话第一轮的计数与上游相差 0.05%（v0.1.9 少算 15.5%）；Gemini 多轮请求的计数计入思考签名
- 函数声明中 `allOf` 里数组的 `items`、没有类型的数字枚举与字符串上的数值约束按原意发给上游
- 重新生成时，Responses 与 Interactions 流先结束已发出的思考项，最终结果只保留最后一次生成；Gemini 流的首段正文收到即写出

#### 管理端

- 单个账户导出与导入 JSON：导出前选择账户、可按账户分文件，导入前先识别文件中的账户
- 账户详情列出该账户可用的模型，以及与它共用额度的账户
- 用量页自定义时间范围，在日历上点选某天即为这一整天
- 请求趋势图悬停查看各时段数据，拖选放大
- 请求详情显示首个输出的耗时
- 下载、文件保存与选择、确认与下拉都使用产品自己的界面；桌面版右键菜单提供剪切、复制、粘贴与全选

#### 性能

会话与调度：

| 项目 | v0.1.9 | v0.1.10 |
| --- | --- | --- |
| 中途改变系统提示后第二轮的上游缓存 | 0 token | 15952 token |
| 同一会话下一轮（上一轮换过账户） | 6.55 s | 1.64 s |
| 新会话生成请求的前台等待 | 286–537 ms | 3–5 ms |
| 启动后第一个新会话 | 1850 ms | 1533 ms |

请求处理与管理端：

| 项目 | v0.1.9 | v0.1.10 |
| --- | --- | --- |
| 720 KB 请求的编码 | 2.16 ms、1.98 MB | 0.96 ms、0.83 MB |
| 启动时读取额度快照（12 个账户） | 21706 行、24.4 ms | 42 行、0.12 ms |
| 时区变化后启动的账本重建 | 卡住 | 0.56 s |
| 100 个请求 10 秒内结束时管理端每页重新读取 | 100 次 | 12 次 |

#### 贡献者

- @XUANJI233（[#7](https://github.com/Mag1cFall/Antigravity2API/pull/7)）

**完整变更**：[v0.1.9...v0.1.10](https://github.com/Mag1cFall/Antigravity2API/compare/v0.1.9...v0.1.10)

---

### 0.1.9-build.4 (2026-11-18)

CI 工作流维护
- 自动化构建流水线与容器发布底座例行维护

---

### 0.1.9-build.3 (2026-11-18)

patches 维护
- feat(ci,addons): unify OCI/GHCR metadata & Action Summary, update workbuddy2api-hub repo & a2api patch [skip-rebuild]

---

### 0.1.9-build.2 (2026-11-18)

Dockerfile + patches 维护
- refactor(patches): centralize apply-patches.sh via build-contexts and auto-map /src/<repo> [skip-rebuild]

---

### 0.1.9-build.1 (2026-11-17)

CI 工作流维护
- feat: unify build-time hot-patching architecture and dockerfile partitioning

---

### 0.1.9 (2026-11-16)

#### 下载

| 系统 | 推荐 | 其他 |
| --- | --- | --- |
| Windows 10 及以上 | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.9/antigravity2api-v0.1.9-windows-amd64.zip) | — |
| macOS（Apple 芯片与 Intel） | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.9/antigravity2api-desktop-v0.1.9-darwin-universal.tar.gz) | — |
| Linux 桌面 | [x64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.9/antigravity2api-desktop-v0.1.9-linux-amd64.tar.gz) · [ARM64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.9/antigravity2api-desktop-v0.1.9-linux-arm64.tar.gz) | — |
| Linux 服务器 | [x64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.9/antigravity2api-v0.1.9-linux-amd64.tar.gz) · [ARM64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.9/antigravity2api-v0.1.9-linux-arm64.tar.gz) | Docker 镜像 ghcr.io/mag1cfall/antigravity2api:v0.1.9 |
| macOS 命令行 | [Apple 芯片](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.9/antigravity2api-v0.1.9-darwin-arm64.tar.gz) · [Intel](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.9/antigravity2api-v0.1.9-darwin-amd64.tar.gz) | — |

桌面版与命令行版启动后都在 `http://127.0.0.1:8017` 提供管理页面与 API，解压即用。

#### 修复

- omp 系统提示中的 `You are omp's trusted coding assistant.` 一句使上游返回 429，omp 的请求全部失败；现在发送前整句删去，其余原文不变

**完整变更**：[v0.1.8...v0.1.9](https://github.com/Mag1cFall/Antigravity2API/compare/v0.1.8...v0.1.9)

---

### 0.1.8-build.1 (2026-11-16)

Dockerfile + rootfs 维护
- feat(s6): standardize S6-rc v3 architecture, decouple alist-tvbox services, and eliminate startup race conditions

---

### 0.1.8 (2026-11-15)

#### 下载

| 系统 | 推荐 | 其他 |
| --- | --- | --- |
| Windows 10 及以上 | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.8/antigravity2api-v0.1.8-windows-amd64.zip) | — |
| macOS（Apple 芯片与 Intel） | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.8/antigravity2api-desktop-v0.1.8-darwin-universal.tar.gz) | — |
| Linux 桌面 | [x64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.8/antigravity2api-desktop-v0.1.8-linux-amd64.tar.gz) · [ARM64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.8/antigravity2api-desktop-v0.1.8-linux-arm64.tar.gz) | — |
| Linux 服务器 | [x64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.8/antigravity2api-v0.1.8-linux-amd64.tar.gz) · [ARM64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.8/antigravity2api-v0.1.8-linux-arm64.tar.gz) | Docker 镜像 ghcr.io/mag1cfall/antigravity2api:v0.1.8 |
| macOS 命令行 | [Apple 芯片](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.8/antigravity2api-v0.1.8-darwin-arm64.tar.gz) · [Intel](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.8/antigravity2api-v0.1.8-darwin-amd64.tar.gz) | — |

桌面版与命令行版启动后都在 `http://127.0.0.1:8017` 提供管理页面与 API，解压即用。

#### 新功能

- 停用的账户也能预热：预热时临时启动，不接其他请求；预热对话框按额度组分组，默认选中各组费用最低的模型，账户全部停用时也能选择模型
- 接入页列出全部接口与常用能力，点开可查看协议、完整地址、认证、主要参数、curl 示例与官方文档
- 关闭登录对话框后可在账户页继续，登录结束后对话框保留结果；对话框关着时登录失败，账户页留下失败原因
- 远程配对令牌在有效期内保留，可手动换新，用于添加账户后自动换回生成命令
- OpenAI 模型列表带上下文与输出上限、思考档位与输入模态，omp 等客户端可直接读取

#### 改进

- 补齐全部目录模型的单价，包括 Gemini 4 Carbon、Hydrogen、Orchestrator、生图与语音转写模型；生图按图片输出单价计费，涨价日期按官方分档
- Gemini 4 长输出超过单次上限时继续生成，客户端收到完整输出，用量为各段之和
- 流式请求在上游返回首个内容前 10 秒内写出响应头并保活
- 结构化输出的格式要求写在最后一条用户消息末尾，JSON 输出更稳定
- 长文本的本地 token 计数从数秒到两分钟降到 0.1 秒以内
- 上游按输入拒绝请求时，Gemini 返回 200 与 `promptFeedback`，其余协议返回 400
- 首字节前连接断开时在同一账户再试一次，生图同样处理

#### 修复

- Claude Code、Codex、OpenCode、pi、omp、OpenClaw、Magpie 等客户端系统提示中的部分句子使上游立即返回 429；现在发送前整句删去这些句子，其余原文不变（[#3](https://github.com/Mag1cFall/Antigravity2API/issues/3)）
- 工具调用与结果之间夹着其他消息、并行调用只回传部分结果、结果找不到对应调用时请求被拒绝
- Anthropic 开启思考、模型直接调用工具时，客户端显示 Unsupported content type
- 重新生成用完仍以格式错误的函数调用或回复结束且没有输出时，返回 200 空回答
- 错误消息与后台 Responses 的失败对象不含重试时间
- 需要验证的账户在定时刷新或刷新全部后被重新启用，下一个请求再次失败
- Gemini 接口拒绝只带 id 的函数结果，`MALFORMED_RESPONSE` 结束原因显示为 `OTHER`
- 多轮结构化输出的 token 计数重复计入格式要求，引用显式缓存的请求被拒绝时用量缺少缓存 token 数

**完整变更**：[v0.1.7...v0.1.8](https://github.com/Mag1cFall/Antigravity2API/compare/v0.1.7...v0.1.8)

---

### 0.1.7-build.7 (2026-11-15)

Dockerfile 维护
- refactor(addons): complete repository-wide config streamlining, zero-option TZ, and entrypoint timezone fallback

---

### 0.1.7-build.6 (2026-11-15)

rootfs 维护
- fix(antigravity2api): restore ADMIN_AUTH_ENABLED and initial credentials for headless remote access

---

### 0.1.7-build.5 (2026-11-15)

rootfs 维护
- refactor(addons): eliminate synthetic credentials and enforce zero-default service startup

---

### 0.1.7-build.4 (2026-11-15)

rootfs 维护
- refactor(addons): streamline runtime configuration, adopt zero-option TZ, and migrate to supervisor socket

---

### 0.1.7-build.3 (2026-11-15)

rootfs 维护
- feat(antigravity2api): enable remote access by default and add sidecar two-way option sync
- chore(antigravity2api): 更新为标准 256x256 透明矢量光栅化 Antigravity 图标

---

### 0.1.7-build.2 (2026-11-15)

- **远程访问预置修复**：解决非 loopback（Docker 网桥/局域网）访问报 `401 admin_remote_disabled`（“远程登录未开启”）的问题，默认预置启用管理鉴权。
- **双向参数同步胶水层**：引入基于 `options_applied.json` 的差分调谐快照机制。出厂预置管理员凭据 `admin` / `admin`，支持在 Web 控制台随时改密（重启不覆盖、自动回填 HA Options），亦可在 HA Options 输入新密码实现灾难恢复一键覆盖重置。
- **解绑进程环境变量**：敏感凭据不通过 Docker `ENV` 导出，解除 upstream 对环境变量的强制只读锁定，确保 Web 端设置可自由编辑。

### 0.1.7-build.1 (2026-11-14)

#### 下载

| 系统 | 推荐 | 其他 |
| --- | --- | --- |
| Windows 10 及以上 | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.7/antigravity2api-v0.1.7-windows-amd64.zip) | — |
| macOS（Apple 芯片与 Intel） | [桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.7/antigravity2api-desktop-v0.1.7-darwin-universal.tar.gz) | — |
| Linux 桌面 | [x64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.7/antigravity2api-desktop-v0.1.7-linux-amd64.tar.gz) · [ARM64 桌面版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.7/antigravity2api-desktop-v0.1.7-linux-arm64.tar.gz) | — |
| Linux 服务器 | [x64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.7/antigravity2api-v0.1.7-linux-amd64.tar.gz) · [ARM64 命令行版](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.7/antigravity2api-v0.1.7-linux-arm64.tar.gz) | Docker 镜像 ghcr.io/mag1cfall/antigravity2api:v0.1.7 |
| macOS 命令行 | [Apple 芯片](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.7/antigravity2api-v0.1.7-darwin-arm64.tar.gz) · [Intel](https://github.com/Mag1cFall/Antigravity2API/releases/download/v0.1.7/antigravity2api-v0.1.7-darwin-amd64.tar.gz) | — |

桌面版与命令行版启动后都在 `http://127.0.0.1:8017` 提供管理页面与 API，解压即用。

#### 新功能

- 管理页面、托盘菜单、服务日志与管理接口错误支持七种语言，随界面语言切换
- Windows 托盘双击打开窗口，右键菜单随界面语言与深浅色显示，可直接展开各账户额度；macOS 与 Linux 单击打开窗口
- Gemini 4 Hydrogen 按一个模型公开 Low、Medium、High、XHigh 四档，`reasoning_effort` 为 `xhigh` 或 `max` 时使用 XHigh；Orchestrator 随账户目录直接可用
- 首字等待超过该模型近期常见时长时，可自动发起一路备用请求，先返回首字的一路继续，另一路取消
- 请求可用 `X-Antigravity-Account-Id` 请求头指定处理的账户
- Gemini 接口支持 cachedContents；Interactions 支持 background、webhook 与取消；Anthropic 支持 context_management
- 自订档系统指令按官方段分块编辑
- Linux 桌面包支持 Ubuntu 22.04 的 GTK 3 托盘与没有托盘时的窗口启动

#### 改进

- 上游身份与伴随请求跟进官方客户端 2.31.2：生成与其他请求改走 HTTP/2，错误上报、冷启动时序与会话上报按官方现场
- 全保留档的系统指令随账户的服务端开关与所选模型的模板变化，与官方逐字一致
- 四种协议的响应字段按官方顺序输出，补齐 Chat、Responses、Anthropic、Gemini 与 Interactions 的多项字段与输入
- 支持超多、超大图片与原生视频、PDF、音频输入
- 公开 API 的错误、额度显示与冷却：全部账户不可用时列出各账户原因，额度窗口重置后显示满额，系统睡眠期间冷却照常计时，并发请求同遇上游 500 时冷却不累加
- 账户的套餐不可用时停用该账户，账户页与日志写明上游给出的原因
- 依赖升级，修复已知漏洞

#### 修复

- 已完整发出工具调用后被上游过滤提示拦截，或上游没有结束帧就断开时，这一轮失败、客户端不执行工具；现在按正常结束，原因写入日志与请求记录
- SAFETY 等内容策略结束与过滤拦截返回客户端可自动重试的 5xx 错误
- 桌面版在系统卡顿、磁盘繁忙时窗口无响应
- Claude 族工具参数 anyOf 含没有 properties 的对象时进程退出
- 修改代理后上游请求仍走旧代理
- Gemini 族工具参数的标量节点带 items 或 properties 时上游返回 400；函数结果被 user 消息隔开时返回 400
- Codex 默认命名空间的工具被加上 `functions.` 前缀；强制工具选择在函数改名后指令仍用原名
- 客户端中途从其他服务切换过来时，历史中没有签名的工具调用让模型把调用写成正文并以 MALFORMED_FUNCTION_CALL 结束；OpenClaw 改写调用 ID 后签名补不回
- 带完整 MIME 的 input_audio、无签名 computer_call 中的截图丢失
- 远程媒体下载可经 DNS 重绑定访问本机地址，直连与经 HTTP_PROXY 代理时都会在连接前检查实际地址
- Responses 流的心跳事件序号重复
- Images 的 `output_format` 为 `webp` 时返回的不是 WebP
- 后台 Interactions 在管理端停止后仍继续生成，生成中删除的交互在完成后重新出现
- Windows 托盘账户很多时额度子菜单超出屏幕
- 上游以 200 正文返回客户端版本过低提示时按回答转发；首字节前连接重置不重新生成

**完整变更**：[v0.1.6...v0.1.7](https://github.com/Mag1cFall/Antigravity2API/compare/v0.1.6...v0.1.7)

---

# Changelog

## 0.1.7

- 初始版本发布
- 基于 Mag1cFall/Antigravity2API v0.1.7 源码编译
- 开启 `GOEXPERIMENT=boringcrypto` 与 CGO 交叉编译支持
- 引入 S6 Overlay v3 守护与原生故障熔断保护
- 接入 HAOS `app_config` 对象化隔离持久化与 Supervisor API 选项自动回填
