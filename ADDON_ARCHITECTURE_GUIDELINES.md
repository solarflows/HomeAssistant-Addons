# Home Assistant 加载项配置治理、时区同步与 Supervisor 通信规范

> **适用范围**：本仓库（`solarflows/HomeAssistant-Addons`）所有现存及未来新增的 Home Assistant 加载项。
> **核心目标**：彻底根除配置多头管理踩踏、环境变量只读锁死、时区配置漂移与网络通信抖动问题。

---

## 一、 配置准入与生命周期边界 (The Cold-Boot Boundary)

### 1. 核心判定公理
> **“运行时可调（Hot-Reloadable / Web-Managed）的归业务控制台；只有冷启动必须固化（Cold-Boot Invariants）的才进 HA Options。”**

在加载项生命周期中，严格界定外部声明式配置（HA Options）与内部业务控制台的边界：

```
                      [配置参数类型分类]
                             │
            ┌────────────────┴────────────────┐
            ▼                                 ▼
   【运行时动态可调 / 业务凭据】           【冷启动硬约束 / 基础设施】
            │                                 │
     ❌ 坚决剔除出 HA Options          ✅ 唯一准入 HA Options / Schema
            │                                 │
  - 业务登录密码 / 管理密钥 / 令牌   - JVM 堆内存上限 (-Xmx / LOW_MEMORY)
  - 面板内可热改的出站代理与路由     - 底层无状态引擎并发池 (BROWSER_POOL_SIZE)
  - 模型映射 / 账户并发 / 业务规则   - 冷启动必需的网络代理 (PROXY_URL)
  - 邮件推送 / 报警设置              - 底层包管理器源 (NPM_REGISTRY)
                                     - 无 Web 界面的纯微服务启动参数 (trawl, flaresolverr)
```

### 2. 负向红线（禁止暴露于 HA Options）
1. **业务密码与凭据坚决不暴露**：
   - 严禁在 `config.yaml` 的 `options` 或 `schema` 中暴露 `ADMIN_PASSWORD`、`MANAGEMENT_KEY`、`PANEL_PASSWORD` 等字段；
   - **出厂预置与文档规范**：出厂统一预置默认凭据（如 `admin / admin` 或 `666 / 666`），并在 `DOCS.md` 与多语言描述中明示；首次登录后由用户在 Web 控制台内修改，由应用私有存储（`.env`、`config.yaml` 或 SQLite）全权自治；
   - **解除环境变量锁死**：禁止将业务凭据通过 Docker `ENV` 导出，避免触发 Go/Node 上游将参数标记为只读（如 Antigravity2API 的 `cfg.Environment`）。
2. **杜绝脆弱的双向胶水层**：
   - 从源头上不暴露业务密码，彻底消除“外部选项 vs 内部修改”的二元真理源冲突，不再维护复杂的 sidecar 差分快照。

### 3. 配置分层设计（Options 常用项 vs Schema 高级折叠项）
- **`options` 字典**：仅保留最核心的常用冷启动项（如首启代理 `PROXY: ""`、基础资源 `LOW_MEMORY: true`）；
- **`schema` 字典**：对于架构选型类的冷启动参数（如 `QD_SESSION_CACHE`、`WB_TLS_FINGERPRINT`），在 `schema` 中声明类型约束，但**不在 `options` 中预置默认值**。常规用户在 GUI 界面看到清爽面板，高级用户切换至 YAML 模式按需配置生效。

---

## 二、 宿主机时区自动无感同频 (Zero-Option Timezone)

### 1. 官方原生机制
Home Assistant Supervisor 在启动任何容器时，已在底层原生固化了全自动时区同步链路：
1. **Supervisor 自动注入**：`supervisor/docker/app.py` 固定向容器注入环境变量 `TZ=<self.sys_timezone>`（即用户在 HA「系统 -> 常规」中选择的时区）；
2. **基底镜像自动消费**：官方 `ghcr.io/hassio-addons/debian-base` 内置 S6 服务 `base-app-timezone`，在任何 `cont-init.d` 运行前已自动执行：
   ```bash
   ln -snf "/usr/share/zoneinfo/${TZ:-UTC}" /etc/localtime
   echo "${TZ:-UTC}" > /etc/timezone
   ```

### 2. 治理禁令与自愈实现
- **禁止项**：**严禁在 `config.yaml` 的 `options` 或 `schema` 中声明 `TZ`**。硬编码 `TZ: "Asia/Shanghai"` 属于反模式，会破坏海外用户的宿主自动同频；
- **非 debian-base 容器自愈兜底模板**（放置于 `00-init.sh`）：
  ```bash
  # 自动同步宿主机时区（由 Supervisor 环境变量原生注入）
  if [ -n "${TZ:-}" ] && [ -f "/usr/share/zoneinfo/${TZ}" ]; then
      ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
      echo "${TZ}" > /etc/timezone
  fi
  ```

---

## 三、 Supervisor 通信与套接字优先协议 (SUPERVISOR_SOCKET First)

### 1. 通信双通道对比

| 评估维度 | 传统 HTTP 通道 (`http://supervisor`) | 原生套接字通道 (`SUPERVISOR_SOCKET`) |
|---|---|---|
| **物理形式** | 经由 Docker 桥接网络的 HTTP 协议 | 经由 `/run/supervisor/supervisor.sock` 的 Unix Domain Socket |
| **DNS 依赖** | 强依赖 Docker 内嵌 DNS (`127.0.0.11`) 解析 `supervisor` 域名 | **零依赖**（纯本地文件系统通信） |
| **鉴权机制** | 强制要求携带 `Authorization: Bearer $SUPERVISOR_TOKEN` | **免 Token**（Supervisor 直接通过套接字路径识别调用者身份） |
| **响应耗时** | 30ms ~ 50ms | **< 1ms** |
| **稳定性** | 网络抖动或 DNS 慢时存在超时风险 | **极高**（完全无视网络栈故障） |

### 2. 标准局部增量选项回写函数 (Atomic Backfill)
Supervisor 的 `POST /addons/self/options` 接口原生支持**增量合并**（无需读取全量 `options.json` 再覆盖）。在启动脚本中统一采用以下极简原子函数：

```bash
# 基于 SUPERVISOR_SOCKET 的原生增量回写（仅在首启生成必要静态 API Key 时调用）
ha_backfill_option() {
    local key="$1"
    local val="$2"
    local sock="${SUPERVISOR_SOCKET:-/run/supervisor/supervisor.sock}"

    if [ -S "${sock}" ]; then
        local payload
        payload=$(jq -nc --arg k "${key}" --arg v "${val}" '{options: {($k): $v}}')
        curl -fsS -m 5 --unix-socket "${sock}" \
            -X POST \
            -H "Content-Type: application/json" \
            --data "${payload}" \
            "http://localhost/addons/self/options" >/dev/null 2>&1 || true
    fi
}
```

---

## 四、 内网通信与安全边界规范

### 1. Home Assistant Core 零配置直连
- **禁止项**：严禁引导用户在 Web 控制台内填写宿主局域网 IP（如 `192.168.1.x:8123`）；
- **标准通道**：容器内直接使用 `http://homeassistant:8123`。Docker 内部 DNS 已固定解析，宿主 DHCP 换 IP 永不掉线。

### 2. 传输层加密（SSL / HTTPS）定界
- **容器内部坚决保持纯 HTTP**：
  - 容器服务默认监听明文 HTTP；
  - 依赖 Ingress 反向代理实现免密单点登录与外部 SSL 终结；
- **拒绝盲目强推 `/ssl` 宿主证书**：
  - 宿主证书（Let's Encrypt / DuckDNS）绑定的是公网二级域名；
  - 局域网内通过 IP 直连（如 `https://192.168.x.x:PORT`）会因域名不匹配导致浏览器强制报安全红屏（`NET::ERR_CERT_COMMON_NAME_INVALID`）；
  - 除非插件仅供外部公网特定同域名访问，否则不启用容器级 SSL。

### 3. API 免密调用与鉴权代理
- 需要与 HA 实体交互时，通过 Supervisor 代理端点访问：
  ```http
  GET  http://supervisor/core/api/states/<entity_id>
  POST http://supervisor/core/api/services/<domain>/<service>
  Authorization: Bearer <SUPERVISOR_TOKEN>
  ```
  无需用户在个人配置中手动签发长期访问令牌。

---

## 五、 全量 16 款加载项配置治理基准矩阵

| 加载项 (Add-on) | 当前持久化真理源 | 准入 HA Options 暴露项 | 准入高级 Schema (折叠) | 坚决剔除项 (由 Web 或底层自治) |
|---|---|---|---|---|
| **`antigravity2api`** | `/config/.env` | `PROXY`, `API_KEYS` | 无 | `ADMIN_USERNAME`, `ADMIN_PASSWORD` *(出厂 admin/admin 并在 Web 改密)* |
| **`cliproxyapi`** | `/config/config.yaml` | `PROXY_URL` | 无 | `MANAGEMENT_KEY` *(首启生成至 txt，面板接管)* |
| **`cliproxyapi-cpamp`** | `/config/config.yaml` | `PROXY_URL` | 无 | `MANAGEMENT_KEY`, `CPAMP_ADMIN_KEY` |
| **`qoder2api-hub`** | `/app/accounts/settings.json` | `API_KEY`, `HTTPS_PROXY` | `QD_CN_VPC_ENDPOINT`, `QD_SESSION_CACHE`, `QD_PROXY_DEFAULT_REALM`, `QD_ANTHROPIC_THINKING` | `PANEL_PASSWORD`, `TZ` |
| **`workbuddy2api-hub`** | `/app/accounts/settings.json` | `API_KEY`, `HTTPS_PROXY` | `WB_ENABLE_ANTHROPIC_MESSAGES`, `WB_TLS_FINGERPRINT`, `WB_PROXY_DEFAULT_REALM` | `PANEL_PASSWORD`, `TZ` |
| **`mcphub`** | `/app/data/` | `NPM_REGISTRY` | 无 | `ADMIN_PASSWORD` *(首启日志打印随机密码，面板改密)* |
| **`qdtoday`** | `/usr/src/app/config/database.db` | `QD_DEBUG`, `USE_PYCURL`, `AES_KEY`, `COOKIE_SECRET`, `DOMAIN`, `MAIL_*` | `DNS_SERVER`, `PROXIES`, `TASK_*`, `NEW_TASK_DELAY` | **全量保留** *(上游无系统设置页，均为冷启动参数)* |
| **`filebrowser-quantum`** | `/config/database.db` | `auth_method`, `default_user_scope` | 无 | 用户密码已在 DB，不暴露 |
| **`alist-tvbox`** | `/config/` | `LOW_MEMORY`, `ATV_DEBUG`, `JVM_OPTS` | 无 | 保持现状 *(底层 JVM 堆内存约束)* |
| **`alist-tvbox-standalone`** | `/config/` | `LOW_MEMORY`, `ATV_DEBUG`, `JVM_OPTS` | 无 | 保持现状 *(纯 Java 进程堆约束)* |
| **`flaresolverr`** | *(无状态)* | `LOG_LEVEL`, `HEADLESS`, `DISABLE_MEDIA`, `PROXY_*` | 无 | 保持现状 *(纯无状态 Headless 引擎)* |
| **`trawl`** | *(无状态)* | `LOG_LEVEL`, `BROWSER_POOL_SIZE`, `MITM_ENABLED`, `CAPTCHA_*`, `PROXY_*` | 无 | 保持现状 *(无 Web 面板反爬微服务)* |
| **`lucky`** | `/goodluck/lucky.conf` | **无** (`options: null`) | 无 | 纯自治典范 |
| **`uptime-kuma`** | `/opt/uptime-kuma/data/kuma.db` | **无** (`options: null`) | 无 | 纯自治典范 |
| **`qinglong`** | `/ql/data/` | **无** (`options: null`) | 无 | 纯自治典范 |
| **`baihu-panel`** | `/app/data/data.db` | **无** (`options: {}`) | 无 | 纯自治典范 |
