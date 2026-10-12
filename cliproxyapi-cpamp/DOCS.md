# CLIProxyAPI + CPAMP for HA（完整版）

多账号 AI CLI 网关 + **CPAMP 完整管理面板**（请求监控 / 用量统计 / 成本分析 / 配额巡检）。本文档覆盖双面板入口、首次使用、数据与备份、故障排查。

- 上游网关：[router-for-me/CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)
- 管理面板：[seakee/CPA-Manager-Plus](https://github.com/seakee/CPA-Manager-Plus)
- 上游文档：[help.router-for.me](https://help.router-for.me/) · [seakee.github.io/CPA-Manager-Plus](https://seakee.github.io/CPA-Manager-Plus/)

---

## 1. 架构说明

本加载项在一个容器内运行两个服务（均由 S6 守护）：

```
浏览器 ──▶ :8317  CLIProxyAPI（网关 + 轻量面板 /management.html）
                │
                └─ loopback:8317 ──▶ :18317 CPAMP Manager Server（完整面板 + SQLite）
```

| 面板 | 入口 | 登录密钥 | 能力 |
|---|---|---|---|
| 轻量面板 | `http://<HA>:8317/management.html` | `MANAGEMENT_KEY` | 配置 / 账号 / OAuth / 日志 |
| 完整面板 | `http://<HA>:18317/management.html` | `CPAMP_ADMIN_KEY` | 上述全部 + **请求监控 / 用量与成本 / 配额巡检 / 自动化** |

> ⚠️ 合规提示：使用订阅账号接入 API 属于非官方逆向用法，可能违反上游服务条款并带来账号风控风险；请仅用于本人授权账号，自行评估风险。

## 2. 安装后第一次使用

1. 启动加载项（首次启动约需数十秒完成初始化）。
2. 打开**完整面板** `:18317/management.html`，使用 CPAMP 管理员密钥登录：
   - 未配置 `CPAMP_ADMIN_KEY` 选项时，首次启动自动生成，在加载项日志中打印一次，并自动**回填到加载项选项**；
   - 同时保存于 `/config/cliproxyapi-cpamp/cpamp_admin_key.txt`。
   - **CPA 连接（URL 与 CPA 管理密钥）已预配置**，无需在首次设置中手工填写。
3. 打开**轻量面板** `:8317/management.html`，使用**管理密钥**登录：
   - 未配置 `MANAGEMENT_KEY` 选项时，首启自动生成（日志打印一次、回填到选项），或见 `/config/cliproxyapi-cpamp/management_key.txt`。
4. 在任一面板的 Accounts / OAuth 页面添加账号；在 Configuration / Access 中把占位 API Key（`your-api-key-1`）替换为真实客户端密钥。
5. 产生一次模型请求后，完整面板的监控/用量页即开始有数据。

> 占位密钥会触发 CPA 的“示例密钥安全模式”，此时代理接口处于禁用状态，属正常保护行为。

## 3. 客户端接入

- OpenAI 兼容：`http://<你的HA>:8317/v1`
- Anthropic（Claude Code 直连）：`http://<你的HA>:8317`
- 请求需携带在面板中创建的 API Key。

## 4. OAuth 回调端口

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
| `MANAGEMENT_KEY` | 管理 API 与轻量面板登录密钥。留空则首启自动生成（打印在日志、回填到本选项、保存于 `management_key.txt`）。**修改本选项并重启即生效**（回写 `management.secret-key`）；留空表示交由管理面板管理 |
| `CPAMP_ADMIN_KEY` | CPAMP 完整面板登录密钥。留空则首启自动生成（打印在日志、回填到本选项、保存于 `cpamp_admin_key.txt`）。**修改本选项并重启即生效**（每次启动按"选项 > 文件"取值） |
| `PROXY_URL` | 可选。出口代理（HTTP/SOCKS5）。**修改后重启即回写** `requests.proxy-url`；清空则交由面板管理（不会移除已写入的代理） |

> **选项与配置的同步语义**（seed-once + 选项回写）：
> - 首次启动生成配置文件时写入选项值（或生成的随机密钥）；
> - 之后**选项值发生变更**（与上次不同且非空）时，启动过程会把新值回写进 `config.yaml`；
> - 选项为空 = 不管理该字段，面板中的修改不会被覆盖；
> - 在面板中改掉的值不会被**未变更**的选项覆盖（仅选项"变更"才回写）；
> - 回写 `MANAGEMENT_KEY` 后，CPA 启动时会自动把明文哈希化，属正常行为。

## 6. 监控与用量（完整版独有）

- 依赖 CPA 的用量发布：配置中已开启 `observability.usage.usage-statistics-enabled: true`（勿在面板中关闭，否则监控无数据）。
- 请求历史 / 用量 / 成本数据保存在 `/config/cliproxyapi-cpamp/cpamp/usage.sqlite`。
- **单消费者原则**：CPAMP 已占用 CPA 用量队列。请勿再给同一 CPA 接第二个采集器（CPA Usage Keeper / Oh-My-CPA / 另一套 CPAMP），否则采集会中断或不完整。
- 若升级后完整面板提示 `databaseMaintenance.required`（历史查询变慢）：停止加载项后用 CPAMP 的离线维护命令处理（`cleanup-derived`，详见上游文档），再启动。

## 7. 数据与备份

| 容器路径 | 内容 | 是否随 HA 备份 |
|---|---|---|
| `/config/cliproxyapi-cpamp/config.yaml` | 主配置 | ✅ |
| `/config/cliproxyapi-cpamp/auths/` | OAuth 凭据（refresh token 等） | ✅ |
| `/config/cliproxyapi-cpamp/management_key.txt` | CPA 管理密钥明文副本 | ✅ |
| `/config/cliproxyapi-cpamp/cpamp_admin_key.txt` | CPAMP 管理员密钥副本 | ✅ |
| `/config/cliproxyapi-cpamp/options_applied.json` | 选项同步状态（判断选项是否变更） | ✅ |
| `/config/cliproxyapi-cpamp/cpamp/usage.sqlite` | 请求历史与用量 | ✅ |
| `/config/cliproxyapi-cpamp/cpamp/data.key` | 数据加密密钥（解密库内 CPA 密钥） | ✅ |
| `/data/cliproxyapi-cpamp/{logs,plugins,static}` | 日志 / 插件 / 面板缓存 | ❌ |

> `usage.sqlite` 与 `data.key` 必须**成对**备份：仅恢复数据库而无 `data.key` 时，库内保存的 CPAMP 配置无法解密（需重新设置 CPA 连接）。
> 高频使用下 `usage.sqlite` 会持续增长并计入 HA 快照，请留意快照体积。

## 8. 故障排查

- **打不开任一面板** → 检查端口映射（8317 / 18317）；确认加载项日志无启动错误。
- **完整面板提示未连接 CPA** → 点击设置核对 CPA URL 为 `http://127.0.0.1:8317` 且密钥正确；若你更换过 CPA 管理密钥，请同步更新：编辑 `/config/cliproxyapi-cpamp/management_key.txt` 后重启，或在面板中重新保存连接。
- **监控页为空** → 确认 CPA 已产生过请求；确认 `usage-statistics-enabled: true` 未被关闭；确认没有第二个采集器抢队列。
- **轻量面板显示“示例 API 密钥检测”警告** → 在面板中把 `your-api-key-1` 换成真实密钥。
- **面板没有更新到新版** → 停止加载项 → 删除 `/data/cliproxyapi-cpamp/static/management.html` → 重启（联网时自动下载最新面板）。
- **日志** → 加载项日志页实时输出（CPA 与 CPAMP 均在 stdout）。

## 9. 免责声明

本加载项仅为技术封装。CPA 与 CPAMP 均为第三方开源项目，其接口、风控与兼容性由上游维护；请遵守相关平台服务条款并自担使用风险。