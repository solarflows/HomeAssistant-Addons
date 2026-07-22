# 白虎面板

轻量级定时任务管理系统，支持 Python、Node.js、Go、Rust、PHP 等所有主流语言，Go 编写、资源占用极低。

## 上游

[engigu/baihu-panel](https://github.com/engigu/baihu-panel)

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8052/tcp` | Web 管理面板端口 |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `BH_SERVER_PORT` | `8052` | 服务端口 |
| `BH_SERVER_HOST` | `0.0.0.0` | 监听地址 |
| `TZ` | `Asia/Shanghai` | 时区 |

## 特色

- 🔥 Go 语言编译为单一二进制，内存占用 < 20MB
- 📦 支持 Python / Node.js / Go / Rust / PHP 等任意可执行脚本
- ⏱ 秒级定时任务
- 📱 移动端适配
- 🔔 系统通知（邮件 / Bark / Server 酱 等）
