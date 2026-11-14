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
