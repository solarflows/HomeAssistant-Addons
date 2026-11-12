# Qoder2API Hub for HA

Qoder 多账号池化反代网关与管理面板，基于官方源码在 `debian-base:9.3.0` + S6 overlay 多阶段自构建，提供 OpenAI 与 Anthropic（`/v1/messages`）兼容接口，构建期自动提取原生 Linux glibc 版 UMID 设备识别组件并配备 Pillow 图像编解码能力。

适配 Home Assistant 加载项：账号池、指纹与调度状态通过 `app_config` 原生直挂持久化到 `/app/accounts`（零软链），网关日志与调用统计分别隔离于 `/data/logs` 与 `/data/usage`；运行时复用上游原生 `start-qoder-proxy-lan.sh` 启动脚本（`exec` 前台托管给 S6 监督）。

## 上游与构建方式

- 上游源码：[shuishuipingan/qoder2api-hub](https://github.com/shuishuipingan/qoder2api-hub)（MIT）
- 构建策略：多阶段源码构建（Stage 1 克隆 Release Tag 源码并运行 `_install_umid.py` 提取原生 glibc `runtime-info`；Stage 2 `ghcr.io/hassio-addons/debian-base:9.3.0` + `python3` + `python3-pil` + S6 overlay）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8790/tcp` | Web 管理面板与 OpenAI / Anthropic 兼容 API 网关 |

## 快速开始

1. 安装并启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:8790`。
2. 默认面板登录密码为 `admin`（如已在配置中设置 `PANEL_PASSWORD`，则使用所填密码）；建议初次登录后立即修改或配合 `PANEL_PASSWORD` 托管。
3. 若 `API_KEY` 留空，首次启动将自动生成 `qd-` 随机密钥写入 `/app/accounts/settings.json` 与 `/app/accounts/api_key.txt`，打印在日志中并**自动回填到 HA 加载项配置 UI**。
4. 在管理面板中添加 Qoder 账号并按需调整区域与路由策略即可接入 AI 客户端。

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `API_KEY` | 空 | 客户端调用 Bearer Key；首次留空优先提取存量启用密钥或自动生成并回填；多 Key 模式下仅更新 `ha-option` 条目不覆盖面板其余 Key |
| `PANEL_PASSWORD` | 空 | 面板登录密码（上游默认 `admin`）；仅在选项变更时同步设置，保留面板内改密 |
| `TZ` | `Asia/Shanghai` | 容器时区 |
| `QD_PROXY_DEFAULT_REALM` | `cn` | 默认区域：`cn`（国内版）或 `intl`（国际版） |
| `QD_SESSION_CACHE` | `off` | 会话前缀缓存模式：`off` / `memory` / `redis` |
| `QD_ANTHROPIC_THINKING` | `off` | Anthropic thinking block 输出策略：`off` / `empty` |
| `QD_CN_VPC_ENDPOINT` | 空 | 企业 VPC 专线端点 URL（可选） |
| `HTTPS_PROXY` | 空 | 可选出站代理 URL（例：`http://192.168.1.2:7890`） |

## 数据目录

| 容器路径 | 说明 | 随 HA 备份 |
|---|---|---|
| `/app/accounts/` | 账号凭据（`*.json`）、`settings.json`、`machine_identity.json` 与调度状态 | ✅ |
| `/data/logs/` | 网关运行日志（`gateway.log`、`gateway.err.log`） | ❌ |
| `/data/usage/` | 调用统计、限流事件与汇总缓存 | ❌ |

详细使用与排查见 [DOCS.md](DOCS.md)。
