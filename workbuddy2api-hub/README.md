# WorkBuddy2API Hub for HA

WorkBuddy / CodeBuddy 多账号池化反代网关与管理面板，基于官方源码在 `debian-base:9.3.0` + S6 overlay 多阶段自构建，提供 OpenAI（`/v1/chat/completions`、`/v1/responses`）及可选 Anthropic（`/v1/messages`）兼容接口、国内/国际双区切换、源码直编 Go uTLS 指纹桥接及本地用量监控。

适配 Home Assistant 加载项：账号池与设置通过 `app_config` 原生直挂持久化到 `/app/accounts`（零软链），调用统计/目录缓存/订阅桥数据分别挂载至 `/data/`；同时完整保留仓库自带启动/重启脚本与 `wb_update_external.py` 面板热更新协同能力。

> 与本仓库已有的 `workbuddy2api-panel`（`linguo2625469/workbuddy2api-panel`，端口 `7863`）相互独立，可同时安装或在需要时单独启用。

## 上游与构建方式

- 上游源码：[ardeyouxipianyi/workbuddy2api-hub](https://github.com/ardeyouxipianyi/workbuddy2api-hub)（MIT）
- 构建策略：多阶段源码构建（Stage 1 `golang:1.24` 交叉编译 `wb-tls-bridge`；Stage 2 `ghcr.io/hassio-addons/debian-base:9.3.0` + `python3` + `python3-yaml` + S6 overlay）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8788/tcp` | Web 管理面板与 OpenAI / Anthropic 兼容 API 网关 |

## 快速开始

1. 安装并启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:8788`。
2. 默认面板登录密码为 `admin`（如已在配置中设置 `PANEL_PASSWORD`，则使用所填密码）；进入面板后建议立即修改或配合 `PANEL_PASSWORD` 托管。
3. 若 `API_KEY` 留空，首次启动将自动生成 `wb-` 随机密钥写入 `/app/accounts/settings.json` 与 `/app/accounts/api_key.txt`，打印在日志中并**自动回填到 HA 加载项配置 UI**。
4. 面板内已对接 S6 伴生更新器（`wb_update_external.py`）：可直接在运行期通过面板进行检查更新/回退并触发 S6 自动重启，同时仍建议优先通过 HA 加载项商店接收整包镜像升级（含 Go uTLS 桥同步更新）。

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `API_KEY` | 空 | 客户端调用 Bearer Key；首次留空优先提取存量启用密钥或自动生成并回填；多 Key 模式下仅更新 `ha-option` 条目不覆盖面板其余 Key |
| `PANEL_PASSWORD` | 空 | 面板登录密码（上游默认 `admin`）；仅在选项变更时同步设置，保留面板内改密 |
| `TZ` | `Asia/Shanghai` | 容器时区 |
| `WB_PROXY_DEFAULT_REALM` | `intl` | 默认区域：`intl`（国际版）或 `cn`（国内版） |
| `WB_TLS_FINGERPRINT` | `auto` | 出站 TLS 指纹策略：`auto` / `python` / `node` |
| `WB_ENABLE_ANTHROPIC_MESSAGES` | `true` | 是否开启 Anthropic `/v1/messages` 兼容接口 |
| `HTTPS_PROXY` | 空 | 可选出站代理 URL（例：`http://192.168.1.2:7890`） |

## 数据目录

| 容器路径 | 说明 | 随 HA 备份 |
|---|---|---|
| `/app/accounts/` | 账号凭据（`*.json`）与面板/网关设置（`settings.json`） | ✅ |
| `/data/usage/` | 用量统计、限流记录、每日估算与 SQLite 日志索引 | ❌ |
| `/data/catalog/` | 官方模型/产品目录动态缓存 | ❌ |
| `/data/subbridge-data/` | 可选 Mihomo 订阅桥运行数据 | ❌ |
| `/data/updates/` | 面板一键更新备份与回滚快照 | ❌ |

详细使用与排查见 [DOCS.md](DOCS.md)。
