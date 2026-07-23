# FlareSolverr

绕过 Cloudflare 反爬虫页面的代理服务器。

## 快速开始

启动后 HA 中的 HTTP 请求自动通过 FlareSolverr 代理，无需额外配置。

## 使用方式

### 作为 HTTP 代理

```bash
curl -L -X POST 'http://localhost:8191/v1' \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "cmd": "request.get",
    "url": "http://www.google.com/",
    "maxTimeout": 60000
  }'
```

### Home Assistant 集成

在 `configuration.yaml` 中添加：

```yaml
# 某些需要绕过 Cloudflare 的集成会自动使用
# 无需手动配置，FlareSolverr 通过 Supervisor 代理自动生效
```

## 配置说明

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `LOG_LEVEL` | `info` | `debug` / `info` / `warn` / `error` |
| `HEADLESS` | `true` | Chrome 无头模式 |
| `DISABLE_MEDIA` | `false` | 禁用媒体资源请求 |
| `PROMETHEUS_ENABLED` | `false` | 启用 Prometheus 指标 |
| `PROXY_URL` | (空) | 上游代理地址 |
| `PROXY_USERNAME` | (空) | 上游代理用户名 |
| `PROXY_PASSWORD` | (空) | 上游代理密码 |

## 资源要求

- 每次请求启动 Chrome 浏览器实例
- 推荐最低配置：2 CPU 核心 + 4GB 内存
- 请勿并发过多请求

## 上游文档

- [FlareSolverr/FlareSolverr](https://github.com/FlareSolverr/FlareSolverr)
