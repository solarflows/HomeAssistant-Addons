# Uptime Kuma

自托管的网站及服务监控工具，功能对标 Uptime Robot。

## 快速开始

启动后访问：`http://<HA-IP>:3001`

首次使用需创建管理员账户。

## 支持的监控类型

| 类型 | 说明 |
|------|------|
| HTTP/S | 网站状态码、关键词匹配、证书过期 |
| TCP | 端口可达性 |
| DNS | 域名解析记录监控 |
| Ping | ICMP 连通性 |
| Docker | 容器运行状态 |
| Push | 被动式心跳检测 |
| gRPC | gRPC 服务健康检查 |
| MQTT | 消息订阅监控 |
| SQL | 数据库连接监控 |

## 通知方式

支持 Apprise 全平台通知（70+ 渠道）：Email、Telegram、Discord、Slack、Webhook、钉钉、企业微信等。

所有配置通过 Web UI 操作。

## Home Assistant 集成

通过 Webhook 通知类型将监控状态推送到 HA：
1. 在 Uptime Kuma 添加通知 → Webhook
2. Webhook URL 填入 HA 的 webhook 端点
3. 选择触发条件（宕机/恢复/重试等）

## 数据持久化

- `/config/uptime-kuma/data` — SQLite 数据库 + 配置
- `/config/uptime-kuma/mysql` — 可选的 MariaDB 数据（`UPTIME_KUMA_ENABLE_EMBEDDED_MARIADB=1` 时使用）

## 上游文档

- [louislam/uptime-kuma](https://github.com/louislam/uptime-kuma)
- [Uptime Kuma Wiki](https://github.com/louislam/uptime-kuma/wiki)
