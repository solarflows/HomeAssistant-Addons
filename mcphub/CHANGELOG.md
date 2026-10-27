### 1.1.12 (2026-10-27)
## Summary

This release strengthens personal-credential and Bearer key storage. Existing client tokens remain valid.

> [!WARNING]
> **Before upgrading, back up your database/settings and preserve the original personal-credential encryption key.** A database backup alone cannot recover bindings if that key is lost. See the [upgrade and recovery guide](https://docs.mcphub.app/configuration/credential-key-upgrade).

> [!CAUTION]
> **Bearer key hashing is a one-way migration.** After migration, do not run an older version against the migrated database/settings. Rollback requires restoring a pre-upgrade backup.

## Fixes

- **Personal credentials (#1393):** Database mode no longer generates a local encryption key automatically. Configure `MCPHUB_CREDENTIAL_ENCRYPTION_KEY` or retain an existing valid key file; keep the same key across upgrades and instances. A database backup alone cannot recover bindings if the key is lost. See the [upgrade and recovery guide](https://docs.mcphub.app/configuration/credential-key-upgrade) for working deployments and lost-key recovery.
- **Bearer keys (#1387):** Store SHA-256 hashes instead of plaintext, with automatic migration at startup. Existing client tokens keep working; newly created tokens are returned only once. **After migration, do not run an older version against the migrated database/settings—restore a pre-upgrade backup to roll back.** When switching from file to database mode, run this version in file mode first or remove leftover plaintext keys from the source settings file.

## 摘要

本版本增强个人凭据和 Bearer Key 的存储安全性，客户端已有令牌继续有效。

> [!WARNING]
> **升级前请备份数据库／配置文件，并保留原个人凭据加密密钥。** 密钥丢失后，仅有数据库备份无法恢复绑定。操作步骤见[升级与恢复指南](https://docs.mcphub.app/configuration/credential-key-upgrade)。

> [!CAUTION]
> **Bearer Key 哈希迁移不可逆。** 迁移后不可直接使用旧版本读取已迁移的数据库／配置，回滚必须恢复升级前的备份。

## 修复

- **个人凭据（#1393）：** 数据库模式不再自动生成本地加密密钥，需配置 `MCPHUB_CREDENTIAL_ENCRYPTION_KEY` 或保留已有的有效密钥文件；升级和多实例部署必须使用同一密钥。密钥丢失后，仅有数据库备份无法恢复绑定。正常部署的升级步骤及密钥丢失后的处理方案见[升级与恢复指南](https://docs.mcphub.app/configuration/credential-key-upgrade)。
- **Bearer Key（#1387）：** 改为保存 SHA-256 哈希，启动时自动迁移已有明文密钥。客户端已有令牌继续有效，新建令牌仅在创建时返回一次。**迁移后不可直接用旧版本读取已迁移的数据库／配置，回滚需恢复升级前备份。** 从文件模式切换到数据库模式时，应先以文件模式运行新版本一次，或清除源配置文件遗留的明文密钥。

## References

- fix: require persistent credential keys in database mode by @samanhappy in https://github.com/samanhappy/mcphub/pull/1393
- Store bearer keys as a SHA-256 hash instead of plaintext by @sragot in https://github.com/samanhappy/mcphub/pull/1387
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.11...v1.1.12

### 1.1.10 (2026-10-24)
## Summary

MCPHub v1.1.10 makes upstream connections easier to inspect by displaying negotiated MCP protocol versions separately from server software versions. It also improves server list readability, shows complete descriptions on expanded cards, and keeps the About dialog usable on smaller screens.

## Features

- Display each upstream MCP server’s negotiated protocol version alongside its transport, separately from its software version. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1379

## Fixes

- Improve server list row layout to prevent token statistics from overlapping controls and reduce server name truncation. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1378
- Show the full, wrapped server description on expanded cards. by @atacolak in https://github.com/samanhappy/mcphub/pull/1377
- Keep the About dialog within the viewport, with a scrollable body, an accessible close button, and Escape support. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1376

## 摘要

MCPHub v1.1.10 将协商后的 MCP 协议版本与服务器软件版本分开展示，方便查看上游连接信息。同时优化服务器列表的可读性，在展开的卡片中显示完整描述，并改善小屏幕下“关于”对话框的使用体验。

## 功能

- 在传输方式旁显示各上游 MCP 服务器协商后的协议版本，与软件版本分开展示。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1379

## 修复

- 优化服务器列表行布局，避免 Token 统计与控件重叠，并减少服务器名称被截断的情况。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1378
- 在展开的服务器卡片中显示完整描述，支持自动换行。by @atacolak in https://github.com/samanhappy/mcphub/pull/1377
- 将“关于”对话框限制在视口内，支持内容滚动、可访问的关闭按钮及 Escape 关闭。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1376

## New Contributors

- @atacolak made their first contribution in #1377

## References

- feat: display negotiated MCP protocol versions by @samanhappy in https://github.com/samanhappy/mcphub/pull/1379
- fix(frontend): improve server list row layout by @samanhappy in https://github.com/samanhappy/mcphub/pull/1378
- fix(ui): show full server description on expanded cards by @atacolak in https://github.com/samanhappy/mcphub/pull/1377
- fix: keep about dialog within the viewport by @samanhappy in https://github.com/samanhappy/mcphub/pull/1376
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.9...v1.1.10

### 1.1.9 (2026-10-23)
## Summary

MCPHub v1.1.9 makes large servers easier to manage with searchable bulk curation for tools, prompts, and resources plus a batch status API, and lets HTTP servers share one definition across regional or tenant endpoints through personal URL credential slots. It also forwards user-input elicitation for isolated legacy tool calls, adds the Vietnamese locale, stabilizes direct-route tool names across idle states, and unifies dark mode styling across dashboard forms and dialogs.

## Features

- Add Vietnamese locale support by @hdkp81 in https://github.com/samanhappy/mcphub/pull/1363
- Support personal URL credential slots for HTTP servers by @samanhappy in https://github.com/samanhappy/mcphub/pull/1368
- Forward elicitation for isolated legacy tool calls by @samanhappy in https://github.com/samanhappy/mcphub/pull/1370
- Add bulk tool curation and batch status API by @samanhappy in https://github.com/samanhappy/mcphub/pull/1372

## Fixes

- Stabilize direct-route tool names across idle states by @samanhappy in https://github.com/samanhappy/mcphub/pull/1374
- Unify dark mode styling across dashboard forms and dialogs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1375

## 摘要

MCPHub v1.1.9 让大型服务器更易管理：支持对工具、提示词和资源进行可搜索的批量处理并新增批量状态 API，同时通过个人 URL 凭据槽位让 HTTP 服务器在区域或租户端点之间共用同一份定义。该版本还为隔离的旧版工具调用转发用户输入征求、新增越南语界面、稳定空闲状态下直连路由的工具名称，并统一仪表盘表单和对话框的深色模式样式。

## 功能

- 新增越南语界面 by @hdkp81 in https://github.com/samanhappy/mcphub/pull/1363
- 为 HTTP 服务器新增个人 URL 凭据槽位 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1368
- 为隔离的旧版工具调用转发用户输入征求 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1370
- 新增批量工具管理和批量状态 API by @samanhappy in https://github.com/samanhappy/mcphub/pull/1372

## 修复

- 稳定空闲状态下直连路由的工具名称 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1374
- 统一仪表盘表单和对话框的深色模式样式 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1375

## New Contributors

- @hdkp81 made their first contribution in #1363

## References

- fix: unify dark mode styling across dashboard forms and dialogs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1375
- fix: stabilize direct-route tool names across idle states by @samanhappy in https://github.com/samanhappy/mcphub/pull/1374
- feat: add bulk tool curation and batch status API by @samanhappy in https://github.com/samanhappy/mcphub/pull/1372
- feat: forward elicitation for isolated legacy tool calls by @samanhappy in https://github.com/samanhappy/mcphub/pull/1370
- feat: support personal URL credential slots for HTTP servers by @samanhappy in https://github.com/samanhappy/mcphub/pull/1368
- Feature/vi locale by @hdkp81 in https://github.com/samanhappy/mcphub/pull/1363
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.8...v1.1.9

### 1.1.8 (2026-10-21)
## Summary

MCPHub v1.1.8 adds opt-in local account self-registration and per-tool input-schema parameter hiding. It also improves connection-status feedback, preserves personal OAuth bindings during unrelated server edits, displays server-reported versions, and updates MCP SDK, Hono, and Vite dependencies.

## Features

- Add opt-in local account self-registration by @samanhappy in https://github.com/samanhappy/mcphub/pull/1354
- Hide input-schema parameters per tool by @SelfRef in https://github.com/samanhappy/mcphub/pull/1343
- Show server-reported versions when runner package versions are unavailable by @samanhappy in https://github.com/samanhappy/mcphub/pull/1367

## Fixes

- Refresh server status faster during connection changes by @samanhappy in https://github.com/samanhappy/mcphub/pull/1355
- Preserve personal OAuth bindings during unrelated server edits by @samanhappy in https://github.com/samanhappy/mcphub/pull/1364
- Update MCP server SDK dependencies to 2.3.0 and server-legacy to 2.3.1, Hono to 4.13.11, and Vite to 6.4.4.

## 摘要

MCPHub v1.1.8 新增可选开启的本地账号自助注册和按工具隐藏输入参数的功能，同时加快连接状态反馈，避免无关的服务器编辑影响个人 OAuth 绑定，展示服务端报告的版本，并更新 MCP SDK、Hono 和 Vite 依赖。

## 功能

- 新增可选开启的本地账号自助注册 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1354
- 支持按工具隐藏输入 schema 中的参数 by @SelfRef in https://github.com/samanhappy/mcphub/pull/1343
- 无 runner 包版本时展示服务端报告的版本 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1367

## 修复

- 加快连接变化期间的服务器状态刷新 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1355
- 在无关的服务器编辑中保留个人 OAuth 绑定 by @samanhappy in https://github.com/samanhappy/mcphub/pull/1364
- 将 MCP server SDK 更新至 2.3.0、server-legacy 更新至 2.3.1、Hono 更新至 4.13.11、Vite 更新至 6.4.4。

## References

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

### 1.1.7 (2026-10-19)
## Summary

MCPHub v1.1.7 adds group-level instructions for MCP clients, optional Prometheus metrics, managed pruning for declarative settings, and an opt-in guard for high-risk tool-call arguments. It also improves OAuth registration and diagnostics, embedding token truncation, form parameter conversion, and tool-call troubleshooting.

## Features

- Configure group instructions returned during MCP initialization, including smart group routes and multi-server groups.
- Enable Prometheus metrics with `ENABLE_METRICS=true`; optionally protect `/metrics` with a dedicated `METRICS_TOKEN` bearer credential.
- Use `MCPHUB_SETTINGS_SYNC=prune` to permanently remove deleted settings-managed servers and groups at startup while preserving unmanaged dashboard entries.
- Enable `TOOL_CALL_GUARD_ENABLED=true` to reject tool calls whose arguments match high-confidence malicious patterns before forwarding them upstream. This guard is disabled by default and provides pattern-based checks, not comprehensive protection.

## Fixes

- Honor explicit OAuth redirect URIs during client registration, avoiding unintended fallback callbacks.
- Preserve useful OAuth failure diagnostics while continuing to sanitize credentials.
- Use `cl100k_base` when truncating text for supported OpenAI embedding models.
- Convert integer, number, and boolean array form parameters according to their item schemas.
- Include group, authenticated caller, and target tool context in tool-call error logs.
- Preserve hyphenated filenames and improve context-line parsing when compressing search results.

## 摘要

MCPHub v1.1.7 新增供 MCP 客户端使用的分组指令、可选的 Prometheus 指标、声明式配置的托管条目清理，以及可主动启用的高风险工具调用参数防护。同时改进了 OAuth 注册与诊断、嵌入文本的令牌截断、表单参数转换和工具调用故障排查。

## 功能

- 支持配置在 MCP 初始化时返回的分组指令，覆盖智能分组路由和多服务器分组。
- 通过 `ENABLE_METRICS=true` 启用 Prometheus 指标；可使用独立的 `METRICS_TOKEN` Bearer 凭据保护 `/metrics`。
- 通过 `MCPHUB_SETTINGS_SYNC=prune`，在启动时永久删除已从配置中移除的托管服务器和分组，同时保留非托管的控制台条目。
- 通过 `TOOL_CALL_GUARD_ENABLED=true`，在转发到上游前拒绝参数命中高置信恶意模式的工具调用。该防护默认关闭，提供基于模式的检查，不代表全面防护。

## 修复

- OAuth 客户端注册遵循显式配置的重定向 URI，避免混入非预期的回退回调地址。
- 保留有助于排查 OAuth 失败的诊断信息，同时继续对凭据进行脱敏。
- 为受支持的 OpenAI 嵌入模型使用 `cl100k_base` 进行文本令牌截断。
- 根据元素类型定义转换表单中的整数、数字和布尔值数组参数。
- 在工具调用错误日志中补充分组、已认证调用者和目标工具上下文。
- 压缩搜索结果时保留含连字符的完整文件名，并改进上下文行解析。

## New Contributors

- @Lay-quq made their first contribution in #1347
- @DSHCorrectover made their first contribution in #1299

## References

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

### 1.1.6 (2026-10-18)
## Summary

This release adds configurable Smart Routing paths while preserving existing `$smart` URLs. It also aligns Marketplace installation options with user permissions, fixes credential-slot saves when only the default shared OAuth identity is present, and improves Bearer authentication compatibility and update-check cache configuration handling.

## Features

- Configure Smart Routing endpoints with `SMART_ROUTING_PATH`; existing `$smart` URLs remain supported.

## Fixes

- Disable local command installations for non-admin users in Marketplace and Registry, with an explanation, while keeping supported remote installations available.
- Allow credential slots when OAuth contains only the default shared identity setting, and preserve credential bindings when renaming affected legacy servers.
- Accept the Bearer authentication scheme case-insensitively.
- Treat an empty update-check cache TTL as unset.

## 摘要

本版本支持自定义智能路由路径，并继续兼容现有 `$smart` URL。同时，让市场安装选项与用户权限保持一致，修复仅存在默认共享 OAuth 身份设置时凭据槽无法保存的问题，并改进 Bearer 认证兼容性和更新检查缓存配置处理。

## 功能

- 通过 `SMART_ROUTING_PATH` 自定义智能路由端点，继续支持现有 `$smart` URL。

## 修复

- 在市场和注册表中为非管理员禁用本地命令安装并显示原因，保留受支持的远程安装。
- OAuth 仅包含默认共享身份设置时允许使用凭据槽，并在重命名受影响的旧服务器配置时保留凭据绑定。
- Bearer 认证方案名称支持大小写不敏感匹配。
- 将空的更新检查缓存 TTL 视为未设置。

## References

- fix(changelog): treat an empty update-check cache TTL as unset by @pacocartones in https://github.com/samanhappy/mcphub/pull/1338
- fix(auth): accept the Bearer scheme case-insensitively by @pacocartones in https://github.com/samanhappy/mcphub/pull/1337
- fix: allow credential slots with default shared OAuth identity by @samanhappy in https://github.com/samanhappy/mcphub/pull/1335
- feat: support configurable smart routing paths by @samanhappy in https://github.com/samanhappy/mcphub/pull/1331
- fix: align marketplace installs with server permissions by @samanhappy in https://github.com/samanhappy/mcphub/pull/1330
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.5...v1.1.6

### 1.1.5 (2026-10-16)
## Summary

MCPHub v1.1.5 adds Spanish localization and improves API validation and tool-list synchronization. Server-list requests with non-numeric pagination parameters now return HTTP 400, and clients are notified when a server is removed from a group so they can refresh the available tools.

## Features

- Add Spanish (es) localization to the interface, with Español available in the language menu. by @arioko in https://github.com/samanhappy/mcphub/pull/1328

## Fixes

- Return HTTP 400 for non-numeric page or limit parameters in server-list requests. by @pacocartones in https://github.com/samanhappy/mcphub/pull/1325
- Notify tool listeners when a server is removed from a group, allowing connected clients to refresh their tool lists. by @pacocartones in https://github.com/samanhappy/mcphub/pull/1324

## 摘要

MCPHub v1.1.5 新增西班牙语界面，并改进 API 参数校验与工具列表同步。服务器列表请求中的分页参数为非数字时，现在会返回 HTTP 400；从分组移除服务器后，也会通知已连接的客户端刷新可用工具。

## 功能

- 新增西班牙语（es）界面，可在语言菜单中选择 Español。 by @arioko in https://github.com/samanhappy/mcphub/pull/1328

## 修复

- 当服务器列表请求的 page 或 limit 参数为非数字时，返回 HTTP 400。 by @pacocartones in https://github.com/samanhappy/mcphub/pull/1325
- 从分组移除服务器后通知工具监听器，使已连接的客户端能够刷新工具列表。 by @pacocartones in https://github.com/samanhappy/mcphub/pull/1324

## New Contributors

- @pacocartones made their first contribution in #1325
- @arioko made their first contribution in #1328

## References

- feat: add Spanish (es) localization by @arioko in https://github.com/samanhappy/mcphub/pull/1328
- fix(servers): answer 400 for a non-numeric page or limit on the server list by @pacocartones in https://github.com/samanhappy/mcphub/pull/1325
- fix(groups): notify tool listeners when a server is removed from a group by @pacocartones in https://github.com/samanhappy/mcphub/pull/1324
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.4...v1.1.5

### 1.1.4 (2026-10-15)
## Summary

v1.1.4 expands personal upstream authentication with independent OAuth connections and credential slots in stdio arguments. It also improves OAuth discovery, aggregate tool routing, and Windows compatibility.

## Features

- Support personal upstream OAuth bindings, with per-user authorization and dashboard connection controls. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1318
- Support personal credential slots in stdio arguments using explicit `{{args.API_KEY}}` placeholders. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1313

## Fixes

- Publish path-aware OAuth protected-resource metadata and matching authentication challenges. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1322
- Preserve aggregate tool naming and routing for OpenAPI and personal upstreams in Apps-capable clients. by @zhiwei-dong in https://github.com/samanhappy/mcphub/pull/1320
- Fix MCPB uploads on Windows by keeping the rename destination absent. by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1314
- Fix Windows path matching in the Jest transform for `jose`. by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1315

## 摘要

v1.1.4 扩展了上游服务的个人身份认证能力，支持独立的 OAuth 连接和 stdio 参数中的个人凭据槽位，同时改进 OAuth 服务发现、聚合工具路由和 Windows 兼容性。

## 功能

- 支持个人上游 OAuth 绑定，提供逐用户独立授权和仪表盘连接管理。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1318
- 支持通过显式 `{{args.API_KEY}}` 占位符在 stdio 参数中使用个人凭据槽位。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1313

## 修复

- 发布与端点路径对应的 OAuth 受保护资源元数据及匹配的认证质询。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1322
- 修复支持 Apps 的客户端中 OpenAPI 和个人上游的聚合工具命名与路由。by @zhiwei-dong in https://github.com/samanhappy/mcphub/pull/1320
- 确保重命名目标目录不存在，修复 Windows 上的 MCPB 上传失败。by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1314
- 修复 Jest 对 `jose` 的转换规则在 Windows 上的路径匹配。by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1315

## New Contributors

- @zhiwei-dong made their first contribution in #1320
- @remote-controlled-man made their first contribution in #1315

## References

- fix: publish path-aware OAuth protected resource metadata by @samanhappy in https://github.com/samanhappy/mcphub/pull/1322
- fix(apps): preserve aggregate routing for OpenAPI and personal upstreams by @zhiwei-dong in https://github.com/samanhappy/mcphub/pull/1320
- feat: support personal upstream OAuth bindings by @samanhappy in https://github.com/samanhappy/mcphub/pull/1318
- fix(test): match jose transform paths on Windows by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1315
- fix(mcpb): keep upload rename destination absent on Windows by @remote-controlled-man in https://github.com/samanhappy/mcphub/pull/1314
- feat: support personal credential slots in stdio args by @samanhappy in https://github.com/samanhappy/mcphub/pull/1313
- docs: add GitHub Sponsors button to READMEs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1308
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.3...v1.1.4

### 1.1.3 (2026-10-11)
## Summary

MCPHub v1.1.3 adds administrator-managed CIDR allowances for upstream access and improves compatibility for CLI tool calls, MCP Apps widgets on idle on-demand servers, and stateful tools in ChatGPT Work/Codex.

## Features

- Allow administrators to configure IPv4/IPv6 CIDR ranges for upstream access through Settings or `systemConfig.network.allowedCidrs`. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1300

## Fixes

- Initialize MCP sessions for CLI tool calls, fixing HTTP 400 errors caused by missing session IDs. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1304
- Wake idle on-demand servers when reading their `ui://` widgets, preventing premature “Resource not found” errors. by @jcollas in https://github.com/samanhappy/mcphub/pull/1303
- Support authenticated, scoped session-state correlation through OpenAI session metadata when the explicit state header is absent, restoring stateful tool compatibility in ChatGPT Work/Codex. by @khanhkit in https://github.com/samanhappy/mcphub/pull/1307

## 摘要

MCPHub v1.1.3 新增由管理员配置的上游访问 CIDR 白名单，并改善 CLI 工具调用、空闲按需启动服务器的 MCP Apps 小组件，以及 ChatGPT Work/Codex 中有状态工具的兼容性。

## 功能

- 支持管理员通过设置页面或 `systemConfig.network.allowedCidrs` 配置允许上游访问的 IPv4/IPv6 CIDR 网段。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1300

## 修复

- CLI 工具调用前初始化 MCP 会话，修复因缺少会话 ID 导致的 HTTP 400 错误。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1304
- 读取 `ui://` 小组件时唤醒空闲的按需启动服务器，避免提前返回“Resource not found”错误。by @jcollas in https://github.com/samanhappy/mcphub/pull/1303
- 未提供显式状态请求头时，支持通过 OpenAI 会话元数据在已认证的作用域内关联会话状态，恢复 ChatGPT Work/Codex 中有状态工具的兼容性。by @khanhkit in https://github.com/samanhappy/mcphub/pull/1307

## New Contributors

- @khanhkit made their first contribution in #1307

## References

- fix: support OpenAI session state fallback by @khanhkit in https://github.com/samanhappy/mcphub/pull/1307
- docs: add AtomGit hosting link to READMEs by @samanhappy in https://github.com/samanhappy/mcphub/pull/1305
- fix: initialize MCP sessions for CLI tool calls by @samanhappy in https://github.com/samanhappy/mcphub/pull/1304
- fix(apps): wake an idle on-demand server to serve its ui:// widget by @jcollas in https://github.com/samanhappy/mcphub/pull/1303
- feat: allow admin-managed upstream CIDR ranges by @samanhappy in https://github.com/samanhappy/mcphub/pull/1300
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.2...v1.1.3

### 1.1.2-build.1 (2026-10-10)
CI 变更
- feat(addons): 为 6 个 addon 补充图标

### 1.1.2 (2026-10-10)
## Summary

MCPHub v1.1.2 adds JWKS-based forward authentication and enables MCP Apps widgets for pinned tools on smart-routing group endpoints. It also improves upstream compatibility and server lifecycle reliability by correcting overly broad IP blocking, adding an administrator-controlled exception for HTTP OAuth token endpoints, preserving personal credentials during plain server renames, and preventing duplicate queued on-demand discovery.

## Features

- Add JWKS-based forward authentication for dashboard APIs and MCP transports. by @yash025 in https://github.com/samanhappy/mcphub/pull/1295
- Preserve MCP Apps metadata on pinned tools at `$smart/{group}`, enabling widgets for compatible clients. by @jcollas in https://github.com/samanhappy/mcphub/pull/1296

## Fixes

- Cancel queued on-demand discovery when tools are already cached or the runtime is no longer eligible, avoiding duplicate server processes. by @xujiantop-crypto in https://github.com/samanhappy/mcphub/pull/1297
- Correct the CGNAT blocklist range so public 100.x and 101.x addresses are no longer incorrectly blocked. by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1294
- Allow administrators to explicitly enable HTTP OAuth token endpoints per upstream, with the exception disabled by default. by @samanhappy in https://github.com/samanhappy/mcphub/pull/1293
- Preserve personal credential bindings when renaming a server without changing its connection configuration. by @SelfRef in https://github.com/samanhappy/mcphub/pull/1291

## 摘要

MCPHub v1.1.2 新增基于 JWKS 的转发认证，并支持在智能路由分组端点上为固定工具展示 MCP Apps 小组件。本版本还提升了上游兼容性和服务器生命周期的稳定性：修正范围过大的 IP 拦截，为 HTTP OAuth 令牌端点提供由管理员控制的例外设置，在仅重命名服务器时保留个人凭据，并避免排队的按需发现任务重复启动进程。

## 功能

- 为仪表盘 API 和 MCP 传输新增基于 JWKS 的转发认证。by @yash025 in https://github.com/samanhappy/mcphub/pull/1295
- 保留 `$smart/{group}` 固定工具的 MCP Apps 元数据，让兼容客户端能够展示小组件。by @jcollas in https://github.com/samanhappy/mcphub/pull/1296

## 修复

- 当工具已缓存或运行实例不再满足执行条件时，取消排队的按需发现任务，避免重复启动服务器进程。by @xujiantop-crypto in https://github.com/samanhappy/mcphub/pull/1297
- 修正 CGNAT 拦截范围，避免错误拦截公网 100.x 和 101.x 地址。by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1294
- 允许管理员为单个上游显式启用 HTTP OAuth 令牌端点，该例外默认关闭。by @samanhappy in https://github.com/samanhappy/mcphub/pull/1293
- 在仅重命名服务器且未更改连接配置时，保留用户的个人凭据绑定。by @SelfRef in https://github.com/samanhappy/mcphub/pull/1291

## New Contributors

- @xujiantop-crypto made their first contribution in #1297
- @yash025 made their first contribution in #1295
- @OsamaAnsar made their first contribution in #1294

## References

- fix: cancel already primed queued on-demand discovery by @xujiantop-crypto in https://github.com/samanhappy/mcphub/pull/1297
- feat(smart-routing): keep MCP Apps metadata on pinned tools of $smart/{group} by @jcollas in https://github.com/samanhappy/mcphub/pull/1296
- feat(auth): add JWKS forward auth by @yash025 in https://github.com/samanhappy/mcphub/pull/1295
- fix(ssrf): correct the CGNAT range so public 100.x addresses are not blocked by @OsamaAnsar in https://github.com/samanhappy/mcphub/pull/1294
- fix(oauth): allow admin-controlled HTTP token endpoints per upstream by @samanhappy in https://github.com/samanhappy/mcphub/pull/1293
- fix(servers): keep personal credential bindings across a plain server rename by @SelfRef in https://github.com/samanhappy/mcphub/pull/1291
- Full changelog: https://github.com/samanhappy/mcphub/compare/v1.1.1...v1.1.2

<!-- auto-generated by CI -->