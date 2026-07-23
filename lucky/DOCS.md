# Lucky（万吉）

强大的网络工具集，支持端口转发、DDNS、Web 服务、内网穿透、网络唤醒等功能。Golang 实现，高效稳定。

> ⚠️ Lucky 使用 `host_network: true`，管理端口 `16601` 直接绑定宿主机，注意端口冲突。

## 快速开始

启动后访问：`http://<HA-IP>:16601`

默认账号：`666` / 密码：`666`（首次登录后务必修改）

## 功能模块

### 端口转发
- 公网 IPv6 → 内网 IPv4 TCP/UDP 转发
- 黑白名单、连接数限制
- 定时开关、访问日志

### 动态域名 (DDNS)
- 支持 20+ DNS 服务商：阿里云、腾讯云、Cloudflare、DNSPod、华为云等
- 支持自定义回调 / Webhook
- 多网卡 IP 获取方式（网卡、URL、脚本）

### Web 服务
- 反向代理、重定向、URL 跳转
- HTTP BasicAuth、IP/UA 黑白名单
- 静态文件服务

### 其他模块
| 模块 | 说明 |
|------|------|
| STUN 内网穿透 | NAT1 网络下无需公网 IPv4 |
| 网络唤醒 (WOL) | 远程唤醒/关机，支持物联网平台 |
| 计划任务 | 可视化 Cron 编辑 |
| ACME 自动证书 | 自动申请续签 Let's Encrypt |
| 网络存储 | 本地存储 / WebDAV / 阿里云盘挂载 + FileBrowser |

## 数据持久化

- `/config/luckyconf/lucky.conf` — 所有配置（端口转发、DDNS 等均在 Web 面板配置后写入）

## 上游文档

- [gdy666/lucky](https://github.com/gdy666/lucky)
- [官方使用指南](https://lucky666.cn/docs/intro)