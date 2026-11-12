# QD-Today

基于 **HAR Editor** 和 **Tornado Server** 的 HTTP 请求定时任务自动执行框架（Python 实现），支持从浏览器导出 HAR 快速构建签到/保活任务与多种通知推送。

## 上游

[qd-today/qd](https://github.com/qd-today/qd)（MIT）· 基于 `ghcr.io/hassio-addons/debian-base` + S6 overlay 同源多阶段源码构建（含完整 OCR 套件）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8923/tcp` | QD-Today Web 管理界面 |

## 快速开始

1. 启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:8923`。
2. 首次访问会进入注册页面，注册的首个用户即为管理员账号。
3. 在面板中通过 **新建模板 → HAR 编辑器** 粘贴浏览器导出的 HAR 内容，编排 Jinja2 变量与 Cron/间隔定时任务即可运行。

## 配置项

本加载项对**字符串项**遵循空值不导出（保持 `unset` 由 QD 使用内置默认），对**布尔/数值项**注入显式默认值；常用项在 UI 可见，高级项（标注 *可选覆盖*）可在 HA YAML 模式手动添加：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `QD_DEBUG` | `false` *(预置)* | 开启 Debug 调试日志 |
| `USE_PYCURL` | `true` *(预置)* | 启用 PycURL 加速 HTTP 请求 |
| `AES_KEY` | `""`（`unset`） | 数据加密密钥；建议自定义，留空使用 QD 内置默认 |
| `COOKIE_SECRET` | `""`（`unset`） | Cookie 签名密钥；建议自定义，留空使用 QD 内置默认 |
| `DOMAIN` | `""`（`unset`） | 公开访问域名（邮件重置密码功能依赖此项） |
| `MAIL_SMTP` | `""`（`unset`） | SMTP 邮件服务器地址；留空禁用邮件发送 |
| `MAIL_PORT` | `465` *(预置)* | SMTP 服务器端口 |
| `MAIL_USER` | `""`（`unset`） | SMTP 认证用户名；留空不启用 |
| `MAIL_PASSWORD` | `""`（`unset`） | SMTP 认证密码 |
| `DNS_SERVER` | `unset` *(可选覆盖)* | 指定 PycURL 使用的 DNS 服务器（例：`8.8.8.8`） |
| `TRACEBACK_PRINT` | `unset`（脚本兜底 `false`） | 是否在控制台输出完整异常 TraceBack 堆栈 |
| `PUSH_BATCH_SW` | `unset`（脚本兜底 `true`） | 是否允许定期批量推送任务日志 |
| `PROXIES` | `unset` *(可选覆盖)* | 全局代理列表，多个用 `\|` 分隔（`scheme://user:pass@host:port`） |
| `MAIL_SSL` | `unset`（脚本兜底 `true`） | 是否启用 SMTP SSL/TLS 加密连接 |
| `TASK_REQUEST_LIMIT` | `unset`（脚本兜底 `1500`） | 单任务最大 HTTP 请求次数限制 |
| `TASK_WHILE_LOOP_TIMEOUT` | `unset`（脚本兜底 `900`） | 单次 While 循环最大运行秒数 |
| `NEW_TASK_DELAY` | `unset`（脚本兜底 `1`） | 新建任务后默认等待秒数 |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/usr/src/app/config/` | QD SQLite 数据库与配置文件（`app_config` 原生直挂） | ✅ |
| `/ssl/` | SSL 证书与自定义 CA 目录（`ssl` 只读挂载） | ❌ *(只读系统卷)* |

详细说明见 [DOCS.md](DOCS.md)。
