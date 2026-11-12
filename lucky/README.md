# Lucky（万吉）

轻量高效的全能网络工具集（Golang 实现），支持 IPv6/IPv4 端口转发、动态域名（DDNS）、Web 反向代理、STUN 内网穿透、WOL 网络唤醒与 ACME 自动证书。

> ⚠️ Lucky 启用了 `host_network: true`，管理端口 `16601` 及转发规则会**直接监听宿主机网络接口**，请留意宿主机端口冲突并妥善修改默认密码。

## 上游

[gdy666/lucky](https://github.com/gdy666/lucky)（闭源二进制分发）· 基于 `ghcr.io/hassio-addons/debian-base` + S6 overlay

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `16601/tcp` | Lucky Web 管理面板（`host_network: true`，支持 HA Ingress 侧边栏） |

## 快速开始

1. 启动加载项，通过 HA 侧边栏（Ingress）、**打开 Web UI** 或访问 `http://<你的HA>:16601`。
2. 使用初始默认账号 `666` / 密码 `666` 登录（**首次登录后请务必立即修改密码**）。
3. 在面板中配置端口转发、DDNS、反向代理或 ACME 证书规则，所有配置自动写入 `/goodluck/lucky.conf`。

## 配置项

本加载项无 HA UI 配置项（`options` 为空），容器运行时通过 `-c /goodluck/lucky.conf` 直接读取持久化配置文件，所有功能参数均在 Web 面板内操作。

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/goodluck/` | 主配置文件 `lucky.conf` 及面板规则状态（`app_config` 原生直挂） | ✅ |
| `/ssl/` | Home Assistant 与宿主机 SSL 证书目录（`ssl` 只读挂载） | ❌ *(只读系统卷)* |

详细说明见 [DOCS.md](DOCS.md)。
