# CLIProxyAPI + CPAMP（完整版）

多账号 AI CLI 网关（CLIProxyAPI）**加上 CPAMP 完整管理面板**：在轻量面板的基础上，额外提供请求级监控、用量与成本分析、配额巡检和账号自动化。

- 网关端口 `8317`：API + CPAMP 轻量面板
- 面板端口 `18317`：CPAMP 完整面板（独立 Manager Server，SQLite 持久化）

> ⚠️ 本项目为第三方非官方网关，使用上游账号接入 API 属于逆向使用，请自行评估账号风险并遵守各厂商服务条款。

## 上游

- 网关：[router-for-me/CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)（MIT）
- 管理面板：[seakee/CPA-Manager-Plus](https://github.com/seakee/CPA-Manager-Plus)（MIT）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8317/tcp` | API / 轻量面板（必开） |
| `18317/tcp` | CPAMP 完整面板（必开） |
| `1455/tcp` | Codex OAuth 回调（默认关闭，按需启用） |
| `54545/tcp` | Antigravity OAuth 回调（默认关闭，按需启用） |
| `8085` `51121` `11451` | OAuth 回调备用端口（默认关闭，按需启用） |

## 快速开始

1. 启动加载项。
2. **轻量面板**（管理账号/OAuth/配置）：`http://<你的HA>:8317/management.html`，用**管理密钥**登录（见日志或 `/config/cliproxyapi-cpamp/management_key.txt`）。
3. **完整面板**（监控/用量/成本）：`http://<你的HA>:18317/management.html`，用 **CPAMP 管理员密钥**登录（见日志或 `/config/cliproxyapi-cpamp/cpamp_admin_key.txt`）。
4. CPA 连接（URL 与管理密钥）已预配置好，打开完整面板即可看到数据；首次收到请求后监控页开始有记录。
5. 在面板中替换示例 API Key、添加账号后即可对外提供服务。

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `MANAGEMENT_KEY` | 空 | 管理密钥；留空自动生成（仅首次生成配置时生效） |
| `CPAMP_ADMIN_KEY` | 空 | CPAMP 完整面板登录密钥；留空自动生成 |
| `PROXY_URL` | 空 | 上游请求代理（仅首次生成配置时生效） |

## 与轻量版（cliproxyapi）的区别

| | cliproxyapi（轻量版） | cliproxyapi-cpamp（本版） |
|---|---|---|
| 网关 + 轻量面板 | ✅ | ✅ |
| 请求级监控 / 用量 / 成本分析 | ❌ | ✅（18317） |
| SQLite 请求历史 / 配额巡检 | ❌ | ✅ |
| 额外端口 | 无 | 18317 |

> ⚠️ 两个版本**不要同时安装**（端口冲突，且会出现两套面板各自为政）。CPAMP 的用量队列为单消费者语义——本加载项已内置一个消费者，不要再接第二个（如 CPA Usage Keeper / Oh-My-CPA）。

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/config/cliproxyapi-cpamp/config.yaml` | 主配置 | ✅ |
| `/config/cliproxyapi-cpamp/auths/` | OAuth 凭据 | ✅ |
| `/config/cliproxyapi-cpamp/cpamp/` | usage.sqlite + data.key | ✅ |
| `/config/cliproxyapi-cpamp/{management,cpamp_admin}_key.txt` | 密钥副本 | ✅ |
| `/data/cliproxyapi-cpamp/` | 日志 / 插件 / 面板缓存 | ❌ |

> `data.key` 用于解密数据库中的 CPAMP 配置；请确保它与 `usage.sqlite` 一同备份（两者都在 `/config` 内，HA 快照已覆盖）。

详细说明见 [DOCS.md](DOCS.md)。