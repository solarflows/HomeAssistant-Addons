# Lucky（万吉）

替代 socat 的网络工具，支持 IPv6 转内网 IPv4、动态域名、端口转发等功能。Golang 实现，高效稳定。

> ⚠️ Lucky 需要 `host_network: true`，启动时会直接监听宿主机端口。

## 上游

[gdy666/lucky](https://github.com/gdy666/lucky)

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `16601/tcp` | Lucky Web 管理面板（宿主机端口） |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `TZ` | `Asia/Shanghai` | 时区 |

> 所有功能配置（端口转发、DDNS 等）均在 Web 面板中操作，配置文件位于 `/config` 目录。

## 核心功能

- 端口转发（TCP/UDP）
- 动态域名（DDNS）：支持阿里云、腾讯云、Cloudflare 等
- Web 服务（反向代理）
- STUN 内网穿透
- 网络唤醒（WOL）
- 计划任务
- ACME 自动证书管理
- 网络存储
