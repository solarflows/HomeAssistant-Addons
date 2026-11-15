# Antigravity2API for HA

将 Google Antigravity 的 Agent 模型转换为 OpenAI、Claude 和 Gemini 兼容 API，基于源码构建并在编译期开启 BoringCrypto 原生 TLS 模拟。

- 上游仓库：[Mag1cFall/Antigravity2API](https://github.com/Mag1cFall/Antigravity2API)
- 开源协议：MIT

---

## 1. 核心特性

- **协议全面兼容**：
  - OpenAI 兼容：`/v1/chat/completions`、`/v1/models`、`/v1/images`、`/v1/audio`、`/v1/files`
  - Claude 兼容：`/v1/messages`、`/v1/messages/count_tokens`
  - Gemini 兼容：`/v1beta/models/*:generateContent`、Files API
- **支持的模型**：
  - `gemini-4-argon`
  - `gemini-3.8-flash`
  - `claude-opus-5-5`
  - `claude-sonnet-5-5`
  - `gpt-oss-120b`
- **BoringCrypto 原生编译**：
  - 源码在 CGO 模式下通过 `GOEXPERIMENT=boringcrypto` 编译，使 TLS 握手特征与 Google 官方客户端保持 100% 同构，抵御云端风控拦截。
- **多账号与额度调度**：
  - 支持多 Google 账号轮换、额度监控、冷却与故障自动换号。
- **内置 Web 控制台**：
  - 账户管理、额度图表、用量统计与请求日志实时查看。

---

## 2. 首次启动与账户登录

1. 启动加载项后，访问管理控制台：`http://<HA-IP>:8017/`
2. **管理端权鉴说明**：
   - **无头容器远程访问硬约束**：Antigravity2API 运行在无头 Docker 容器中，所有外部浏览器均通过非回环（非 loopback）IP 访问。上游机制强制要求：非回环远程访问必须开启 `ADMIN_AUTH_ENABLED=true` 且同时配置用户名与密码，否则管理 API 将直接拒绝远程请求或进程拒绝启动。
   - **出厂默认凭据**：初始化脚本已在 `/config/.env` 中出厂预置默认账号 `admin` 与默认密码 `admin`。
   - **控制台自治修改**：登录后可在 Web 控制台的「设置 -> 管理端」页面中自由修改密码；改动将由应用自身直接写入持久化配置 `/config/.env`，容器重启稳定保留（不通过 Docker process env 锁死）。
3. **首次绑定 Google 账户**：
   - 方式一：在 Web 仪表盘的「账户」页面点击添加，按引导使用 Google 授权码完成绑定；
   - 方式二：若宿主机或其他设备已登录过官方客户端，可将 `auth/<邮箱>/` 文件夹直接拷贝至 HAOS 的持久化目录 `/addon_configs/antigravity2api/auth/`，服务将在 2 秒内热重载识别。
4. **API 密钥**：
   - 默认留空（不强制鉴权）。若需保护 API，可在加载项「配置」页面填入 `API_KEYS`，或在 Web 控制台进行设置。

---

## 3. 配置说明

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `API_KEYS` | `""` | 可选客户端访问 Bearer Key（留空不强制鉴权；亦可在 Web 控制台配置） |
| `PROXY` | `""` | 可选上游全局代理（支持 HTTP/HTTPS/SOCKS5，如 `http://192.168.1.2:7890`） |

---

## 4. 数据持久化规划 (app_config 规范)

| 容器内路径 | 宿主映射位置 | 说明 | 备份属性 |
|---|---|---|---|
| `/config/auth` | `/addon_configs/antigravity2api/auth` | Google OAuth 账号凭据与虚拟设备档案 | ✅ 随 HA 备份 |
| `/config/.env` | `/addon_configs/antigravity2api/.env` | 持久化设置与端口密钥配置 | ✅ 随 HA 备份 |
| `/data/runtime` | `/data/runtime` | SQLite 请求记录、请求账本与缓存 | ❌ 私有卷不入备份 |
| `/data/logs` | `/data/logs` | 运行日志 | ❌ 私有卷不入备份 |
