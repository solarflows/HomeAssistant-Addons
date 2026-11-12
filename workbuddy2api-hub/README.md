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
2. 默认面板登录密码为 `admin`（如已在配置项填写 `PANEL_PASSWORD`，重启一次即自动同步覆盖）。
3. 首次启动若未设置 `API_KEY`（且无存量启用密钥），会自动生成 `wb-...` 随机密钥，保存至 `/app/accounts/settings.json` 与 `/app/accounts/api_key.txt`，打印在日志并**自动回填到 HA 加载项配置 UI**。
4. 在面板中添加 WorkBuddy / CodeBuddy 账号后，将客户端 Base URL 设为 `http://<你的HA>:8788/v1`（Anthropic 客户端为 `http://<你的HA>:8788`）即可调用。

## 配置项

环境变量遵循**默认 `unset`、仅必需或覆写上游默认行为的项预置默认值**原则（空值或未填项不会导出空白环境变量）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `API_KEY` | `""`（不作为 env 导出） | 客户端调用 Bearer Key；首次留空提取存量启用密钥或自动生成回填；多 Key 模式下仅更新 `ha-option` 条目 |
| `PANEL_PASSWORD` | `""`（不作为 env 导出） | 面板登录密码（上游默认 `admin`）；仅在选项变更时同步设置，保留面板内改密 |
| `TZ` | `Asia/Shanghai` *(预置)* | 容器运行与日志时区 |
| `WB_ENABLE_ANTHROPIC_MESSAGES` | `true` *(预置)* | 上游默认关闭，加载项预置开启 Anthropic `/v1/messages` 兼容端点 |
| `HTTPS_PROXY` | `""`（`unset`） | 可选出站代理 URL（例：`http://192.168.1.2:7890`）；留空直连 |
| `WB_PROXY_DEFAULT_REALM` | `unset` *(可选覆盖)* | 未设时交由上游默认 `intl`；可在「显示未使用的可选配置项」中选择 `intl` 或 `cn` |
| `WB_TLS_FINGERPRINT` | `unset` *(可选覆盖)* | 未设时交由上游默认 `auto`；可选 `auto` / `python` / `node` |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/app/accounts/` | 账号凭据（`*.json`）、`settings.json`、`api_key.txt` | ✅ |
| `/data/usage/` | 用量统计、限流事件、每日估算与 `logs.sqlite3` | ❌ |
| `/data/catalog/` | 官方模型/产品目录动态缓存 | ❌ |
| `/data/subbridge-data/` | 可选 Mihomo 订阅桥运行数据 | ❌ |
| `/data/updates/` | 面板一键更新备份与回滚快照（软链至 `/app/updates`） | ❌ |

详细说明与故障排查见 [DOCS.md](DOCS.md)。
