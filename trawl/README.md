# TRAWL for HA

自托管反爬抓取引擎：绕过 Cloudflare / Turnstile / reCAPTCHA / hCaptcha / GeeTest 等 JS 挑战与验证码，**FlareSolverr / Byparr 的替代品**，可作为 *arr 全家桶（Prowlarr / Jackett / Sonarr 等）的 drop-in 替代。

- 兼容端点：`/v1`（FlareSolverr 协议，Prowlarr 直接对接）
- 原生 API：`/scrape`（返回 tier / 耗时 / 会话缓存等富元数据）
- MCP 工具：`/mcp`（可选，供 AI 代理读取网页）
- 本地仪表盘：`/dashboard`
- MITM 反爬代理：独立端口 `8192`（需开启）

## 上游

[germondai/trawl](https://github.com/germondai/trawl)（AGPL-3.0）

> ⚠️ 与现有 **flaresolverr** 加载项**端口冲突**（同为 8191/8192）。两者只能启用其一（或在网络配置中改用其他宿主端口）。

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

> 老款 x86 CPU（无 AVX2）可能需要上游 `:baseline` 镜像变体；如启动失败请参见 DOCS 第 8 节。

## 端口

| 端口 | 说明 |
|---|---|
| `8191/tcp` | API / FlareSolverr 兼容端点（`/v1`）+ 本地仪表盘 |
| `8192/tcp` | MITM 反爬代理（默认关闭，需开启 `MITM_ENABLED`） |

## 快速开始

1. 启动加载项（首次启动约 15–30 秒预热浏览器池）。
2. 健康检查：`http://<你的HA>:8191/health`。
3. **Prowlarr / Jackett**：把 FlareSolverr URL 填为 `http://<你的HA>:8191`。
4. 验证：`curl -X POST http://<你的HA>:8191/v1 -H 'Content-Type: application/json' -d '{"cmd":"request.get","url":"https://nowsecure.nl","maxTimeout":60000}'`

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `LOG_LEVEL` | `info` | 日志级别 |
| `BROWSER_POOL_SIZE` | `1` | 预热的浏览器实例数（并发求解用，注意内存） |
| `METRICS_DASHBOARD_ENABLED` | `false` | 启用本地仪表盘（`/dashboard`） |
| `METRICS_DASHBOARD_TOKEN` | 空 | 仪表盘保护令牌（建议 ≥32 字符） |
| `MITM_ENABLED` | `false` | 启用 8192 MITM 反爬代理 |
| `CAPTCHA_SOLVER` | `none` | 付费验证码兜底：`none` / `2captcha` |
| `TWOCAPTCHA_API_KEY` | 空 | 2Captcha 密钥（配合 `CAPTCHA_SOLVER=2captcha`） |
| `PROXY_URL` | 空 | Tier 3 数据中心代理（支持逗号分隔池） |
| `RESIDENTIAL_PROXY_URL` | 空 | Tier 4 住宅代理（启用跨 IP 升级） |

## 数据目录

| 容器路径 | 内容 |
|---|---|
| `/data/trawl/metrics/trawl.sqlite` | 请求历史（仪表盘数据） |
| `/data/trawl/proxy-ca/` | MITM 根证书与私钥 |

详细说明见 [DOCS.md](DOCS.md)。