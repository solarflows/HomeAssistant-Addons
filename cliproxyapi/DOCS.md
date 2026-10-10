# CLIProxyAPI for HA（轻量版）

多账号 AI CLI 网关 + CPAMP 轻量管理面板。本文档覆盖安装、配置、数据路径与故障排查。

- 上游网关：[router-for-me/CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)
- 管理面板（轻量版）：[seakee/CPA-Manager-Plus](https://github.com/seakee/CPA-Manager-Plus)
- 上游文档：[help.router-for.me](https://help.router-for.me/)

---

## 1. 这是什么

CLIProxyAPI（下称 CPA）把各 AI 厂商的 **CLI/OAuth 账号**（Gemini CLI、OpenAI Codex、Claude Code、Antigravity、Grok、Kimi、Devin 等）统一转换为 **OpenAI / Gemini / Claude 兼容 API**，供局域网内的任意客户端或 SDK 调用，并支持多账号轮询、会话粘性与故障切换。

本加载项 = CPA 官方 release 二进制 + **CPAMP 轻量面板**（单文件 `management.html`，直接替换官方管理界面，无额外进程、数据库或端口）。

> ⚠️ 合规提示：使用订阅账号接入 API 属于非官方逆向用法，可能违反上游服务条款并带来账号风控风险；请仅用于本人授权账号，自行评估风险。

## 2. 安装后第一次使用

1. 启动加载项（首次启动约需数十秒完成初始化）。
2. 打开 Web UI：`http://<你的HA地址>:8317/management.html`。
3. 使用**管理密钥**登录面板：
   - 未配置 `MANAGEMENT_KEY` 选项时，首次启动会生成随机密钥，可在**加载项日志**中看到一次，并始终保存于 `/config/cliproxyapi/management_key.txt`；
   - 也可以在启动前于加载项配置中预设 `MANAGEMENT_KEY`。
4. 在面板的 **Accounts / OAuth** 页面添加账号（OAuth 登录或导入凭据文件）。
5. 在 **Configuration / Access** 中把示例占位 API Key（`your-api-key-1`）替换为你的真实客户端密钥。

> 占位密钥会触发 CPA 的“示例密钥安全模式”，此时代理接口处于禁用状态，属正常保护行为。

## 3. 客户端接入

- OpenAI 兼容：`http://<你的HA>:8317/v1`
- Anthropic（Claude Code 直连）：`http://<你的HA>:8317`（Anthropic Base URL）
- Gemini 兼容：`http://<你的HA>:8317`（按上游文档选择对应协议路径）

请求需携带在面板中创建的 API Key。

## 4. OAuth 回调端口

OAuth 登录（如 Codex、Antigravity）在部分流程中需要浏览器回调到本加载项：

| 端口 | 用途 | 默认状态 |
|---|---|---|
| `1455/tcp` | Codex 登录回调 | 关闭 |
| `54545/tcp` | Antigravity 登录回调 | 关闭 |
| `8085` `51121` `11451` | 其他 OAuth 流程备用 | 关闭 |

- 默认全部关闭；登录时如面板提示回调失败，请在加载项「配置 → 网络」中为该端口指定一个**宿主机端口**后重启。
- 面板一般会给出“局域网回调辅助”（把 `localhost` 替换为 HA 主机名的链接），按提示操作即可。

## 5. 配置项

| 配置项 | 说明 |
|---|---|
| `MANAGEMENT_KEY` | 管理 API 与管理面板登录密钥。留空自动生成。**仅首次生成配置文件时写入**，之后请直接在面板或 `/config/cliproxyapi/config.yaml` 中修改 |
| `PROXY_URL` | 可选。出口代理（HTTP/SOCKS5），用于上游请求与管理面板/发布文件下载；仅在首次生成配置时写入 |

> 配置采用 **seed-once** 语义：首次启动后，`/config/cliproxyapi/config.yaml` 完全由你与面板接管，加载项重启不会覆盖它。

## 6. 管理面板及其更新机制

- 面板由 CPA 本体在 `:8317/management.html` 提供服务，面板来源仓库已预配置为 CPAMP：

  ```yaml
  management:
    panel-github-repository: "https://github.com/seakee/CPA-Manager-Plus"
  ```

- **更新逻辑**：CPA 每 3 小时检查该仓库最新 Release 的 `management.html` 资产并热更新；镜像内还内置了一份固定版本的**种子文件**，因此断网首启也有面板可用。
- 如需手动强制刷新：停止加载项 → 删除 `/data/cliproxyapi/static/management.html` → 重启（联网时会重新下载）。
- 如需换回官方面板：把 `panel-github-repository` 改为 `https://github.com/router-for-me/Cli-Proxy-API-Management-Center`。

## 7. 数据与备份

| 容器路径 | 内容 | 是否随 HA 备份 |
|---|---|---|
| `/config/cliproxyapi/config.yaml` | 主配置 | ✅ |
| `/config/cliproxyapi/auths/` | OAuth 凭据（refresh token 等） | ✅ |
| `/config/cliproxyapi/management_key.txt` | 管理密钥明文副本 | ✅ |
| `/data/cliproxyapi/logs` | 文件日志（默认关闭，输出到加载项日志） | ❌ |
| `/data/cliproxyapi/plugins` | 插件（默认未启用） | ❌ |
| `/data/cliproxyapi/static` | 管理面板缓存 | ❌ |

> `auths/` 与 `management_key.txt` 含敏感信息，请勿分享备份文件。

## 8. 故障排查

- **打不开面板 / 提示无权限** → 确认使用管理密钥登录；确认 `management.allow-remote: true` 未被改为 false。
- **面板显示“示例 API 密钥检测”警告** → 在面板中把 `your-api-key-1` 换成真实密钥。
- **新版本 Release 面板没有更新** → 见第 6 节手动刷新步骤；或检查加载项能否访问 GitHub（可在 `PROXY_URL` / `requests.proxy-url` 中配置代理）。
- **OAuth 登录回调失败** → 参见第 4 节启用对应回调端口。
- **日志** → 加载项日志页即实时输出；如需文件日志，可在面板中开启 `logging-to-file`。

## 9. 免责声明

本加载项仅为技术封装。CPA 与 CPAMP 均为第三方开源项目，其接口、风控与兼容性由上游维护；请遵守相关平台服务条款并自担使用风险。