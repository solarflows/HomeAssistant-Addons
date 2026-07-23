# FlareSolverr

绕过 Cloudflare 反爬虫页面的代理服务器，为 Home Assistant 等应用的 HTTP 请求提供透明代理。

## 上游

[FlareSolverr/FlareSolverr](https://github.com/FlareSolverr/FlareSolverr)

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8191/tcp` | FlareSolverr 代理端口 |
| `8192/tcp` | Prometheus 指标导出端口 |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `LOG_LEVEL` | `info` | 日志级别：`debug` / `info` / `warn` / `error` |
| `HEADLESS` | `true` | Chrome 无头模式 |
| `DISABLE_MEDIA` | `false` | 禁用媒体资源请求以加速 |
| `LANG` | (空) | 浏览器语言（如 `zh-CN`） |
| `PROMETHEUS_ENABLED` | `false` | 启用 Prometheus 指标导出 |
| `PROXY_URL` | (空) | 上游代理地址 |
| `PROXY_USERNAME` | (空) | 上游代理用户名 |
| `PROXY_PASSWORD` | (空) | 上游代理密码 |
| `TZ` | `UTC` | 时区 |

## 容器能力

- `SYS_ADMIN` / `IPC_LOCK`：Chrome/Selenium 所需权限
- `/dev/shm`：256MB tmpfs（Chrome 共享内存）

## 使用方式

启动后，将 HTTP 客户端代理指向 `http://<host>:8191/v1` 即可：

```bash
curl -L -X POST 'http://localhost:8191/v1' \
  -H 'Content-Type: application/json' \
  --data-raw '{"cmd":"request.get","url":"http://www.google.com/","maxTimeout":60000}'
```

> ⚠️ 每次请求会启动 Chrome 浏览器实例，内存消耗较大，请勿并发过多请求。
