# CLIProxyAPI（轻量版）

多账号 AI CLI 网关：把 Gemini CLI / Codex / Claude Code / Antigravity / Grok / Kimi 等 OAuth 账号包装为 OpenAI / Gemini / Claude 兼容 API，供局域网客户端统一调用。

本版本内置 **CPAMP 轻量管理面板**（单文件 `management.html`，替代官方管理界面），无额外服务与数据库。

> ⚠️ 本项目为第三方非官方网关，使用上游账号接入 API 属于逆向使用，请仅用于本人授权合规账号并自行评估账号与各厂商服务条款风险。

## 上游

- 网关：[router-for-me/CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)（MIT）· 基于 `ghcr.io/hassio-addons/debian-base` + S6 overlay 打包上游 Release 二进制
- 管理面板：[seakee/CPA-Manager-Plus](https://github.com/seakee/CPA-Manager-Plus)（MIT，内置 `management.html` 轻量面板种子，运行时支持自动更新）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8317/tcp` | API / 轻量管理面板（`/management.html`，必开） |
| `1455/tcp` | Codex OAuth 回调（默认关闭，按需启用） |
| `54545/tcp` | Antigravity OAuth 回调（默认关闭，按需启用） |
| `8085/tcp` `51121/tcp` `11451/tcp` | OAuth 回调备用端口（默认关闭，按需启用） |

## 快速开始

1. 启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:8317/management.html`。
2. 使用**管理密钥**登录：首次留空启动时自动生成随机密钥（打印在日志、保存于 `/config/management_key.txt` 并**自动回填到 HA 选项**）。
3. 在面板中 OAuth 登录 / 添加账号，并创建客户端 API Key。
4. 客户端将 Base URL 指向 `http://<你的HA>:8317/v1` 即可调用。

## 配置项

本加载项不直接导出配置项为空白环境变量，由 `00-init.sh` 按变更状态同步写入 `/config/config.yaml`：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `MANAGEMENT_KEY` | `""`（不作为 env 导出） | 管理密钥；首次留空自动生成并回填到本选项；修改重启生效，清空则交由面板管理 |
| `PROXY_URL` | `""`（不作为 env 导出） | 上游请求与面板下载代理；修改重启回写配置，清空交由面板管理 |

## 与完整版（`cliproxyapi-cpamp`）的区别

| | `cliproxyapi`（本版） | `cliproxyapi-cpamp`（完整版） |
|---|---|---|
| 网关 + 轻量面板（`:8317`） | ✅ | ✅ |
| 完整管理面板（`:18317`） | ❌ | ✅（请求监控 / 用量 / 成本 / 配额） |
| 额外依赖 | 无 | 内置独立 Manager Server + SQLite |

> ⚠️ 两个版本默认占用相同端口（`8317`），请勿同时启用。

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/config/config.yaml` | 主配置文件（首启生成后由面板接管） | ✅ |
| `/config/auths/` | OAuth 账号凭据（`app_config` 直挂） | ✅ |
| `/config/management_key.txt` | 管理密钥明文副本 | ✅ |
| `/data/cliproxyapi/` | 日志、插件与面板静态缓存 | ❌ |

详细说明与故障排查见 [DOCS.md](DOCS.md)。
