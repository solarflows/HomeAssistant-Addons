# TRAWL for HA

自托管反爬抓取引擎（FlareSolverr 替代）。本文档覆盖端口、配置、MITM 代理、*arr 对接与故障排查。

- 上游项目：[germondai/trawl](https://github.com/germondai/trawl)
- 上游文档：[docs.trawl.germondai.com](https://docs.trawl.germondai.com/)

---

## 1. 这是什么

TRAWL 是"自适应路由"的抓取引擎：先用普通 HTTP 请求，遇到 JS 挑战时升级到浏览器求解（Camoufox 强化版 Firefox），并按需升级到数据中心/住宅代理。支持 Cloudflare / Turnstile / reCAPTCHA v2 / hCaptcha / GeeTest 等，且对 Prowlarr 等 *arr 工具提供 FlareSolverr 兼容的 `/v1` 端点。

执行层级（tier）：

```
Tier 1 普通 HTTP → Tier 2 缓存会话 → Tier 3 新浏览器求解 → Tier 4 住宅代理
```

## 2. 与 flaresolverr 加载项的关系

- 端点协议兼容：Prowlarr / Jackett 中把 FlareSolverr URL 换成本加载项地址即可。
- **端口冲突**：二者默认都用 8191/8192，请勿同时启用；如需并存，请在两个加载项的网络配置中改为不同宿主端口。
- 本加载项为单容器模式（无 Redis，内存会话缓存），对应上游 `docker-compose.minimal.yml`。

## 3. 首次使用

1. 启动加载项（首次启动约 15–30 秒预热浏览器池）。
2. `curl http://<你的HA>:8191/health` 应返回健康。
3. Prowlarr → Settings → Indexers → FlareSolverr URL 填 `http://<你的HA>:8191`。

## 4. 配置项

| 配置项 | 说明 |
|---|---|
| `LOG_LEVEL` | `error` / `warn` / `info` / `debug` / `silent` |
| `BROWSER_POOL_SIZE` | 预热浏览器数；每实例约 300–400MB 内存，小内存设备保持 1 |
| `METRICS_DASHBOARD_ENABLED` | 启用 `/dashboard` 本地仪表盘（请求历史/成功率/耗时） |
| `METRICS_DASHBOARD_TOKEN` | 仪表盘保护令牌；启用仪表盘时建议设置为 ≥32 字符随机串 |
| `MITM_ENABLED` | 启用 8192 端口的 HTTP/HTTPS 反爬代理（详见第 5 节） |
| `CAPTCHA_SOLVER` | `2captcha` 启用付费兜底（本地求解失败后尝试） |
| `TWOCAPTCHA_API_KEY` | 2Captcha 密钥 |
| `PROXY_URL` | Tier 3 出口代理；多个用逗号分隔组成池 |
| `RESIDENTIAL_PROXY_URL` | Tier 4 住宅代理，启用后可在 IP 被封时跨代理升级 |

> 更细粒度的调优（超时、截图、诊断、MHTML 等 60+ 变量）未暴露到 UI；如需请参考上游 `.env.example` 说明。

## 5. MITM 反爬代理（可选）

某些站点的 Cloudflare 通关凭据与浏览器连接指纹绑定，`/v1` 协议（只回传 cookie+UA）会再次被挑战。此时启用 MITM 代理：

1. 设置 `MITM_ENABLED = true` 并重启，确认 8192 端口已开放。
2. 下载 CA：`curl http://<你的HA>:8191/proxy-ca.crt -o trawl-ca.crt`
3. 把 CA 安装到**客户端**（如 Prowlarr 容器）的信任库；Prowlarr → Settings → Indexer Proxies → HTTP，主机填本加载项地址、端口 8192。

> CA 与私钥持久化在 `/data/trawl/proxy-ca`；删除会重新生成，届时客户端需重新安装。

## 6. 数据目录

| 容器路径 | 内容 | 是否随 HA 备份 |
|---|---|---|
| `/data/trawl/metrics/trawl.sqlite` | 请求历史（仪表盘数据） | ❌ |
| `/data/trawl/proxy-ca/` | MITM 根证书/私钥 | ❌ |

> 均为可再生数据，不参与备份；MITM CA 若重新生成，客户端需重新信任。

## 7. 资源与稳定性说明

- **共享内存**：上游要求 `shm_size: 1gb`。加载项启动时会尝试用 `SYS_ADMIN` 权限把 `/dev/shm` 扩容到 1g（HA 不支持 shm_size 配置）；若失败会打印警告，此时复杂页面可能使浏览器崩溃——可尝试降低 `BROWSER_POOL_SIZE`（设为 1）后重启。
- **内存**：每个浏览器实例 300–400MB+；官方建议最低 2 核 4GB。
- **启动慢属正常**：首次启动需预热浏览器池（15–30 秒），健康检查已为此放宽。

## 8. 老款 CPU（无 AVX2）

上游提供 `:baseline` 镜像变体（老 CPU / 旧内核，如 J4125、DSM 内核）。若标准镜像启动失败（Bun 运行时错误），可自行基于 `ghcr.io/germondai/trawl:1.8.0-baseline` 本地构建；或在你的仓库分支中把 Dockerfile 的 FROM 改为 baseline 后触发 CI。

## 9. 故障排查

- **Prowlarr 仍被 Cloudflare 拦截** → 试启用 MITM 代理（第 5 节）；部分站点需要住宅代理（`RESIDENTIAL_PROXY_URL`）。
- **/v1 返回超时** → 首次求解通常 15–45 秒；确认 `maxTimeout` 足够大。
- **浏览器频繁崩溃** → 共享内存扩容是否成功（日志含 "[trawl] /dev/shm enlarged"）；降低浏览器数或内存占用。
- **CPU 占用高** → 求解验证码属正常开销；`BROWSER_POOL_SIZE` 保持 1 可降低基线负载。

## 10. 免责声明

本加载项仅封装上游开源项目。请遵守目标网站的服务条款与所在地法律，仅将本工具用于你有权访问的内容。