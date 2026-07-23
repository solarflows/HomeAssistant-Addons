# Uptime Kuma

自托管的服务监控工具，功能对标 Uptime Robot。Node.js 实现，界面精美，功能全面。

## 上游

[louislam/uptime-kuma](https://github.com/louislam/uptime-kuma)

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `3001/tcp` | Uptime Kuma Web 监控面板 |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `TZ` | `Asia/Shanghai` | 时区 |

> 所有监控配置通过 Web UI 操作，加载项无额外配置项。

## 特色功能

- 📊 支持 HTTP/S、TCP、DNS、Ping、MQTT、Docker、gRPC、SQL 等 10+ 种监控类型
- 🔔 70+ 通知渠道（Apprise 全平台）：Email、Telegram、Discord、钉钉、企业微信等
- 📈 状态页面：公开分享监控面板
- 🏠 Home Assistant 集成：通过 Webhook 推送监控状态到 HA
- 🎨 深色模式 + 多语言 + 移动端适配
- 🔐 多用户 + 2FA 认证
