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
2. **首次登录 Google 账户**：
   - 方式一：在 Web 仪表盘的「账户」页面点击添加，按引导使用 Google 授权码完成绑定；
   - 方式二：若宿主机或其他设备已登录过官方客户端，可将 `auth/<邮箱>/` 文件夹直接拷贝至 HAOS 的持久化目录 `/addon_configs/antigravity2api/auth/`，服务将在 2 秒内热重载识别。
3. **API 密钥**：
   - 首次启动若未设置 `API_KEYS`，系统将自动生成随机密钥并在加载项日志中打印，同时自动回填至加载项配置页面。

---

## 3. 配置说明

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `API_KEYS` | `""` | 客户端访问 API 时的 Bearer Key（留空首启自动生成并回填） |
| `ADMIN_PASSWORD` | `""` | 管理端登录密码（留空免密访问，设置后远程访问需登录） |
| `PROXY` | `""` | 上游全局代理（支持 HTTP/HTTPS/SOCKS5，如 `http://192.168.1.2:7890`） |

---

## 4. 数据持久化规划 (app_config 规范)

| 容器内路径 | 宿主映射位置 | 说明 | 备份属性 |
|---|---|---|---|
| `/config/auth` | `/addon_configs/antigravity2api/auth` | Google OAuth 账号凭据与虚拟设备档案 | ✅ 随 HA 备份 |
| `/config/.env` | `/addon_configs/antigravity2api/.env` | 持久化设置与端口密钥配置 | ✅ 随 HA 备份 |
| `/data/runtime` | `/data/runtime` | SQLite 请求记录、请求账本与缓存 | ❌ 私有卷不入备份 |
| `/data/logs` | `/data/logs` | 运行日志 | ❌ 私有卷不入备份 |
