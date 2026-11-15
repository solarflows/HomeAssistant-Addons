# WorkBuddy2API Hub for HA

把腾讯 **WorkBuddy / CodeBuddy** 账号池转为 OpenAI（`/v1/chat/completions`、`/v1/responses`）与 Anthropic（`/v1/messages`）兼容 API 的多账号网关，附带 Web 管理面板、CN/Intl 双区切换、Go uTLS 指纹桥接及本地用量监控。

> ⚠️ 本项目为第三方非官方网关，使用上游账号接入 API 属于逆向使用，请仅用于本人授权合规账号并自行评估账号与平台服务条款风险，勿将 `8788` 端口直接暴露于公网。

## 上游

[ardeyouxipianyi/workbuddy2api-hub](https://github.com/ardeyouxipianyi/workbuddy2api-hub)（MIT）· 基于官方源码在 `ghcr.io/hassio-addons/debian-base:9.3.0` + S6 overlay 多阶段自构建（Stage 1 `golang:1.24` 编译 `wb-tls-bridge`）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8788/tcp` | API（OpenAI / Anthropic 兼容网关）+ Web 管理面板 |

## 快速开始

1. 启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:8788`。
2. 默认面板登录密码为 `admin`，可在面板内自行修改并持久化保存。
3. 客户端调用密钥可在 Web 管理面板中创建与管理；若在加载项配置中显式填写 `API_KEY`，初始化脚本将同步写入 `settings.json`。
4. 在面板中添加 WorkBuddy / CodeBuddy 账号后，将客户端 Base URL 设为 `http://<你的HA>:8788/v1`（Anthropic 客户端为 `http://<你的HA>:8788`）即可调用。

## 配置项

环境变量遵循**默认 `unset`、仅冷启动基础设施项预置在 options** 原则（面板密码与时区已分别由 Web 面板自治及主机同步，不在此冗余暴露）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `API_KEY` | `""`（不作为 env 导出） | 客户端调用 Bearer Key（可选）；留空完全由 Web 管理面板自治管理；配置后同步至 `settings.json` |
| `HTTPS_PROXY` | `""`（`unset`） | 可选出站代理 URL（例：`http://192.168.1.2:7890`）；留空直连 |
| `WB_ENABLE_ANTHROPIC_MESSAGES` | `true` *(默认开启)* | 默认开启 Anthropic `/v1/messages` 兼容端点；可在 schema 中显式设为 `false` 关闭 |
| `WB_PROXY_DEFAULT_REALM` | `unset` *(可选覆盖)* | 未设时交由上游默认 `intl`；可在「显示未使用的可选配置项」中选择 `intl` 或 `cn` |
| `WB_TLS_FINGERPRINT` | `unset` *(可选覆盖)* | 未设时交由上游默认 `auto`；可选 `auto` / `python` / `node` |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/app/accounts/` | 账号凭据（`*.json`）、`settings.json` | ✅ |
| `/data/usage/` | 用量统计、限流事件、每日估算与 `logs.sqlite3` | ❌ |
| `/data/catalog/` | 官方模型/产品目录动态缓存 | ❌ |
| `/data/subbridge-data/` | 可选 Mihomo 订阅桥运行数据 | ❌ |
| `/data/updates/` | 面板一键更新备份与回滚快照（软链至 `/app/updates`） | ❌ |

详细说明与故障排查见 [DOCS.md](DOCS.md)。
