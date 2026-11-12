# Uptime Kuma

自托管的服务与网站监控工具（Node.js 实现），界面美观、功能全面，支持 HTTP/S、TCP、DNS、Ping、MQTT、Docker、gRPC、SQL 等监控类型与 70+ 通知渠道。

## 上游

[louislam/uptime-kuma](https://github.com/louislam/uptime-kuma)（MIT）· 基于 `ghcr.io/hassio-addons/debian-base` + S6 overlay 多阶段源码构建

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `3001/tcp` | Uptime Kuma Web 监控面板（支持 HA Ingress 侧边栏） |

## 快速开始

1. 启动加载项，通过 HA 侧边栏（Ingress）、**打开 Web UI** 或访问 `http://<你的HA>:3001`。
2. 首次进入按引导创建管理员账户。
3. 在面板中添加监控项与通知渠道（可通过 Webhook 通知将宕机/恢复事件推送至 Home Assistant）。

## 配置项

本加载项无 HA UI 配置项（`options` 为空），所有监控、状态页与通知规则均在 Web 面板内配置。容器内部固定预置以下运行环境变量：

| 环境变量 | 预置值 | 说明 |
|---|---|---|
| `UPTIME_KUMA_PORT` / `UPTIME_KUMA_HOST` | `3001` / `0.0.0.0` | 服务监听端口与地址 |
| `UPTIME_KUMA_WS_ORIGIN_CHECK` | `bypass` | 放行 HA Ingress 反向代理 WebSocket 握手 |
| `UPTIME_KUMA_ENABLE_EMBEDDED_MARIADB` | `1` | 启用内置嵌入式 MariaDB 支持 |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/opt/uptime-kuma/data/` | SQLite 数据库、配置与上传资源（`app_config` 原生直挂） | ✅ |
| `/data/mysql/` | 可选内置 MariaDB 数据目录（`/var/lib/mysql` 软链指向） | ❌ |
| `/share/` | Home Assistant 共享目录（`share` 挂载，备份/报表导出） | ❌ *(宿主机共享卷)* |
| `/ssl/` | SSL 证书目录（`ssl` 只读挂载，用于本地证书校验） | ❌ *(只读系统卷)* |

详细说明见 [DOCS.md](DOCS.md)。
