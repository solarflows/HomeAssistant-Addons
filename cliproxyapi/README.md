# CLIProxyAPI（轻量版）

多账号 AI CLI 网关：把 Gemini CLI / Codex / Claude Code / Antigravity / Grok / Kimi 等 OAuth 账号包装为 OpenAI / Gemini / Claude 兼容 API，供局域网内的客户端统一调用。

本版本内置 **CPAMP 轻量管理面板**（单文件 `management.html`，替代官方管理界面），无额外服务与数据库。

> ⚠️ 本项目为第三方非官方网关，使用上游账号接入 API 属于逆向使用，请自行评估账号风险并遵守各厂商服务条款。

## 上游

- 网关：[router-for-me/CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)（MIT）
- 管理面板：[seakee/CPA-Manager-Plus](https://github.com/seakee/CPA-Manager-Plus)（MIT，仅轻量面板部分）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8317/tcp` | API / 管理面板（必开） |
| `1455/tcp` | Codex OAuth 回调（默认关闭，按需启用） |
| `54545/tcp` | Antigravity OAuth 回调（默认关闭，按需启用） |
| `8085` `51121` `11451` | OAuth 回调备用端口（默认关闭，按需启用） |

## 快速开始

1. 启动加载项，打开 Web UI（`http://<你的HA>:8317/management.html`）。
2. 用**管理密钥**登录：首次启动日志中会打印，或查看 `/config/cliproxyapi/management_key.txt`。
3. 在面板中 OAuth 登录 / 添加账号，并创建客户端 API Key。
4. 客户端把 API 地址指向 `http://<你的HA>:8317/v1` 即可。

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `MANAGEMENT_KEY` | 空 | 管理密钥；留空自动生成（仅首次生成配置时生效） |
| `PROXY_URL` | 空 | 上游请求代理（仅首次生成配置时生效） |

## 与完整版（cliproxyapi-cpamp）的区别

- 本版本只包含**轻量面板**：管理配置、账号、OAuth、日志；**不含**请求监控、用量统计与成本分析。
- 需要请求级监控 / 用量与成本统计 / 配额巡检时，请改用 `cliproxyapi-cpamp`（两者不要同时安装同时用同一端口）。

## 数据目录

| 容器路径 | 说明 |
|---|---|
| `/config/cliproxyapi/config.yaml` | 主配置（首次启动生成，之后由面板接管） |
| `/config/cliproxyapi/auths/` | OAuth 凭据（随 HA 备份） |
| `/config/cliproxyapi/management_key.txt` | 管理密钥明文副本 |
| `/data/cliproxyapi/` | 日志 / 插件 / 面板缓存 |

详细说明见 [DOCS.md](DOCS.md)。