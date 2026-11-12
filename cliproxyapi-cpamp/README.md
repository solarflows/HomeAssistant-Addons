# CLIProxyAPI + CPAMP（完整版）

多账号 AI CLI 网关（CLIProxyAPI）**加上 CPAMP 完整管理面板**：在轻量面板基础上额外提供请求级监控、用量与成本分析、配额巡检与账号自动化。

- 网关端口 `8317`：OpenAI / Gemini / Claude 兼容 API + CPAMP 轻量面板
- 面板端口 `18317`：CPAMP 完整面板（独立 `cpa-manager-plus` Server + SQLite 持久化）

> ⚠️ 本项目为第三方非官方网关，使用上游账号接入 API 属于逆向使用，请仅用于本人授权合规账号并自行评估账号与各厂商服务条款风险。

## 上游

- 网关：[router-for-me/CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)（MIT）· 基于 `ghcr.io/hassio-addons/debian-base` + S6 overlay 打包上游 Release 二进制
- 管理面板：[seakee/CPA-Manager-Plus](https://github.com/seakee/CPA-Manager-Plus)（MIT，含完整版 Server 二进制与轻量面板 `management.html`）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8317/tcp` | API / CPAMP 轻量面板（`/management.html`，必开） |
| `18317/tcp` | CPAMP 完整管理面板（`/management.html`，监控/用量/成本，必开） |
| `1455/tcp` | Codex OAuth 回调（默认关闭，按需启用） |
| `54545/tcp` | Antigravity OAuth 回调（默认关闭，按需启用） |
| `8085/tcp` `51121/tcp` `11451/tcp` | OAuth 回调备用端口（默认关闭，按需启用） |

## 快速开始

1. 启动加载项。
2. **轻量面板**（账号/OAuth/基础配置）：访问 `http://<你的HA>:8317/management.html`，用**管理密钥**登录（见日志或 `/config/management_key.txt`，首启自动生成并回填）。
3. **完整面板**（监控/用量/成本）：通过 **打开 Web UI** 或访问 `http://<你的HA>:18317/management.html`，用 **CPAMP 管理员密钥**登录（见日志或 `/config/cpamp_admin_key.txt`，首启自动生成并回填）。
4. 容器内已自动预连 CPA（loopback `:8317` + 密钥）；在面板中添加账号并替换示例客户端 API Key 后即可从 `:8317/v1` 调用。

## 配置项

密钥与代理配置由 `00-init.sh` 与 S6 `run` 按优先级写入 `/config/config.yaml` 或注入 `cpa-manager-plus`（留空选项不会覆盖已生成的持久密钥）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `MANAGEMENT_KEY` | `""`（不作为 env 导出） | CPA 网关管理密钥；首次留空自动生成并回填到本选项 |
| `CPAMP_ADMIN_KEY` | `""`（优先选项 > `/config/cpamp_admin_key.txt`） | CPAMP 完整面板登录密钥；首次留空自动生成 `cpamp_...` 并回填到本选项 |
| `PROXY_URL` | `""`（不作为 env 导出） | 上游请求代理；修改重启回写 `/config/config.yaml`，清空交由面板管理 |

## 与轻量版（`cliproxyapi`）的区别

| | `cliproxyapi`（轻量版） | `cliproxyapi-cpamp`（本版） |
|---|---|---|
| 网关 + 轻量面板（`:8317`） | ✅ | ✅ |
| 完整管理面板（`:18317`） | ❌ | ✅（请求监控 / 用量 / 成本） |
| SQLite 请求历史 / 配额巡检 | ❌ | ✅ |

> ⚠️ 两个版本默认占用相同网关端口（`8317`），**请勿同时安装运行**。CPAMP 用量队列为单消费者语义，本加载项已内置消费，请勿再额外接入其他消费组件（如 CPA Usage Keeper）。

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/config/config.yaml` | CPA 主配置 | ✅ |
| `/config/auths/` | OAuth 账号凭据（`app_config` 直挂） | ✅ |
| `/config/cpamp/` | `usage.sqlite` 与加密密钥 `data.key`（务必随 `/config` 同备份） | ✅ |
| `/config/management_key.txt` / `cpamp_admin_key.txt` | 管理密钥明文副本 | ✅ |
| `/data/cliproxyapi-cpamp/` | 日志、插件与面板静态缓存 | ❌ |

详细说明与故障排查见 [DOCS.md](DOCS.md)。
