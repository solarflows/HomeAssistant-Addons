# FlareSolverr

绕过 Cloudflare 反爬虫验证页面的本地代理服务，为 Home Assistant 及 *arr 生态应用提供 `/v1` HTTP 请求转发能力。

> ⚠️ 每次请求会启动 headless Chrome 实例，建议至少预留 2 CPU 核心与 4 GB 内存，避免高并发导致内存溢出；默认挂载 256MB `/dev/shm` tmpfs。

## 上游

[FlareSolverr/FlareSolverr](https://github.com/FlareSolverr/FlareSolverr)（MIT）· 基于上游官方镜像 + `entrypoint.sh` / `dumb-init` 适配层（修复大 `/dev/shm` 溢出与 Chromium wrapper 兼容）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8191/tcp` | FlareSolverr `/v1` HTTP 代理端口 |
| `8192/tcp` | Prometheus 监控指标端口（需开启 `PROMETHEUS_ENABLED`） |

## 快速开始

1. 启动加载项，等待浏览器驱动与服务就绪。
2. 将客户端或 Prowlarr / Jackett 等应用的 FlareSolverr 地址指向 `http://<你的HA>:8191`。
3. 如需命令行快速验证：
   ```bash
   curl -L -X POST 'http://<你的HA>:8191/v1' \
     -H 'Content-Type: application/json' \
     --data-raw '{"cmd":"request.get","url":"http://www.google.com/","maxTimeout":60000}'
   ```

## 配置项

`entrypoint.sh` 仅在配置项**非 null 且非空**时将其导出为环境变量（留空项保持 `unset` 由上游默认处理）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `LOG_LEVEL` | `info` *(预置)* | 日志级别：`debug` / `info` / `warn` / `error` |
| `LOG_FILE` | `""`（`unset`） | 日志写入路径；留空直接输出到容器 stdout（供 HA 日志页查看） |
| `HEADLESS` | `true` *(预置)* | 无头模式运行 Chrome；仅排障时改为 `false` |
| `DISABLE_MEDIA` | `false` *(预置)* | 禁用图片、CSS 与字体加载以节省带宽 |
| `LANG` | `""`（`unset`） | 浏览器语言（例：`zh_CN`、`en_GB`） |
| `PROMETHEUS_ENABLED` | `false` *(预置)* | 是否在 `8192` 端口启用 Prometheus 指标导出 |
| `PROXY_URL` | `""`（`unset`） | 可选上游代理 URL（例：`http://127.0.0.1:8080`）；留空直连 |
| `PROXY_USERNAME` | `""`（`unset`） | 上游代理认证用户名 |
| `PROXY_PASSWORD` | `""`（`unset`） | 上游代理认证密码 |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| *（无外部配置挂载）* | 采用无状态内存代理设计，不在宿主机 `app_config` 产生持久配置或膨胀备份 | ❌ |

详细说明见 [DOCS.md](DOCS.md)。
