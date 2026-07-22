# QD-Today

基于 HAR Editor 和 Tornado Server 的 HTTP 请求定时任务自动执行框架，Python 实现。

## 上游

[qd-today/qd](https://github.com/qd-today/qd)

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8923/tcp` | QD Web UI 端口 |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `TZ` | `Asia/Shanghai` | 时区 |

## 数据映射

| 路径 | 说明 |
|---|---|
| `/config` | 持久化配置目录 |
| `/ssl` | SSL 证书（只读） |

## 特色功能

- HAR 编辑器：从浏览器 HAR 文件导入请求模板
- 定时任务：Cron 表达式 / 倒计时 / 间隔执行
- 模板变量 + 环境变量
- 多用户 Web 管理
- 通知推送（邮件 / Server 酱 / PushPlus 等）
