### 1.2.2-build.3 (2026-11-09)

Dockerfile + rootfs 维护
- feat(migration,healthcheck): 引入一次性迁移延迟清理状态机与双轨精准探活机制
- refactor(storage): 适配 HA 新版 addon_config 存储隔离架构并重构 map 权限矩阵

---

### 1.2.2-build.2 (2026-11-09)

CI 工作流维护
- chore(changelog): 全面规范全插件更新日志格式并为 Release 流水线注入语法自愈沙盒 [skip-rebuild]

---

### 1.2.2-build.1 (2026-11-08)

CI 工作流维护
- 自动化构建流水线与容器发布底座例行维护

---

### 1.2.2 (2026-11-07)

#### Summary

MCPHub v1.2.2 makes credentials and application access easier to manage with credential copying, optional remembered OAuth consent, and application revocation. It also adds configurable forward-auth JWT headers and fixes dynamic OAuth registration credential persistence and stale embedding writes.

#### Features

- Copy personal credentials between compatible servers, with overwrite confirmation and independent copies. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1455
- Read forward-auth JWTs from a configurable header, including Cloudflare Access headers. by @FlavienKlr in https://github.com/samanhappy/mcphub/pull/1457
- Optionally remember OAuth consent and let users revoke authorized applications; confirmation on every authorization remains the default. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1461

#### Fixes

- Prevent stale embedding batches from writing after server cleanup or document embedding configuration changes. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1460
- Correctly persist dynamically registered OAuth client credentials and secret expiry from client metadata. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1463

#### 摘要

MCPHub v1.2.2 新增个人凭据复制、可选的 OAuth 授权记忆和应用授权撤销，让凭据与应用访问更易管理。同时支持自定义转发认证 JWT 请求头，并修复动态 OAuth 注册凭据持久化和过期嵌入批次写入问题。

#### 功能

- 支持在兼容服务器之间复制个人凭据，覆盖前需确认，复制后的凭据独立保存。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1455
- 支持从自定义请求头读取转发认证 JWT，适配 Cloudflare Access 等场景。by @FlavienKlr in https://github.com/samanhappy/mcphub/pull/1457
- 可选择记忆 OAuth 授权，并允许用户撤销已授权应用；默认仍在每次授权时要求确认。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1461

#### 修复

- 防止服务器清理或文档嵌入配置变更后，过期的嵌入批次再次写入数据。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1460
- 修复从客户端元数据持久化动态注册 OAuth 客户端凭据及密钥有效期的问题。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1463

#### New Contributors

- @FlavienKlr made their first contribution in #1457

#### References

- fix: persist dynamic OAuth registration credentials from client metadata by @samanhappy in https://github.com/samanhappy/mcphub/pull/1463
- feat(oauth): remember consent and support application revocation by @samanhappy in https://github.com/samanhappy/mcphub/pull/1461
- fix: prevent stale embedding writes after cleanup and config changes by @samanhappy in https://github.com/samanhappy/mcphub/pull/1460
- feat(auth): read the forward-auth JWT from a configurable header by @FlavienKlr in https://github.com/samanhappy/mcphub/pull/1457
- feat: copy personal credentials between compatible servers by @samanhappy in https://github.com/samanhappy/mcphub/pull/1455
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.2.1...v1.2.2

---

### 1.2.1 (2026-11-03)

#### Summary

MCPHub v1.2.1 improves upstream connection stability and OpenAPI parameter compatibility, adds narrowly scoped Fake-IP exceptions, and restores Authorization passthrough through an explicit administrator opt-in. It also refreshes package versions more promptly after reinstall or reload and updates dependencies.

#### Features

- Add admin-managed Fake-IP exceptions scoped to an upstream server and exact hostname for SSE and Streamable HTTP connections. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1446
- Document one-click deployment options in the Docker deployment guide. by @cosark in https://github.com/samanhappy/mcphub/pull/1454

#### Fixes

- Restore upstream Authorization passthrough through an explicit admin opt-in, disabled by default; requires a separate MCPHub authentication header and trusted upstream configuration, and remains unavailable in hosted mode. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1453
- Refresh package versions and update hints promptly after Reinstall or Reload. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1451
- Preserve upstream connections when changing tool, prompt or resource settings, avoiding duplicate stdio processes while servers are connecting. by @11113127 in https://github.com/samanhappy/mcphub/pull/1449
- Handle nullable and union tool schemas in OpenAPI and convert scalar array inputs correctly; affected generated operations now use POST with a JSON body. by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1447
- Update runtime and development dependencies, including OpenAI, Hugging Face tokenizers, uuid, tailwind-merge, i18next-browser-languagedetector and concurrently.

#### 摘要

MCPHub v1.2.1 改进上游连接稳定性和 OpenAPI 参数兼容性，新增精确限定范围的 Fake-IP 例外，并允许管理员显式启用 Authorization 透传。同时优化重新安装或重新加载后的包版本刷新，并更新依赖。

#### 功能

- 新增由管理员管理的 Fake-IP 例外，按上游服务器和精确主机名限定 SSE 与 Streamable HTTP 连接。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1446
- 在 Docker 部署指南中补充一键部署选项。 by @cosark in https://github.com/samanhappy/mcphub/pull/1454

#### 修复

- 通过管理员显式启用恢复上游 Authorization 透传，默认关闭；需配置独立的 MCPHub 认证请求头及可信上游，托管模式仍不支持。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1453
- 重新安装或重新加载后及时刷新包版本和更新提示。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1451
- 修改工具、提示词或资源配置时保留上游连接，避免服务器连接过程中重复创建 stdio 进程。 by @11113127 in https://github.com/samanhappy/mcphub/pull/1449
- 修复 OpenAPI 对可空类型及联合类型工具参数的处理，并正确转换数组参数的单值输入；受影响的生成操作改用 POST 和 JSON 请求体。 by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1447
- 更新运行时与开发依赖，包括 OpenAI、Hugging Face tokenizers、uuid、tailwind-merge、i18next-browser-languagedetector 和 concurrently。

#### New Contributors

- @cosark made their first contribution in #1454

#### References

- docs: present one-click deploy options in Docker deployment by @cosark in https://github.com/samanhappy/mcphub/pull/1454
- fix: restore Authorization passthrough with an admin opt-in by @samanhappy in https://github.com/samanhappy/mcphub/pull/1453
- fix: refresh package version promptly after reinstall and reload by @samanhappy in https://github.com/samanhappy/mcphub/pull/1451
- fix: preserve upstream connections on tool, prompt and resource config changes by @11113127 in https://github.com/samanhappy/mcphub/pull/1449
- fix(openapi): handle nullable and union tool parameters by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1447
- feat: scope Fake-IP exceptions to upstream server and hostname by @samanhappy in https://github.com/samanhappy/mcphub/pull/1446
- chore(deps-dev): bump i18next-browser-languagedetector from 8.2.1 to 8.2.3 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1444
- chore(deps-dev): bump tailwind-merge from 3.6.0 to 3.7.0 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1442
- chore(deps): bump openai from 6.45.0 to 7.45.1 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1441
- chore(deps): bump @huggingface/tokenizers from 0.1.3 to 0.2.0 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1440
- chore(deps): bump uuid from 14.0.0 to 14.0.3 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1439
- chore(deps-dev): bump concurrently from 9.2.0 to 10.0.6 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1438
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.2.0...v1.2.1

---

### 1.2.0-build.3 (2026-11-03)

CI 工作流维护
- 自动化构建流水线与容器发布底座例行维护

---

### 1.2.0-build.2 (2026-11-03)

CI 工作流维护
- 自动化构建流水线与容器发布底座例行维护

---

### 1.2.0-build.1 (2026-11-03)

CI 工作流维护
- 自动化构建流水线与容器发布底座例行维护

---

### 1.2.0 (2026-11-01)

#### Summary

v1.2.0 introduces **experimental cluster support** through an opt-in PostgreSQL multi-replica mode. Multiple MCPHub instances can share configuration and credentials behind a load balancer, with configuration convergence, cross-node OAuth coordination, readiness checks and graceful HTTP draining. Docker Compose and Kubernetes examples help you evaluate the new deployment model. This release also improves personal credential handling and restores generic OIDC login with Better Auth 1.7.

#### Features

- **Experimental cluster / multi-replica mode (disabled by default):** enable `MCPHUB_REPLICA_MODE=true` to run multiple instances against shared PostgreSQL. Configuration changes converge every five seconds, stale configuration writes are rejected, and OAuth state, authorization-code consumption and credential refresh are coordinated across nodes.
- **Deployment and operations:** Docker Compose and Kubernetes examples include separate schema setup, two replicas and load-balancer affinity. Liveness/readiness checks, node/configuration diagnostics, metrics and graceful HTTP draining help operate replicas. Use shared persistent JWT and credential-encryption keys, run schema setup separately, and set `DB_SYNCHRONIZE=false` on serving nodes. See the [replica deployment guide](https://docs.mcphub.app/configuration/replicas).
- **Experimental boundaries:** MCP sessions, isolated upstream clients, cookie jars and local files remain process-local. Stateful clients require sticky routing and reinitialization after node loss; in-flight calls are neither migrated nor replayed. PostgreSQL and load-balancer high availability remain deployment responsibilities. Evaluate in a test environment before adopting this mode in production.
- Add documentation for the community-maintained Home Assistant app.

#### Fixes

- Restore generic OIDC login with Better Auth 1.7.
- Persist upstream OAuth expiry and renew personal tokens before use.
- Show safe personal credential previews for administrators.

#### 摘要

v1.2.0 新增**实验性集群支持**，通过显式启用的 PostgreSQL 多副本模式，让多个 MCPHub 实例在负载均衡器后共享配置与凭据，并提供配置同步、跨节点 OAuth 协调、就绪检查和 HTTP 优雅排空。配套 Docker Compose 与 Kubernetes 示例便于评估这一新的部署方式。本版本还改进了个人凭据处理，并恢复了 Better Auth 1.7 下的通用 OIDC 登录。

#### 功能

- **实验性集群 / 多副本模式（默认关闭）：** 设置 `MCPHUB_REPLICA_MODE=true`，即可让多个实例共享 PostgreSQL。配置变更每五秒同步，拒绝基于过期配置的写入，并跨节点协调 OAuth 状态、授权码消费与凭据刷新。
- **部署与运维支持：** 提供 Docker Compose 和 Kubernetes 示例，包含独立建库、双副本与负载均衡会话亲和性配置；增加存活/就绪检查、节点与配置诊断、指标及 HTTP 优雅排空。各副本需共享持久化 JWT 密钥与凭据加密密钥，单独执行表结构准备，并在服务节点设置 `DB_SYNCHRONIZE=false`。详见[多副本部署指南](https://docs.mcphub.app/zh/configuration/replicas)。
- **实验性能力边界：** MCP 会话、隔离上游客户端、Cookie 状态与本地文件仍属于单个进程。有状态客户端需要粘性路由，节点丢失后需重新初始化；执行中的调用不会迁移或重放。PostgreSQL 与负载均衡器的高可用仍由部署方保障。建议先在测试环境评估，再决定是否用于生产。
- 新增社区维护的 Home Assistant 应用文档。

#### 修复

- 恢复 Better Auth 1.7 下的通用 OIDC 登录。
- 持久化上游 OAuth 过期时间，并在使用前续期个人令牌。
- 为管理员展示安全的个人凭据预览。

#### New Contributors

- @HyperCriSiS made their first contribution in #1433

#### References

- fix: restore generic OIDC login with Better Auth 1.7 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1437
- fix: persist upstream OAuth expiry and renew personal tokens before use by @samanhappy in https://github.com/samanhappy/mcphub/pull/1435
- fix: show safe personal credential previews for administrators by @samanhappy in https://github.com/samanhappy/mcphub/pull/1434
- docs: add community-maintained Home Assistant app by @HyperCriSiS in https://github.com/samanhappy/mcphub/pull/1433
- feat: add opt-in PostgreSQL replica mode by @samanhappy in https://github.com/samanhappy/mcphub/pull/1431
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.15...v1.2.0

---

### 1.1.15 (2026-10-31)

#### Summary

MCPHub v1.1.15 adds user-group sharing, more flexible system bearer-key scopes, masked personal credential previews, and opt-in OAuth authorization relay for private brokers. It also improves catalog notifications and preserves upstream connections during group changes. **Breaking change: Node.js 22 or newer is now required; Node.js 20 users must upgrade before installing this release.**

#### Features

- Share servers and Group routes with administrator-managed user groups while retaining underlying server permissions and tool policies. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1429
- Identify saved personal credentials through masked previews on your own Credentials page. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1428
- Enable personal OAuth authorization relay for explicitly configured private brokers, with allowed HTTPS redirect origins. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1422
- Configure system bearer keys to allow everything except selected groups and servers. by @3431481073 in https://github.com/samanhappy/mcphub/pull/1413

#### Fixes

- Preserve upstream connections when Group membership or configuration changes. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1427
- Deliver tool, prompt, and resource catalog changes to modern MCP subscriptions. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1416
- Correct same-day new-contributor detection in release-note drafts. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1412
- Require Node.js 22+ and test Node.js 22/24 in CI. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1430
- Update multer to 2.5.0, undici to 7.30.1, Vite to 6.4.5, better-auth to 1.7.7, and Zod to 4.6.6.

#### 摘要

MCPHub v1.1.15 新增用户组共享、更灵活的系统 Bearer Key 权限范围、个人凭据脱敏预览，以及可选的私有代理 OAuth 授权中继。同时改进目录变更通知，并在修改 Group 时保留上游连接。**不兼容变更：运行环境最低要求提升至 Node.js 22；Node.js 20 用户须先升级运行环境，再安装此版本。**

#### 功能

- 支持向管理员维护的用户组共享服务器和 Group 路由，继续遵循底层服务器权限与工具策略。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1429
- 在自己的 Credentials 页面通过脱敏预览识别已保存的个人凭据。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1428
- 支持为显式配置的私有代理启用个人 OAuth 授权中继，并限制允许的 HTTPS 重定向来源。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1422
- 支持为系统 Bearer Key 配置“允许全部，但排除指定 Group 和服务器”的权限范围。by @3431481073 in https://github.com/samanhappy/mcphub/pull/1413

#### 修复

- 修改 Group 成员或配置时保留上游连接。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1427
- 向现代 MCP 订阅发送工具、提示词和资源目录的变更通知。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1416
- 修正发布说明草稿中同一天首次贡献者的识别逻辑。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1412
- 最低运行环境提升至 Node.js 22，并在 CI 中测试 Node.js 22/24。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1430
- 将 multer 更新至 2.5.0、undici 更新至 7.30.1、Vite 更新至 6.4.5、better-auth 更新至 1.7.7、Zod 更新至 4.6.6。

#### New Contributors

- @3431481073 made their first contribution in #1413

#### References

- chore!: require Node.js 22 and test Node.js 22/24 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1430
- feat: share servers and routes with user groups by @samanhappy in https://github.com/samanhappy/mcphub/pull/1429
- feat: show masked previews of personal credentials by @samanhappy in https://github.com/samanhappy/mcphub/pull/1428
- fix: preserve upstream connections on group changes by @samanhappy in https://github.com/samanhappy/mcphub/pull/1427
- feat: relay personal OAuth authorization to private brokers by @samanhappy in https://github.com/samanhappy/mcphub/pull/1422
- chore(deps-dev): bump zod from 4.4.3 to 4.6.6 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1421
- chore(deps): bump better-auth from 1.6.22 to 1.7.7 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1420
- chore(deps-dev): bump vite from 6.4.4 to 6.4.5 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1419
- chore(deps): bump undici from 7.29.1 to 7.30.1 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1418
- chore(deps): bump multer from 2.4.0 to 2.5.0 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1417
- fix: publish catalog changes to modern MCP subscriptions by @samanhappy in https://github.com/samanhappy/mcphub/pull/1416
- feat(bearer-keys): add all-except exclude scope for system keys by @3431481073 in https://github.com/samanhappy/mcphub/pull/1413
- fix: detect same-day new contributors in release-notes draft by @samanhappy in https://github.com/samanhappy/mcphub/pull/1412
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.14...v1.1.15

---

### 1.1.14 (2026-10-29)

#### Summary

v1.1.14 makes MCPHub easier to govern and steadier in real-world deployments. Administrators can now enforce unified MCP tool access policies through a dedicated editor, provision and manage other users' personal credentials, and brand the dashboard with a custom name. On the reliability side, this release stops a UTF-8 BOM in `mcp_settings.json` from aborting startup on Windows, keeps bearer key group scopes intact when a group is renamed, eliminates repeated whole-catalog tokenization during status polling on the Servers page, and makes the dashboard language and Chinese community links resolve correctly.

#### Features

- Enforce unified MCP tool access policies, including a Settings → Tool access policies editor for administrators. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1399
- Let administrators provision, inspect, replace and delete other users' personal credentials from the Credentials page and the Users page. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1407
- Allow administrators to customize the dashboard name, applied immediately to the sidebar, header, login page and browser tab. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1411

#### Fixes

- Cache context definition token costs and refresh from content revisions, so the Servers page no longer re-tokenizes the whole catalog on every status poll. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1410
- Keep bearer key group scopes when a group is renamed, so existing keys stay valid and the old name does not inherit their access. by @jaeminbird in https://github.com/samanhappy/mcphub/pull/1406
- Use the resolved language for Chinese community links, so `zh-CN` and `zh-TW` get WeChat and the Chinese sponsorship QR code. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1405
- Let the browser locale win over the static `html lang` value, so fresh dashboard visits start in the user's language. by @myml in https://github.com/samanhappy/mcphub/pull/1404
- Keep key editor actions accessible while editing and align pagination and filter badge control sizes. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1401
- Strip a UTF-8 BOM when reading `mcp_settings.json`, so settings written by Windows PowerShell no longer abort startup. by @jaeminbird in https://github.com/samanhappy/mcphub/pull/1400

#### 摘要

v1.1.14 让 MCPHub 更易于治理，在真实部署中也更稳定。管理员现在可以通过专用编辑器统一实施 MCP 工具访问策略、为其他用户预置并管理个人凭据，还能自定义控制台名称。可靠性方面，本版本修复了 `mcp_settings.json` 带 UTF-8 BOM 时 Windows 启动失败、分组重命名后 Bearer 密钥丢失分组范围、Servers 页面每次状态轮询都重新对整个工具目录分词，以及控制台语言与中文社区链接解析不正确的问题。

#### 功能

- 统一实施 MCP 工具访问策略，并为管理员提供「设置 → 工具访问策略」编辑器。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1399
- 管理员可在凭据页面与用户页面为其他用户预置、查看状态、替换和删除个人凭据。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1407
- 管理员可自定义控制台名称，并立即应用到侧边栏、页头、登录页和浏览器标签页。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1411

#### 修复

- 缓存上下文定义的 token 开销并按内容修订号刷新，Servers 页面不再每次状态轮询都重新分词整个工具目录。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1410
- 分组重命名时保留 Bearer 密钥的分组范围，已有密钥继续有效，旧名称也不会继承其访问权限。 by @jaeminbird in https://github.com/samanhappy/mcphub/pull/1406
- 中文社区链接改用解析后的语言，`zh-CN` 与 `zh-TW` 正确显示微信与中文赞助二维码。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1405
- 浏览器语言优先于静态 `html lang` 值，首次访问控制台时即使用用户的语言。 by @myml in https://github.com/samanhappy/mcphub/pull/1404
- 编辑密钥时保持编辑器操作可用，并统一分页与筛选徽章控件的尺寸。 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1401
- 读取 `mcp_settings.json` 时去除 UTF-8 BOM，Windows PowerShell 写入的配置不再导致启动失败。 by @jaeminbird in https://github.com/samanhappy/mcphub/pull/1400

#### New Contributors

- @jaeminbird made their first contribution in #1400

#### References

- feat: allow customizing the dashboard name by @samanhappy in https://github.com/samanhappy/mcphub/pull/1411
- fix: cache context definition costs and avoid polling refetches by @samanhappy in https://github.com/samanhappy/mcphub/pull/1410
- feat: let admins manage users' personal credentials by @samanhappy in https://github.com/samanhappy/mcphub/pull/1407
- fix: keep bearer key group scopes when a group is renamed by @jaeminbird in https://github.com/samanhappy/mcphub/pull/1406
- fix: use resolved language for Chinese community links by @samanhappy in https://github.com/samanhappy/mcphub/pull/1405
- fix(i18n): let the browser locale win over the static html lang by @myml in https://github.com/samanhappy/mcphub/pull/1404
- fix: keep key editor actions accessible and align control sizes by @samanhappy in https://github.com/samanhappy/mcphub/pull/1401
- fix: strip UTF-8 BOM when reading mcp_settings.json by @jaeminbird in https://github.com/samanhappy/mcphub/pull/1400
- feat: enforce unified MCP tool access policies by @samanhappy in https://github.com/samanhappy/mcphub/pull/1399
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.13...v1.1.14

---

### 1.1.13 (2026-10-28)

#### Summary

This release adds Bearer key resets that preserve permissions and improves personal credential binding migration and embedding provider compatibility.

#### Features

- Reset Bearer keys while preserving permissions by @samanhappy in https://github.com/samanhappy/mcphub/pull/1396

#### Fixes

- Validate and independently migrate personal credential bindings by @samanhappy in https://github.com/samanhappy/mcphub/pull/1394
- Negotiate embedding encoding at runtime for better provider compatibility by @samanhappy in https://github.com/samanhappy/mcphub/pull/1398

#### 摘要

本版本支持在保留权限的同时重置 Bearer 密钥，并改进个人凭据绑定迁移及嵌入模型服务的兼容性。

#### 功能

- 支持在保留权限的同时重置 Bearer 密钥 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1396

#### 修复

- 校验并独立迁移个人凭据绑定 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1394
- 在运行时协商嵌入编码格式，提升服务提供商兼容性 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1398

#### References

- fix: negotiate embedding encoding at runtime by @samanhappy in https://github.com/samanhappy/mcphub/pull/1398
- feat: reset Bearer keys while preserving permissions by @samanhappy in https://github.com/samanhappy/mcphub/pull/1396
- fix: validate and independently migrate personal credential bindings by @samanhappy in https://github.com/samanhappy/mcphub/pull/1394
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.12...v1.1.13

---

### 1.1.12 (2026-10-27)

#### Summary

This release strengthens personal-credential and Bearer key storage. Existing client tokens remain valid.

> [!WARNING]
> **Before upgrading, back up your database/settings and preserve the original personal-credential encryption key.** A database backup alone cannot recover bindings if that key is lost. See the [upgrade and recovery guide](https://docs.mcphub.app/configuration/credential-key-upgrade).

> [!CAUTION]
> **Bearer key hashing is a one-way migration.** After migration, do not run an older version against the migrated database/settings. Rollback requires restoring a pre-upgrade backup.

#### Fixes

- **Personal credentials (#1393):** Database mode no longer generates a local encryption key automatically. Configure `MCPHUB_CREDENTIAL_ENCRYPTION_KEY` or retain an existing valid key file; keep the same key across upgrades and instances. A database backup alone cannot recover bindings if the key is lost. See the [upgrade and recovery guide](https://docs.mcphub.app/configuration/credential-key-upgrade) for working deployments and lost-key recovery.
- **Bearer keys (#1387):** Store SHA-256 hashes instead of plaintext, with automatic migration at startup. Existing client tokens keep working; newly created tokens are returned only once. **After migration, do not run an older version against the migrated database/settings—restore a pre-upgrade backup to roll back.** When switching from file to database mode, run this version in file mode first or remove leftover plaintext keys from the source settings file.

#### 摘要

本版本增强个人凭据和 Bearer Key 的存储安全性，客户端已有令牌继续有效。

> [!WARNING]
> **升级前请备份数据库／配置文件，并保留原个人凭据加密密钥。** 密钥丢失后，仅有数据库备份无法恢复绑定。操作步骤见[升级与恢复指南](https://docs.mcphub.app/configuration/credential-key-upgrade)。

> [!CAUTION]
> **Bearer Key 哈希迁移不可逆。** 迁移后不可直接使用旧版本读取已迁移的数据库／配置，回滚必须恢复升级前的备份。

#### 修复

- **个人凭据（#1393）：** 数据库模式不再自动生成本地加密密钥，需配置 `MCPHUB_CREDENTIAL_ENCRYPTION_KEY` 或保留已有的有效密钥文件；升级和多实例部署必须使用同一密钥。密钥丢失后，仅有数据库备份无法恢复绑定。正常部署的升级步骤及密钥丢失后的处理方案见[升级与恢复指南](https://docs.mcphub.app/configuration/credential-key-upgrade)。
- **Bearer Key（#1387）：** 改为保存 SHA-256 哈希，启动时自动迁移已有明文密钥。客户端已有令牌继续有效，新建令牌仅在创建时返回一次。**迁移后不可直接用旧版本读取已迁移的数据库／配置，回滚需恢复升级前备份。** 从文件模式切换到数据库模式时，应先以文件模式运行新版本一次，或清除源配置文件遗留的明文密钥。

#### References

- fix: require persistent credential keys in database mode by @samanhappy in https://github.com/samanhappy/mcphub/pull/1393
- Store bearer keys as a SHA-256 hash instead of plaintext by @sragot in https://github.com/samanhappy/mcphub/pull/1387
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.11...v1.1.12

---

### 1.1.10 (2026-10-24)

#### Summary

MCPHub v1.1.10 makes upstream connections easier to inspect by displaying negotiated MCP protocol versions separately from server software versions. It also improves server list readability, shows complete descriptions on expanded cards, and keeps the About dialog usable on smaller screens.

#### Features

- Display each upstream MCP server’s negotiated protocol version alongside its transport, separately from its software version. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1379

#### Fixes

- Improve server list row layout to prevent token statistics from overlapping controls and reduce server name truncation. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1378
- Show the full, wrapped server description on expanded cards. by @atacolak in https://github.com/samanhappy/mcphub/pull/1377
- Keep the About dialog within the viewport, with a scrollable body, an accessible close button, and Escape support. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1376

#### 摘要

MCPHub v1.1.10 将协商后的 MCP 协议版本与服务器软件版本分开展示，方便查看上游连接信息。同时优化服务器列表的可读性，在展开的卡片中显示完整描述，并改善小屏幕下“关于”对话框的使用体验。

#### 功能

- 在传输方式旁显示各上游 MCP 服务器协商后的协议版本，与软件版本分开展示。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1379

#### 修复

- 优化服务器列表行布局，避免 Token 统计与控件重叠，并减少服务器名称被截断的情况。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1378
- 在展开的服务器卡片中显示完整描述，支持自动换行。by @atacolak in https://github.com/samanhappy/mcphub/pull/1377
- 将“关于”对话框限制在视口内，支持内容滚动、可访问的关闭按钮及 Escape 关闭。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1376

#### New Contributors

- @atacolak made their first contribution in #1377

#### References

- feat: display negotiated MCP protocol versions by @samanhappy in https://github.com/samanhappy/mcphub/pull/1379
- fix(frontend): improve server list row layout by @samanhappy in https://github.com/samanhappy/mcphub/pull/1378
- fix(ui): show full server description on expanded cards by @atacolak in https://github.com/samanhappy/mcphub/pull/1377
- fix: keep about dialog within the viewport by @samanhappy in https://github.com/samanhappy/mcphub/pull/1376
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.9...v1.1.10

---

### 1.1.9 (2026-10-23)

#### Summary

MCPHub v1.1.9 makes large servers easier to manage with searchable bulk curation for tools, prompts, and resources plus a batch status API, and lets HTTP servers share one definition across regional or tenant endpoints through personal URL credential slots. It also forwards user-input elicitation for isolated legacy tool calls, adds the Vietnamese locale, stabilizes direct-route tool names across idle states, and unifies dark mode styling across dashboard forms and dialogs.

#### Features

- Add Vietnamese locale support by @hdkp81 in https://github.com/samanhappy/mcphub/pull/1363
- Support personal URL credential slots for HTTP servers by @samanhappy in https://github.com/samanhappy/mcphub/pull/1368
- Forward elicitation for isolated legacy tool calls by @samanhappy in https://github.com/samanhappy/mcphub/pull/1370
- Add bulk tool curation and batch status API by @samanhappy in https://github.com/samanhappy/mcphub/pull/1372

#### Fixes

- Stabilize direct-route tool names across idle states by @samanhappy in https://github.com/samanhappy/mcphub/pull/1374
- Unify dark mode styling across dashboard forms and dialogs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1375

#### 摘要

MCPHub v1.1.9 让大型服务器更易管理：支持对工具、提示词和资源进行可搜索的批量处理并新增批量状态 API，同时通过个人 URL 凭据槽位让 HTTP 服务器在区域或租户端点之间共用同一份定义。该版本还为隔离的旧版工具调用转发用户输入征求、新增越南语界面、稳定空闲状态下直连路由的工具名称，并统一仪表盘表单和对话框的深色模式样式。

#### 功能

- 新增越南语界面 by @hdkp81 in https://github.com/samanhappy/mcphub/pull/1363
- 为 HTTP 服务器新增个人 URL 凭据槽位 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1368
- 为隔离的旧版工具调用转发用户输入征求 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1370
- 新增批量工具管理和批量状态 API by @samanhappy in https://github.com/samanhappy/mcphub/pull/1372

#### 修复

- 稳定空闲状态下直连路由的工具名称 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1374
- 统一仪表盘表单和对话框的深色模式样式 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1375

#### New Contributors

- @hdkp81 made their first contribution in #1363

#### References

- fix: unify dark mode styling across dashboard forms and dialogs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1375
- fix: stabilize direct-route tool names across idle states by @samanhappy in https://github.com/samanhappy/mcphub/pull/1374
- feat: add bulk tool curation and batch status API by @samanhappy in https://github.com/samanhappy/mcphub/pull/1372
- feat: forward elicitation for isolated legacy tool calls by @samanhappy in https://github.com/samanhappy/mcphub/pull/1370
- feat: support personal URL credential slots for HTTP servers by @samanhappy in https://github.com/samanhappy/mcphub/pull/1368
- Feature/vi locale by @hdkp81 in https://github.com/samanhappy/mcphub/pull/1363
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.8...v1.1.9

---

### 1.1.8 (2026-10-21)

#### Summary

MCPHub v1.1.8 adds opt-in local account self-registration and per-tool input-schema parameter hiding. It also improves connection-status feedback, preserves personal OAuth bindings during unrelated server edits, displays server-reported versions, and updates MCP SDK, Hono, and Vite dependencies.

#### Features

- Add opt-in local account self-registration by @samanhappy in https://github.com/samanhappy/mcphub/pull/1354
- Hide input-schema parameters per tool by @SelfRef in https://github.com/samanhappy/mcphub/pull/1343
- Show server-reported versions when runner package versions are unavailable by @samanhappy in https://github.com/samanhappy/mcphub/pull/1367

#### Fixes

- Refresh server status faster during connection changes by @samanhappy in https://github.com/samanhappy/mcphub/pull/1355
- Preserve personal OAuth bindings during unrelated server edits by @samanhappy in https://github.com/samanhappy/mcphub/pull/1364
- Update MCP server SDK dependencies to 2.3.0 and server-legacy to 2.3.1, Hono to 4.13.11, and Vite to 6.4.4.

#### 摘要

MCPHub v1.1.8 新增可选开启的本地账号自助注册和按工具隐藏输入参数的功能，同时加快连接状态反馈，避免无关的服务器编辑影响个人 OAuth 绑定，展示服务端报告的版本，并更新 MCP SDK、Hono 和 Vite 依赖。

#### 功能

- 新增可选开启的本地账号自助注册 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1354
- 支持按工具隐藏输入 schema 中的参数 by @SelfRef in https://github.com/samanhappy/mcphub/pull/1343
- 无 runner 包版本时展示服务端报告的版本 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1367

#### 修复

- 加快连接变化期间的服务器状态刷新 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1355
- 在无关的服务器编辑中保留个人 OAuth 绑定 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1364
- 将 MCP server SDK 更新至 2.3.0、server-legacy 更新至 2.3.1、Hono 更新至 4.13.11、Vite 更新至 6.4.4。

#### References

- fix: show server-reported version on server cards by @samanhappy in https://github.com/samanhappy/mcphub/pull/1367
- fix: keep personal OAuth bindings on unrelated server edits by @samanhappy in https://github.com/samanhappy/mcphub/pull/1364
- chore(deps): bump hono from 4.13.7 to 4.13.11 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1361
- chore(deps-dev): bump vite from 6.4.3 to 6.4.4 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1360
- chore(deps): bump @modelcontextprotocol/server from 2.1.0 to 2.3.0 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1359
- chore(deps): bump @modelcontextprotocol/server-legacy from 2.1.0 to 2.3.1 by @app/dependabot in https://github.com/samanhappy/mcphub/pull/1358
- fix: refresh server status faster during connection changes by @samanhappy in https://github.com/samanhappy/mcphub/pull/1355
- feat: add opt-in local account self-registration by @samanhappy in https://github.com/samanhappy/mcphub/pull/1354
- feat: hide input-schema parameters per tool by @SelfRef in https://github.com/samanhappy/mcphub/pull/1343
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.7...v1.1.8

---

### 1.1.7 (2026-10-19)

#### Summary

MCPHub v1.1.7 adds group-level instructions for MCP clients, optional Prometheus metrics, managed pruning for declarative settings, and an opt-in guard for high-risk tool-call arguments. It also improves OAuth registration and diagnostics, embedding token truncation, form parameter conversion, and tool-call troubleshooting.

#### Features

- Configure group instructions returned during MCP initialization, including smart group routes and multi-server groups.
- Enable Prometheus metrics with `ENABLE_METRICS=true`; optionally protect `/metrics` with a dedicated `METRICS_TOKEN` bearer credential.
- Use `MCPHUB_SETTINGS_SYNC=prune` to permanently remove deleted settings-managed servers and groups at startup while preserving unmanaged dashboard entries.
- Enable `TOOL_CALL_GUARD_ENABLED=true` to reject tool calls whose arguments match high-confidence malicious patterns before forwarding them upstream. This guard is disabled by default and provides pattern-based checks, not comprehensive protection.

#### Fixes

- Honor explicit OAuth redirect URIs during client registration, avoiding unintended fallback callbacks.
- Preserve useful OAuth failure diagnostics while continuing to sanitize credentials.
- Use `cl100k_base` when truncating text for supported OpenAI embedding models.
- Convert integer, number, and boolean array form parameters according to their item schemas.
- Include group, authenticated caller, and target tool context in tool-call error logs.
- Preserve hyphenated filenames and improve context-line parsing when compressing search results.

#### 摘要

MCPHub v1.1.7 新增供 MCP 客户端使用的分组指令、可选的 Prometheus 指标、声明式配置的托管条目清理，以及可主动启用的高风险工具调用参数防护。同时改进了 OAuth 注册与诊断、嵌入文本的令牌截断、表单参数转换和工具调用故障排查。

#### 功能

- 支持配置在 MCP 初始化时返回的分组指令，覆盖智能分组路由和多服务器分组。
- 通过 `ENABLE_METRICS=true` 启用 Prometheus 指标；可使用独立的 `METRICS_TOKEN` Bearer 凭据保护 `/metrics`。
- 通过 `MCPHUB_SETTINGS_SYNC=prune`，在启动时永久删除已从配置中移除的托管服务器和分组，同时保留非托管的控制台条目。
- 通过 `TOOL_CALL_GUARD_ENABLED=true`，在转发到上游前拒绝参数命中高置信恶意模式的工具调用。该防护默认关闭，提供基于模式的检查，不代表全面防护。

#### 修复

- OAuth 客户端注册遵循显式配置的重定向 URI，避免混入非预期的回退回调地址。
- 保留有助于排查 OAuth 失败的诊断信息，同时继续对凭据进行脱敏。
- 为受支持的 OpenAI 嵌入模型使用 `cl100k_base` 进行文本令牌截断。
- 根据元素类型定义转换表单中的整数、数字和布尔值数组参数。
- 在工具调用错误日志中补充分组、已认证调用者和目标工具上下文。
- 压缩搜索结果时保留含连字符的完整文件名，并改进上下文行解析。

#### New Contributors

- @Lay-quq made their first contribution in #1347
- @DSHCorrectover made their first contribution in #1299

#### References

- fix: honor explicit OAuth redirect URIs during registration by @samanhappy in https://github.com/samanhappy/mcphub/pull/1352
- fix: preserve sanitized OAuth failure diagnostics by @samanhappy in https://github.com/samanhappy/mcphub/pull/1351
- fix: use cl100k_base for OpenAI embedding truncation by @Lay-quq in https://github.com/samanhappy/mcphub/pull/1350
- fix: convert primitive array form parameters by item schema by @Lay-quq in https://github.com/samanhappy/mcphub/pull/1347
- feat: add managed pruning to declarative settings sync by @samanhappy in https://github.com/samanhappy/mcphub/pull/1346
- feat: expose optional Prometheus metrics endpoint by @samanhappy in https://github.com/samanhappy/mcphub/pull/1345
- feat: group-level instructions sent on initialize by @SelfRef in https://github.com/samanhappy/mcphub/pull/1340
- fix: include request context in tool call error logs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1339
- fix(compression): keep a hyphenated file name whole when compressing search results by @pacocartones in https://github.com/samanhappy/mcphub/pull/1326
- feat: add opt-in pre-call guard for high-risk tool call arguments by @DSHCorrectover in https://github.com/samanhappy/mcphub/pull/1299
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.6...v1.1.7

---

### 1.1.6 (2026-10-18)

#### Summary

This release adds configurable Smart Routing paths while preserving existing `$smart` URLs. It also aligns Marketplace installation options with user permissions, fixes credential-slot saves when only the default shared OAuth identity is present, and improves Bearer authentication compatibility and update-check cache configuration handling.

#### Features

- Configure Smart Routing endpoints with `SMART_ROUTING_PATH`; existing `$smart` URLs remain supported.

#### Fixes

- Disable local command installations for non-admin users in Marketplace and Registry, with an explanation, while keeping supported remote installations available.
- Allow credential slots when OAuth contains only the default shared identity setting, and preserve credential bindings when renaming affected legacy servers.
- Accept the Bearer authentication scheme case-insensitively.
- Treat an empty update-check cache TTL as unset.

#### 摘要

本版本支持自定义智能路由路径，并继续兼容现有 `$smart` URL。同时，让市场安装选项与用户权限保持一致，修复仅存在默认共享 OAuth 身份设置时凭据槽无法保存的问题，并改进 Bearer 认证兼容性和更新检查缓存配置处理。

#### 功能

- 通过 `SMART_ROUTING_PATH` 自定义智能路由端点，继续支持现有 `$smart` URL。

#### 修复

- 在市场和注册表中为非管理员禁用本地命令安装并显示原因，保留受支持的远程安装。
- OAuth 仅包含默认共享身份设置时允许使用凭据槽，并在重命名受影响的旧服务器配置时保留凭据绑定。
- Bearer 认证方案名称支持大小写不敏感匹配。
- 将空的更新检查缓存 TTL 视为未设置。

#### References

- fix(changelog): treat an empty update-check cache TTL as unset by @pacocartones in https://github.com/samanhappy/mcphub/pull/1338
- fix(auth): accept the Bearer scheme case-insensitively by @pacocartones in https://github.com/samanhappy/mcphub/pull/1337
- fix: allow credential slots with default shared OAuth identity by @samanhappy in https://github.com/samanhappy/mcphub/pull/1335
- feat: support configurable smart routing paths by @samanhappy in https://github.com/samanhappy/mcphub/pull/1331
- fix: align marketplace installs with server permissions by @samanhappy in https://github.com/samanhappy/mcphub/pull/1330
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.5...v1.1.6

---

### 1.1.5 (2026-10-16)

#### Summary

MCPHub v1.1.5 adds Spanish localization and improves API validation and tool-list synchronization. Server-list requests with non-numeric pagination parameters now return HTTP 400, and clients are notified when a server is removed from a group so they can refresh the available tools.

#### Features

- Add Spanish (es) localization to the interface, with Español available in the language menu. by @arioko in https://github.com/samanhappy/mcphub/pull/1328

#### Fixes

- Return HTTP 400 for non-numeric page or limit parameters in server-list requests. by @pacocartones in https://github.com/samanhappy/mcphub/pull/1325
- Notify tool listeners when a server is removed from a group, allowing connected clients to refresh their tool lists. by @pacocartones in https://github.com/samanhappy/mcphub/pull/1324

#### 摘要

MCPHub v1.1.5 新增西班牙语界面，并改进 API 参数校验与工具列表同步。服务器列表请求中的分页参数为非数字时，现在会返回 HTTP 400；从分组移除服务器后，也会通知已连接的客户端刷新可用工具。

#### 功能

- 新增西班牙语（es）界面，可在语言菜单中选择 Español。 by @arioko in https://github.com/samanhappy/mcphub/pull/1328

#### 修复

- 当服务器列表请求的 page 或 limit 参数为非数字时，返回 HTTP 400。 by @pacocartones in https://github.com/samanhappy/mcphub/pull/1325
- 从分组移除服务器后通知工具监听器，使已连接的客户端能够刷新工具列表。 by @pacocartones in https://github.com/samanhappy/mcphub/pull/1324

#### New Contributors

- @pacocartones made their first contribution in #1325
- @arioko made their first contribution in #1328

#### References

- feat: add Spanish (es) localization by @arioko in https://github.com/samanhappy/mcphub/pull/1328
- fix(servers): answer 400 for a non-numeric page or limit on the server list by @pacocartones in https://github.com/samanhappy/mcphub/pull/1325
- fix(groups): notify tool listeners when a server is removed from a group by @pacocartones in https://github.com/samanhappy/mcphub/pull/1324
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.4...v1.1.5

---

### 1.1.4 (2026-10-15)

#### Summary

v1.1.4 expands personal upstream authentication with independent OAuth connections and credential slots in stdio arguments. It also improves OAuth discovery, aggregate tool routing, and Windows compatibility.

#### Features

- Support personal upstream OAuth bindings, with per-user authorization and dashboard connection controls. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1318
- Support personal credential slots in stdio arguments using explicit `{{args.API_KEY}}` placeholders. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1313

#### Fixes

- Publish path-aware OAuth protected-resource metadata and matching authentication challenges. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1322
- Preserve aggregate tool naming and routing for OpenAPI and personal upstreams in Apps-capable clients. by @zhiwei-dong in https://github.com/samanhappy/mcphub/pull/1320
- Fix MCPB uploads on Windows by keeping the rename destination absent. by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1314
- Fix Windows path matching in the Jest transform for `jose`. by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1315

#### 摘要

v1.1.4 扩展了上游服务的个人身份认证能力，支持独立的 OAuth 连接和 stdio 参数中的个人凭据槽位，同时改进 OAuth 服务发现、聚合工具路由和 Windows 兼容性。

#### 功能

- 支持个人上游 OAuth 绑定，提供逐用户独立授权和仪表盘连接管理。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1318
- 支持通过显式 `{{args.API_KEY}}` 占位符在 stdio 参数中使用个人凭据槽位。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1313

#### 修复

- 发布与端点路径对应的 OAuth 受保护资源元数据及匹配的认证质询。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1322
- 修复支持 Apps 的客户端中 OpenAPI 和个人上游的聚合工具命名与路由。by @zhiwei-dong in https://github.com/samanhappy/mcphub/pull/1320
- 确保重命名目标目录不存在，修复 Windows 上的 MCPB 上传失败。by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1314
- 修复 Jest 对 `jose` 的转换规则在 Windows 上的路径匹配。by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1315

#### New Contributors

- @zhiwei-dong made their first contribution in #1320
- @remote-controlled-man made their first contribution in #1315

#### References

- fix: publish path-aware OAuth protected resource metadata by @samanhappy in https://github.com/samanhappy/mcphub/pull/1322
- fix(apps): preserve aggregate routing for OpenAPI and personal upstreams by @zhiwei-dong in https://github.com/samanhappy/mcphub/pull/1320
- feat: support personal upstream OAuth bindings by @samanhappy in https://github.com/samanhappy/mcphub/pull/1318
- fix(test): match jose transform paths on Windows by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1315
- fix(mcpb): keep upload rename destination absent on Windows by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1314
- feat: support personal credential slots in stdio args by @samanhappy in https://github.com/samanhappy/mcphub/pull/1313
- docs: add GitHub Sponsors button to READMEs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1308
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.3...v1.1.4

---

### 1.1.3 (2026-10-11)

#### Summary

MCPHub v1.1.3 adds administrator-managed CIDR allowances for upstream access and improves compatibility for CLI tool calls, MCP Apps widgets on idle on-demand servers, and stateful tools in ChatGPT Work/Codex.

#### Features

- Allow administrators to configure IPv4/IPv6 CIDR ranges for upstream access through Settings or `systemConfig.network.allowedCidrs`. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1300

#### Fixes

- Initialize MCP sessions for CLI tool calls, fixing HTTP 400 errors caused by missing session IDs. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1304
- Wake idle on-demand servers when reading their `ui://` widgets, preventing premature “Resource not found” errors. by @jcollas in https://github.com/samanhappy/mcphub/pull/1303
- Support authenticated, scoped session-state correlation through OpenAI session metadata when the explicit state header is absent, restoring stateful tool compatibility in ChatGPT Work/Codex. by @khanhkit in https://github.com/samanhappy/mcphub/pull/1307

#### 摘要

MCPHub v1.1.3 新增由管理员配置的上游访问 CIDR 白名单，并改善 CLI 工具调用、空闲按需启动服务器的 MCP Apps 小组件，以及 ChatGPT Work/Codex 中有状态工具的兼容性。

#### 功能

- 支持管理员通过设置页面或 `systemConfig.network.allowedCidrs` 配置允许上游访问的 IPv4/IPv6 CIDR 网段。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1300

#### 修复

- CLI 工具调用前初始化 MCP 会话，修复因缺少会话 ID 导致的 HTTP 400 错误。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1304
- 读取 `ui://` 小组件时唤醒空闲的按需启动服务器，避免提前返回“Resource not found”错误。by @jcollas in https://github.com/samanhappy/mcphub/pull/1303
- 未提供显式状态请求头时，支持通过 OpenAI 会话元数据在已认证的作用域内关联会话状态，恢复 ChatGPT Work/Codex 中有状态工具的兼容性。by @khanhkit in https://github.com/samanhappy/mcphub/pull/1307

#### New Contributors

- @khanhkit made their first contribution in #1307

#### References

- fix: support OpenAI session state fallback by @khanhkit in https://github.com/samanhappy/mcphub/pull/1307
- docs: add AtomGit hosting link to READMEs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1305
- fix: initialize MCP sessions for CLI tool calls by @samanhappy in https://github.com/samanhappy/mcphub/pull/1304
- fix(apps): wake an idle on-demand server to serve its ui:// widget by @jcollas in https://github.com/samanhappy/mcphub/pull/1303
- feat: allow admin-managed upstream CIDR ranges by @samanhappy in https://github.com/samanhappy/mcphub/pull/1300
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.2...v1.1.3

---

### 1.1.2-build.1 (2026-10-10)

CI 变更
- feat(addons): 为 6 个 addon 补充图标

---

### 1.1.2 (2026-10-10)

#### Summary

MCPHub v1.1.2 adds JWKS-based forward authentication and enables MCP Apps widgets for pinned tools on smart-routing group endpoints. It also improves upstream compatibility and server lifecycle reliability by correcting overly broad IP blocking, adding an administrator-controlled exception for HTTP OAuth token endpoints, preserving personal credentials during plain server renames, and preventing duplicate queued on-demand discovery.

#### Features

- Add JWKS-based forward authentication for dashboard APIs and MCP transports. by @yash025 in https://github.com/samanhappy/mcphub/pull/1295
- Preserve MCP Apps metadata on pinned tools at `$smart/{group}`, enabling widgets for compatible clients. by @jcollas in https://github.com/samanhappy/mcphub/pull/1296

#### Fixes

- Cancel queued on-demand discovery when tools are already cached or the runtime is no longer eligible, avoiding duplicate server processes. by @xujiantop-crypto in https://github.com/samanhappy/mcphub/pull/1297
- Correct the CGNAT blocklist range so public 100.x and 101.x addresses are no longer incorrectly blocked. by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1294
- Allow administrators to explicitly enable HTTP OAuth token endpoints per upstream, with the exception disabled by default. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1293
- Preserve personal credential bindings when renaming a server without changing its connection configuration. by @SelfRef in https://github.com/samanhappy/mcphub/pull/1291

#### 摘要

MCPHub v1.1.2 新增基于 JWKS 的转发认证，并支持在智能路由分组端点上为固定工具展示 MCP Apps 小组件。本版本还提升了上游兼容性和服务器生命周期的稳定性：修正范围过大的 IP 拦截，为 HTTP OAuth 令牌端点提供由管理员控制的例外设置，在仅重命名服务器时保留个人凭据，并避免排队的按需发现任务重复启动进程。

#### 功能

- 为仪表盘 API 和 MCP 传输新增基于 JWKS 的转发认证。by @yash025 in https://github.com/samanhappy/mcphub/pull/1295
- 保留 `$smart/{group}` 固定工具的 MCP Apps 元数据，让兼容客户端能够展示小组件。by @jcollas in https://github.com/samanhappy/mcphub/pull/1296

#### 修复

- 当工具已缓存或运行实例不再满足执行条件时，取消排队的按需发现任务，避免重复启动服务器进程。by @xujiantop-crypto in https://github.com/samanhappy/mcphub/pull/1297
- 修正 CGNAT 拦截范围，避免错误拦截公网 100.x 和 101.x 地址。by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1294
- 允许管理员为单个上游显式启用 HTTP OAuth 令牌端点，该例外默认关闭。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1293
- 在仅重命名服务器且未更改连接配置时，保留用户的个人凭据绑定。by @SelfRef in https://github.com/samanhappy/mcphub/pull/1291

#### New Contributors

- @xujiantop-crypto made their first contribution in #1297
- @yash025 made their first contribution in #1295
- @OsamaAnsar made their first contribution in #1294

#### References

- fix: cancel already primed queued on-demand discovery by @xujiantop-crypto in https://github.com/samanhappy/mcphub/pull/1297
- feat(smart-routing): keep MCP Apps metadata on pinned tools of $smart/{group} by @jcollas in https://github.com/samanhappy/mcphub/pull/1296
- feat(auth): add JWKS forward auth by @yash025 in https://github.com/samanhappy/mcphub/pull/1295
- fix(ssrf): correct the CGNAT range so public 100.x addresses are not blocked by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1294
- fix(oauth): allow admin-controlled HTTP token endpoints per upstream by @samanhappy in https://github.com/samanhappy/mcphub/pull/1293
- fix(servers): keep personal credential bindings across a plain server rename by @SelfRef in https://github.com/samanhappy/mcphub/pull/1291
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.1...v1.1.2

<!-- auto-generated by CI -->
