# Qoder2API Hub for HA

把 **Qoder** 多账号池转为 OpenAI（`/v1/chat/completions`、`/v1/responses`）与 Anthropic（`/v1/messages`）兼容 API 的网关，附带 Web 管理面板、CN/Intl 双区调度、会话缓存、UMID 设备识别与 Pillow 图像编码支持。

> ⚠️ 本项目为第三方非官方网关，使用上游账号接入 API 属于逆向使用，请仅用于本人授权合规账号并自行评估账号与平台服务条款风险，勿将 `8790` 端口直接暴露于公网。

## 上游

[shuishuipingan/qoder2api-hub](https://github.com/shuishuipingan/qoder2api-hub)（MIT）· 基于官方源码在 `ghcr.io/hassio-addons/debian-base:9.3.0` + S6 overlay 多阶段自构建（构建期运行 `_install_umid.py` 提取原生 glibc `runtime-info`）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8790/tcp` | API（OpenAI / Anthropic 兼容网关）+ Web 管理面板 |

## 快速开始

1. 启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:8790`。
2. 默认面板登录密码为 `admin`（如已在配置项填写 `PANEL_PASSWORD`，重启一次即自动同步覆盖）。
3. 首次启动若未设置 `API_KEY`（且无存量启用密钥），会自动生成 `qd-...` 随机密钥，保存至 `/app/accounts/settings.json` 与 `/app/accounts/api_key.txt`，打印在日志并**自动回填到 HA 加载项配置 UI**。
4. 在面板中添加 Qoder 账号并按需配置区域/路由后，将客户端 Base URL 设为 `http://<你的HA>:8790/v1`（Anthropic 客户端为 `http://<你的HA>:8790`）即可调用。

## 配置项

环境变量遵循**默认 `unset`、仅必要项预置默认值**原则（空值或未填项不会导出空白环境变量）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `API_KEY` | `""`（不作为 env 导出） | 客户端调用 Bearer Key；首次留空提取存量启用密钥或自动生成回填；多 Key 模式下仅更新 `ha-option` 条目 |
| `PANEL_PASSWORD` | `""`（不作为 env 导出） | 面板登录密码（上游默认 `admin`）；仅在选项变更时同步设置，保留面板内改密 |
| `TZ` | `Asia/Shanghai` *(预置)* | 容器运行与日志时区 |
| `QD_CN_VPC_ENDPOINT` | `""`（`unset`） | 可选企业 VPC 专线端点 URL；留空不额外放行内网 SSRF |
| `HTTPS_PROXY` | `""`（`unset`） | 可选出站代理 URL（例：`http://192.168.1.2:7890`）；留空直连 |
| `QD_PROXY_DEFAULT_REALM` | `unset` *(可选覆盖)* | 未设时交由上游默认 `cn`；可在「显示未使用的可选配置项」中选择 `cn` 或 `intl` |
| `QD_SESSION_CACHE` | `unset` *(可选覆盖)* | 未设时交由上游默认 `off`；可选 `off` / `memory` / `redis` |
| `QD_ANTHROPIC_THINKING` | `unset` *(可选覆盖)* | 未设时优先跟随面板全局与单 Key 配置，否则为 `off`；可选 `off` / `empty` |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/app/accounts/` | 账号凭据（`*.json`）、`settings.json`、`machine_identity.json`、`scheduler/` | ✅ |
| `/data/logs/` | 运行日志（`gateway.log`、`gateway.err.log`，启停时与容器 stdout 同步留档，超 20MB 启动自动裁剪） | ❌ |
| `/data/usage/` | 调用统计 JSONL 与汇总缓存 | ❌ |

详细说明与故障排查见 [DOCS.md](DOCS.md)。
