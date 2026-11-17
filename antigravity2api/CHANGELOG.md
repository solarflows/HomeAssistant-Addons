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
