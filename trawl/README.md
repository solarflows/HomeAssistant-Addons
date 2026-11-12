# TRAWL for HA

自托管反爬抓取引擎（Bun + Elysia + Camoufox Firefox）：绕过 Cloudflare / Turnstile / reCAPTCHA / hCaptcha / GeeTest 等 JS 挑战与验证码，作为 **FlareSolverr / Byparr 的 drop-in 替代品**适配 Prowlarr / Jackett / Sonarr 等 *arr 应用，同时提供原生 `/scrape`、MCP `/mcp` 与 `/dashboard` 仪表盘。

> ⚠️ 与 `flaresolverr` 加载项默认**端口冲突**（同为 `8191`/`8192`），两者请勿同时按默认端口启用。容器需 `SYS_ADMIN` / `IPC_LOCK` 以挂载 1GB `/dev/shm` 与运行浏览器池。

## 上游

[germondai/trawl](https://github.com/germondai/trawl)（AGPL-3.0）· 基于未修改上游官方镜像 + `ha-entrypoint.sh` 适配层（单容器内存会话缓存，对应 minimal compose）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

> 老款 x86 CPU（无 AVX2 指令集）可能需要上游 `:baseline` 镜像变体；若启动报指令集异常请参见 [DOCS.md](DOCS.md) 第 8 节。

## 端口

| 端口 | 说明 |
|---|---|
| `8191/tcp` | API / FlareSolverr 兼容端点（`/v1`）+ 本地仪表盘（`/dashboard`） |
| `8192/tcp` | MITM 反爬代理端口（默认关闭，需开启 `MITM_ENABLED`） |

## 快速开始

1. 启动加载项（首次启动约 15–30 秒预热 Camoufox 浏览器池）。
2. 检查健康端点：`http://<你的HA>:8191/health`。
3. **Prowlarr / Jackett** 中将 FlareSolverr URL 填为 `http://<你的HA>:8191`。
4. 如需命令行验证：
   ```bash
   curl -X POST http://<你的HA>:8191/v1 \
     -H 'Content-Type: application/json' \
     -d '{"cmd":"request.get","url":"https://nowsecure.nl","maxTimeout":60000}'
   ```

## 配置项

`ha-entrypoint.sh` 仅在配置项**非 null 且非空**时导出环境变量（留空保持 `unset` 由上游默认处理；容器内部固定预置 `SESSION_CACHE_DRIVER=memory`、`PORT=8191`、`METRICS_DB_PATH=/data/trawl/metrics/trawl.sqlite`、`MITM_CA_DIR=/data/trawl/proxy-ca`）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `LOG_LEVEL` | `info` *(预置)* | 日志级别：`error` / `warn` / `info` / `debug` / `silent` |
| `BROWSER_POOL_SIZE` | `1` *(预置)* | 预热 Camoufox 浏览器实例数（`1–8`，每实例约 300–400MB 内存） |
| `METRICS_DASHBOARD_ENABLED` | `false` *(预置)* | 开启 `/dashboard` 请求历史与统计面板 |
| `METRICS_DASHBOARD_TOKEN` | `""`（`unset`） | 仪表盘保护令牌（建议 ≥32 字符随机字符串） |
| `MITM_ENABLED` | `false` *(预置)* | 启用 `8192` 端口 MITM 反爬代理（使用前需信任 `/proxy-ca.crt`） |
| `CAPTCHA_SOLVER` | `none` *(预置)* | 付费验证码兜底求解：`none` / `2captcha` |
| `TWOCAPTCHA_API_KEY` | `""`（`unset`） | 2Captcha API Key（`CAPTCHA_SOLVER=2captcha` 时必填） |
| `PROXY_URL` | `""`（`unset`） | Tier 3 数据中心代理 URL（支持逗号分隔代理池） |
| `RESIDENTIAL_PROXY_URL` | `""`（`unset`） | Tier 4 住宅代理 URL（当目标 IP 被标记时跨代理升级） |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/data/trawl/metrics/trawl.sqlite` | 请求历史与仪表盘统计数据库 | ❌ |
| `/data/trawl/proxy-ca/` | MITM 根证书与私钥 | ❌ |

详细说明与故障排查见 [DOCS.md](DOCS.md)。
