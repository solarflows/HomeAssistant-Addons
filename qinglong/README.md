# 青龙面板

支持 Python3、JavaScript、Shell、TypeScript 的定时任务管理平台，Node.js 实现，功能强大。

## 上游

[whyour/qinglong](https://github.com/whyour/qinglong)

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `5700/tcp` | 青龙面板 Web UI 端口 |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `QL_DIR` | `/ql` | 青龙数据目录 |
| `TZ` | `Asia/Shanghai` | 时区 |

## 特色功能

- 多语言脚本支持（Python3 / JS / Shell / TypeScript）
- 在线管理脚本、环境变量、配置文件
- 在线查看任务日志
- 秒级定时任务
- 系统级通知（Bark / Server 酱 / Telegram 等）
- 暗黑模式 + 移动端适配
