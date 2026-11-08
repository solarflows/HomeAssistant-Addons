### 8.0.61 (2026-11-08)

#### Changelog

- docs(readme): mention cpa-status in Hermes entry (418b824c)
- docs(readme): add SWE-2 Flash to Devin models (59a2b353)
- fix(codex): preserve SIWC rotations and honor renewal windows (80ee739f)
- fix(codex): reuse the issued SIWC client during CLI reauthorization (3891ebaa)
- fix(codex): defer SIWC renewal during macOS maintenance wakes (8c6d8b18)
- fix(auth): retain partition failures alongside SIWC wake cancellation (baec297f)
- test(codex): make SIWC power-state checks deterministic (03c394ee)
- fix(codex): retain SIWC renewal windows in refresh receipts (a46be7ae)
- Merge pull request #7306 from kdcokenny/docs/swe-2-flash-availability (0e071088)
- feat(plugin-store): support opt-in release cache refresh on store listing (f69db99d)
- Merge branch 'codex/pr-7311' into dev (466b28da)
- fix(codex): harden SIWC refresh deferral and expires_in parsing (09b3a579)
- fix(responses): sanitize orphan tool outputs lacking call_id (05e668cf)
- feat(auth): support session-affinity-rebind-on never mode (40c16182)
- feat(pluginhost): expose token modality details in usage.handle (00748974)
- Merge pull request #7281 from duu261/docs/readme-cpa-status (681ce41b)


#### What's Changed
* docs(readme): add SWE-2 Flash to Devin models by @kdcokenny in https://github.com/router-for-me/CLIProxyAPI/pull/7306
* Fix SIWC renewal and defer refresh during macOS maintenance wakes by @JehudaRajasa in https://github.com/router-for-me/CLIProxyAPI/pull/7311
* docs(readme): mention cpa-status in Hermes entry by @duu261 in https://github.com/router-for-me/CLIProxyAPI/pull/7281

#### New Contributors
* @JehudaRajasa made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7311

---

### 8.0.60-build.1 (2026-11-08)

CI 工作流维护
- 自动化构建流水线与容器发布底座例行维护

---

### 8.0.60 (2026-11-07)

#### Changelog

- fix(auth): keep native Codex available during SIWC recovery (5f38d557)
- Merge pull request #7305 from router-for-me/fix/codex-refresh-uncertain-outcome (bbefed68)
- fix(openai): replace responses websocket transcript when pending tool calls are unanswered (f4d3f061)
- fix(pluginhost): reuse content-addressed plugin shadow copies across restarts (b5b724d0)
- fix(openai): skip whitespace-only reasoning when opening Claude thinking blocks (69637a66)
- fix(claude): drain streamed response body after message_stop to reuse upstream connections (ce38c75c)
- fix(translator): preserve standalone Claude output_config.effort on OpenAI requests (e6931d51)
- fix(openai): prevent SSE keep-alive injection mid-line during image streaming (91e0dee8)


#### What's Changed
* fix(auth): keep native Codex available during SIWC recovery by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/7305

---

### 8.0.59 (2026-11-07)

#### Changelog

- fix(codex): prevent replay after uncertain refresh outcomes (68cd7572)
- feat(management): expose oauth_provider in credential list (0559fa3c)
- fix(codex): normalize small output budgets for all source formats (bfac8586)
- fix(codex): normalize nested custom tools across Chat Completions round trips (2443e883)
- fix(codex): preserve prompt cache prefix when loading deferred tools via ToolSearch (374056f2)
- Merge pull request #7308 from WizisCool/feat/management-oauth-provider (c9f97398)
- feat(auth): enhance OAuth provider handling with explicit hints and metadata preservation (482efbf5)
- fix(claude): align OAuth authorization state and scopes (ea0b4712)
- Merge pull request #7317 from router-for-me/fix/claude-oauth-authorization-parameters (eabcd01d)
- fix(claude): keep mid-session responses system items in place to preserve prompt cache (27762819)
- fix(translator): preserve reasoning and text across multi-part gemini and antigravity chunks (c5251b57)


#### What's Changed
* feat(management): expose oauth_provider in credential list by @WizisCool in https://github.com/router-for-me/CLIProxyAPI/pull/7308
* fix(claude): restore OAuth login compatibility by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/7317

---

### 8.0.58 (2026-11-06)

#### Changelog

- feat(models): add gpt-6-chat-thinking to registries (c1842be2)
- fix(claude): correct gemini tool result and signature translation (55c05f70)
- fix(codex): normalize small claude output budgets (9be48133)
- fix(claude): show cooldown retry time in error messages (e458999b)
- fix(auth): preserve terminal responses across execution paths (1d4e0549)
- Merge pull request #7294 from router-for-me/fix/home-terminal-request-boundaries (2c16b1a3)
- fix(executor): support Codex remote compaction v2 on native Devin route (fb77445f)
- fix(codex): reject unsupported hosted image requests (d1e5cc60)
- Merge pull request #7295 from router-for-me/fix/codex-hosted-image-request-scope (e5e6ad1e)


#### What's Changed
* fix(auth): preserve terminal responses across execution paths by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/7294
* fix(codex): reject unsupported hosted image requests by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/7295

---

### 8.0.57 (2026-11-05)

#### Changelog

- fix(usage): clear consumed queue slot in usage manager dispatcher (f2e255f7)
- fix(codex): handle Responses-Lite hosted image_generation compatibility (8fb60326)
- feat(devin): update devin_models.json with swe-2-flash, nemotron-3-5-super, and gpt-6-1-terra (a3c84a37)
- fix(auth): keep count_tokens 501 and unsupported capability responses availability-neutral (1c537211)
- fix(meta): send X-Tbh-Contributor-Mode header only for contributor models (c2f402b4)

---

### 8.0.56 (2026-11-05)

#### Changelog

- fix(logging,clienterror): classify mid-stream cyber blocks as 400 and persist error logs (c3938b72)
- fix(logging,executor): preserve Claude Fast classified error status and cap deferred body buffering (0a94b2ae)
- perf,fix(logging,websocket): avoid 200 OK body buffering and synchronize ws disconnect error logging (69a032de)
- fix(executor): classify non-stream Claude policy refusals as 400 request faults (03a8743c)
- fix(executor,handlers): require stream-level evidence for Gemini filter blocks and pre-log terminal chunk errors (508ac2bc)
- fix(handlers): record TTFT for direct plugin executor routes (f208c908)
- feat(codex): add support for gpt-image-2.6 models (7a7d37ec)
- Merge pull request #7262 from Nciae-Zyh/feat/codex-gpt-image-26 (010de194)
- fix(openai): bridge client tool_search in Chat Completions Responses translator (8c9a7851)
- fix(openai): translate thinking content-part arrays in Claude response translator (6044c5d1)
- fix(executor,logging): preserve Antigravity usage evidence, sparse Claude refusal identity, and Home stream error logs (be691624)
- Merge pull request #7242 from sususu98/fix/cyber-block-request-fault-and-error-log (6897eebd)
- fix(codex,auth): bypass SIWC for OpenAI image requests and route directly to Codex images endpoint (dfe8b182)
- fix(openai): expose terminal 429 error frames on responses websocket (b5e6027c)
- Merge pull request #7265 from sususu98/fix/codex-openai-image-bypass-siwc (62c58a74)
- fix(auth): pass context and headers to availableAuthsForSelector in HasAlternativeTargetForModel (585f97de)


#### What's Changed
* feat(codex): add support for gpt-image-2.6 models by @Nciae-Zyh in https://github.com/router-for-me/CLIProxyAPI/pull/7262
* fix(clienterror,logging): classify mid-stream cyber blocks as 400 and persist error logs by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7242
* fix(codex,auth): bypass SIWC for OpenAI image requests and route directly to Codex images endpoint by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7265

#### New Contributors
* @Nciae-Zyh made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7262

---

### 8.0.55 (2026-11-04)

#### Changelog

- feat(kvstore): add local bbolt key-value store and integration routing (ec14dc47)
- fix(executor): support Codex remote compaction v2 on openai-compatible routes (d57270f4)
- feat(claude): persist cloaked session date pins in persistent KV store (e6e5708e)

---

### 8.0.54 (2026-11-04)

#### Changelog

- feat(usage): extract cached image/audio and interactions modality tokens (6d7e6a3b)
- fix(thinking): prefer Claude mid-conversation effort directives in usage extraction (fb30a9e8)
- fix(devin): honor Claude mid-conversation effort directives when selecting model variants (061ffe6f)
- fix(codex): sanitize invalid characters in Codex input item IDs (606e667a)
- fix(pluginhost): abort hot reload on quiesce failure and coordinate usage replay (6e103599)
- Merge pull request #7231 from sususu98/feat/usage-cached-modality-tokens (196ca839)
- feat(antigravity): bump fallback version to 2.29.0 and add changelist mapping (f72f8bfd)
- feat(auth): extract Antigravity model discovery to sdk/auth (f3762c64)
- refactor(auth): route Antigravity model JSON operations through ojson (f49bd5d9)
- Merge pull request #7238 from sususu98/feat/antigravity-models-discovery-sdk-auth (cbf0188e)
- fix(auth): clone parsed model IDs and preserve nil unknown catalogs (0e02765c)
- chore(deps): update github.com/router-for-me/moego to v0.1.2 (78a9cc9a)


#### What's Changed
* feat(usage): extract cached image/audio and interactions modality tokens by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7231
* feat(auth): extract Antigravity model discovery to sdk/auth by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7238

---

### 8.0.53 (2026-11-03)

#### Changelog

- fix(auth): prevent auto-refresh spin for disabled credentials with rejected refresh tokens (e5827065)
- fix(claude): keep Fable-only 429 rejections model-scoped when 5h headers are omitted (0130d6f3)
- fix(devin): sanitize embedded exec tool phrases and stop retrying request-caused 403 errors (e25b7daf)
- fix(antigravity): map safety and filter finish reasons to refusal in claude response translator (24b04548)
- fix(management): honor targeted OAuth re-login across all built-in providers (d3899771)
- fix(codex): disable supports_image_detail_original for non-codex catalog routes (a1eeb60e)
- fix(claude): drop replayed web search citations when search results are missing (9acf81d3)
- fix(pluginhost): isolate unix plugin dlopen crashes with a preflight subprocess probe (dde469d3)
- fix(agents): enforce usage of moego libraries for JSON and Base64 operations (54778bd3)
- feat(config): support native-entrypoints configuration for Claude Code clients (6d4102f3)
- fix(pluginhost): preserve disabled auth state across plugin refreshes (04208efa)
- fix(translator/gemini): nest Claude tool_result images inside functionResponse.parts (be864305)
- fix(devin): keep sealed reasoning items sent back via the Responses API (b3442f65)
- Merge pull request #7229 from maomaocun/fix/devin-responses-reasoning-passthrough (193debb8)
- refactor(translator): build Devin thought step with a single ojson.Doc (cfa25b4a)
- fix(codex): preserve and forward max_output_tokens across request translators (01b24f1f)


#### What's Changed
* fix(devin): keep sealed reasoning items sent back via the Responses API by @maomaocun in https://github.com/router-for-me/CLIProxyAPI/pull/7229

#### New Contributors
* @maomaocun made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7229

---

### 8.0.52-build.2 (2026-11-03)

CI 变更
- chore(cliproxyapi): update PANEL_VERSION 1.14.5 → 1.14.10
- chore(cliproxyapi): update PANEL_VERSION 1.14.5 → 1.14.10

---

### 8.0.52-build.1 (2026-11-03)

#### Changelog

- fix(auth/antigravity): request aicode OAuth scope (7c627ffb)
- fix(helps): release TransportCache mutex on builder panic and retire purged entries (8a82bed5)
- fix(pluginhost): scope model execution streams to the owning plugin and instance (3698b159)
- fix(config): include connection-pool settings in credential deduplication keys (8643ea56)
- fix(api/middleware): finalize request logging on handler panic (a5795047)
- fix(translator): normalize omitted and function roles in Gemini ingress translators (c888ff72)
- Merge pull request #7187 from sususu98/fix/gemini-omitted-content-role-7186 (06ec5eac)
- Merge pull request #7164 from sususu98/fix/transport-cache-panic-unlock-7162 (32e3fd55)
- Merge pull request #7165 from sususu98/fix/credential-dedup-connection-pool-7163 (ef04e83a)
- Merge pull request #7166 from sususu98/fix/request-logging-finalize-on-panic-7161 (f31d60aa)
- Merge pull request #6315 from SomSamantray/fix/antigravity-aicode-scope (533687e4)
- fix(pluginhost): reject model stream registration after concurrent teardown (d96b1941)
- Merge pull request #7167 from sususu98/fix/pluginhost-model-stream-ownership-7159 (d7af3711)
- refactor: migrate gjson, sjson, and base64 to MoeForge/moego (6e6afab9)


#### What's Changed
* fix(translator): normalize omitted and function roles in Gemini ingress translators by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7187
* fix(helps): release TransportCache mutex on builder panic and retire purged entries by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7164
* fix(config): include connection-pool settings in credential deduplication keys by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7165
* fix(api/middleware): finalize request logging on handler panic by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7166
* fix(auth/antigravity): request aicode OAuth scope by @SomSamantray in https://github.com/router-for-me/CLIProxyAPI/pull/6315
* fix(pluginhost): scope model execution streams to the owning plugin and instance by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7167

#### New Contributors
* @SomSamantray made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6315

#### PANEL_VERSION (seakee/CPA-Manager-Plus v1.14.10)
#### CPA Manager Plus v1.14.10

> 35 commits (including merges) · 37 files changed · +1323 / -108

> [English →](https://github.com/seakee/CPA-Manager-Plus/blob/v1.14.10/docs/release-notes/v1.14.10-en.md)

<!-- cpamp-update
{
  "summary": {
    "zh": "新增跨提供商凭证置顶，修复 CPA 模型排除规则展示、历史价格恢复、插件默认配置及页面参数同步，并补齐 CPA v8 API Key 分组只读代理。",
    "en": "Adds cross-provider credential pinning and fixes model exclusion precedence, historical pricing recovery, plugin defaults, URL state sync, and read-only CPA v8 API-key group proxying."
  },
  "update": {
    "breaking": false,
    "migration_required": false,
    "minimum_direct_upgrade_version": null,
    "upgrade_guide_url": "https://github.com/seakee/CPA-Manager-Plus/releases/tag/v1.14.10"
  },
  "compatibility": {
    "minimum_cpa_version": "v7.3.4"
  }
}
-->

#### Overview

v1.14.10 是 v1.14.9 之后的 1.x 功能完善与问题修复版本。新增常用凭证置顶，并修复模型排除优先级、历史价格读取、插件配置默认值及同页面 URL 状态同步问题。Manager Server 还补充了范围受限的 CPA v8 API Key 分组只读转发。不包含 v2 架构改造。

#### Changes

### 凭证管理与页面交互

- **凭证置顶（#1098、#1102）**：可在表格或卡片视图置顶关注的凭证；符合当前筛选条件的置顶项按置顶先后排在列表前列，其他项仍按原排序。图钉改为账号名称旁的轻量按钮，避免遮挡提供商标识。置顶状态仅保存在当前浏览器，选择模式下不提供置顶操作。
- **模型排除的实际生效规则（#1080）**：按 CPA 版本区分 OAuth 排除优先级。CPA v6.10.8–v8.0.32 合并全局和凭证规则；v8.0.33+ 的非空凭证列表覆盖全局规则，空列表继承全局规则。模型数量、徽标、操作状态和编辑提示按实际生效规则展示；新增凭证排除时避免意外重新放开全局已排除模型。无法识别版本时采取保守的编辑限制。
- **同页面 URL 状态（#1099）**：修复仅变更查询参数或锚点时页面未收到新地址的问题。凭证管理的筛选、搜索、排序、布局和详情状态能与 URL 保持一致，刷新、前进后退及分享链接可还原当前视图；修复快速输入时旧地址回写覆盖新搜索条件的问题。
- **插件默认配置（#1073）**：当保存的插件配置缺少某字段时，配置抽屉显示 CPA 提供的声明默认值；已显式保存的 false、0、空字符串或 null 不受影响。仅展示默认值不会把它写入配置文件。未提供默认值的旧版 CPA 仍保持原有行为。

### Manager Server 与数据读取

- **历史价格恢复（#1083）**：当历史价格投影缺失或过期、但原始用量事件仍完整时，按原始事件恢复价格读取，避免部分用量分析和凭证历史查询因投影缺口报错。确实丢失的历史事件不会被臆造补齐；不改变价格、数据库结构或已存储数据。
- **CPA v8 API Key 分组只读代理（#1097）**：Manager Server 仅向已验证的 CPAMP 管理员转发 `GET /v8/management/config/api-keys` 及其子路径，供插件页面读取分组名称和密钥标识。拒绝写入及其他 v8 管理路径，并拦截路径穿越；CPA Panel 模式保持原状。

### 维护

- **依赖安全（#1093）**：更新仅在开发工具中使用的 Zod 锁定版本，解除依赖漏洞扫描对 CI 的阻断；不改变运行时依赖行为。
- **依赖升级策略（#1070）**：关闭例行 Dependabot 版本升级 PR，依赖升级回归开发迭代与针对性安全维护；不改变产品运行逻辑。

#### Upgrade Notes

- 从 v1.14.9 正常更新并重启即可；无数据库迁移、凭证重建或配置格式变更。
- 凭证置顶仅在当前浏览器保留，不跨设备同步，也不会越过既有筛选；文件重命名或身份标识变化后旧置顶可能不再匹配。
- 模型排除行为由运行的 CPA 版本决定，尤其注意 v8.0.33+ 的凭证级非空列表覆盖规则；本次调整的是 CPAMP 的解释与编辑交互，不会修改上游优先级。
- Manager Server 模式读取 CPA v8 API Key 分组需要上游支持该 v8 接口；经同域名反向代理部署时应检查 [反向代理说明](https://github.com/seakee/CPA-Manager-Plus/blob/v1.14.10/apps/docs/deployment/reverse-proxy.md) 中的对应路径。该接口仅限管理员只读访问。
- 完整 Muse / Meta 功能的 CPA 最低兼容基线仍为 **v7.3.4+**；此版本没有提高整体最低版本。
- 相关修复已通过合入时的测试和当前 dev 必需检查；正式发布仍以 Release Dry Run 及发布工作流为准。

---

### 8.0.52 (2026-11-03)

#### Changelog

- fix(auth/antigravity): request aicode OAuth scope (7c627ffb)
- fix(helps): release TransportCache mutex on builder panic and retire purged entries (8a82bed5)
- fix(pluginhost): scope model execution streams to the owning plugin and instance (3698b159)
- fix(config): include connection-pool settings in credential deduplication keys (8643ea56)
- fix(api/middleware): finalize request logging on handler panic (a5795047)
- fix(translator): normalize omitted and function roles in Gemini ingress translators (c888ff72)
- Merge pull request #7187 from sususu98/fix/gemini-omitted-content-role-7186 (06ec5eac)
- Merge pull request #7164 from sususu98/fix/transport-cache-panic-unlock-7162 (32e3fd55)
- Merge pull request #7165 from sususu98/fix/credential-dedup-connection-pool-7163 (ef04e83a)
- Merge pull request #7166 from sususu98/fix/request-logging-finalize-on-panic-7161 (f31d60aa)
- Merge pull request #6315 from SomSamantray/fix/antigravity-aicode-scope (533687e4)
- fix(pluginhost): reject model stream registration after concurrent teardown (d96b1941)
- Merge pull request #7167 from sususu98/fix/pluginhost-model-stream-ownership-7159 (d7af3711)
- refactor: migrate gjson, sjson, and base64 to MoeForge/moego (6e6afab9)


#### What's Changed
* fix(translator): normalize omitted and function roles in Gemini ingress translators by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7187
* fix(helps): release TransportCache mutex on builder panic and retire purged entries by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7164
* fix(config): include connection-pool settings in credential deduplication keys by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7165
* fix(api/middleware): finalize request logging on handler panic by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7166
* fix(auth/antigravity): request aicode OAuth scope by @SomSamantray in https://github.com/router-for-me/CLIProxyAPI/pull/6315
* fix(pluginhost): scope model execution streams to the owning plugin and instance by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7167

#### New Contributors
* @SomSamantray made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6315

---

### 8.0.51 (2026-11-01)

#### Changelog

- chore(meta): match Muse Code 1.4.14 client headers (d9a688e6)
- fix(meta): include Muse namespace in tool-bearing requests (b147b8d2)
- fix(xai): support Grok Imagine Video 1.5 Lite (f0ddc38f)
- fix(auth): skip automatic Codex refresh without renewal credentials (95f125ff)
- fix(auth): preserve disabled credential refresh backoff (7b4c64b0)
- fix(xai): preserve Lite resolution and catalog fallback (c69cdd93)
- docs(auth): explain Codex refresh token key requirement (9513c2d5)
- feat(pluginstore): support plugin locales normalization and management passthrough (ce39bc62)
- Merge pull request #7143 from router-for-me/fix/codex-no-refresh-token-spin (24f97440)
- feat(pluginhost): expose per-entry name and logo for multi-entry OAuth plugins (53ff2f9e)
- fix(translator): normalize numeric schema constraints when converting parameters (#7149) (ec06c3cb)
- Merge pull request #7113 from zoidypuh/pr/muse-1414-client-headers (4448b96e)
- fix(translator): preserve developer roles in responses to chat completions (00b76771)
- fix(gemini): preserve parallel responses tool output batches across developer notices (3ac38498)
- Merge pull request #7142 from gabrielrinaldi/fix/grok-video-1.5-lite (7cad1cb7)


#### What's Changed
* fix(auth): prevent Codex refresh spin without refresh tokens by @LTbinglingfeng in https://github.com/router-for-me/CLIProxyAPI/pull/7143
* fix(meta): add Muse tool namespace for subscription requests by @zoidypuh in https://github.com/router-for-me/CLIProxyAPI/pull/7113
* fix(xai): support Grok Imagine Video 1.5 Lite by @gabrielrinaldi in https://github.com/router-for-me/CLIProxyAPI/pull/7142

#### New Contributors
* @zoidypuh made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7113
* @gabrielrinaldi made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7142

---

### 8.0.49 (2026-11-01)

#### Changelog

- feat(claude): add opt-in visible Codex commentary with preserved replay (cc4b9949)
- fix(gemini): strip empty part objects from systemInstruction (#7136) (4c46f0aa)
- feat(pluginhost): allow plugins to register multiple OAuth login entries (a8dbebab)
- fix(antigravity): strip empty part objects from Gemini systemInstruction.parts (f42f5871)
- fix(antigravity): discard excess functionResponse parts per turn in fixCLIToolResponse (#7137) (234217d0)
- perf(antigravity): make selectGroupResponses O(N+M) and deduplicate systemInstruction sanitize (250d5981)

---

### 8.0.48 (2026-10-30)

#### Changelog

- test(openai): assert websocket disconnect error event (fa42f390)
- fix(devin): classify JSON control character errors (02ee3139)
- Merge pull request #7092 from sususu98/fix/slow-test-disconnect (56efc81f)
- fix(aistudio): buffer fragmented relay SSE frames (7df437c8)
- fix(aistudio): add relay SSE frame reassembly helper (498170a4)
- feat(usage): capture structured Anthropic Messages upstream usage details (89e472f3)
- feat(usage): capture structured xAI usage across chat, responses, and media (24840fdd)
- feat(usage): capture structured OpenAI and Codex usage across responses, chat, and images (01551f5f)
- feat(usage): capture structured Gemini, Vertex, AI Studio, and Antigravity usage (bd5ec531)
- perf(usage): optimize stream usage observation and large payload parsing (d5eb4ca1)
- fix(usage): preserve stream failure usage, multipart image params, and provisional zero search counters (97dd3a4a)
- fix(home): restrict websocket access in home mode (a6b4477b)
- fix(usage): preserve output_item.done tool counts and multiline SSE usage (82deffb9)
- Merge pull request #7074 from sususu98/feat/structured-usage-7054 (eabcb1b7)
- Merge pull request #7095: reassemble AI Studio SSE frames (265ca179)
- Merge pull request #7102 from router-for-me/aistudio (d30edd7f)
- fix(logging): prevent deferred request retention on Responses WebSockets (4cb98e3c)
- Merge pull request #7106 from router-for-me/fix/responses-ws-deferred-logging (8dfb45d2)
- fix(auth): write the cooldown state next to the auth file when auth-dir is relative (43068c86)
- fix(openai): keep incomplete streams without [DONE] out of credential cooldown (f013eb66)
- feat(codex): guide recovery when automatic credential renewal becomes impossible (514d09f7)
- fix(translator): translate mid-conversation Claude tool_addition blocks (12d97cfe)
- Merge pull request #7109 from eaxeax/fix/cooldown-state-relative-auth-dir (67beb7a6)
- feat(pluginhost): allow model registrars to publish models for multiple providers (bc81923b)
- fix(gemini): preserve Claude tool-result error semantics (#6838) (81de4b9c)
- fix(antigravity): preserve Claude tool-result error semantics (068fe153)
- fix(codex): expand recognized CPA compaction capsules before forwarding to OpenAI (dbb70621)


#### What's Changed
* Fix WebSocket disconnect test and Devin diagnostics by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7092
* feat(usage): capture structured upstream usage details across Anthropic, xAI, OpenAI/Codex, and Gemini by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7074
* fix(aistudio): reassemble SSE frames across relay chunks by @wozhenbang2004 in https://github.com/router-for-me/CLIProxyAPI/pull/7095
* fix(home): restrict websocket access in home mode by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/7102
* fix(logging): prevent deferred request retention on Responses WebSockets by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/7106
* fix(auth): write the cooldown state next to the auth file when auth-dir is relative by @eaxeax in https://github.com/router-for-me/CLIProxyAPI/pull/7109
* fix(gemini): preserve Claude tool-result error semantics by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/6838

#### New Contributors
* @wozhenbang2004 made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7095
* @eaxeax made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7109

---

### 8.0.47 (2026-10-29)

#### Changelog

- perf(pluginhost): allow frontend auth providers to opt out of request body delivery (e324e481)
- feat(pluginhost): support raw request body byte-range patching (0fe38224)
- docs(readme): add Nia Live Demo to "Who is with us?" (535110e1)
- Merge pull request #7082 from nia-teams-admin/docs/add-nia-live-demo (3f2b8f28)
- fix(responses): use tsc_ item id prefix for Gemini tool search calls (90c447d3)


#### What's Changed
* docs(readme): add Nia Live Demo to "Who is with us?" by @nia-teams-admin in https://github.com/router-for-me/CLIProxyAPI/pull/7082

#### New Contributors
* @nia-teams-admin made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7082

---

### 8.0.46 (2026-10-28)

#### Changelog

- fix(openai/responses): drop response.metadata for non-Codex clients (86d951cd)
- docs(readme): update Kimi model availability (8365de86)
- perf: index web-search support to remove registry write-lock convoy (bc807104)
- perf(executor): decode upstream zstd synchronously and sniff unlabeled bodies lazily (3c948a58)
- docs(readme): add GPT-6.1 Terra (b4cbda59)
- Merge pull request #7057 from lucasnsaraujo/docs/add-ebb (a9e0d48a)
- Merge pull request #6989 from kdcokenny/docs/kimi-k31-availability (f6d29ec7)
- Merge pull request #7023 from JohnsonRan/patch/response-decode-sync-zstd (ba26dea0)
- perf(api): reuse response compression encoders with a smaller zstd window (16c6b4bd)
- test(api): measure open-stream heap with empty encoder pools (12f2cafe)
- Merge pull request #6995: index web-search support (e30575dc)
- feat(registry): index web-search support (58874f3b)
- Merge pull request #7022: reuse response compression encoders (f6ee1e64)
- refactor(api): reuse response compression encoders and add tests (a3e76891)
- Merge pull request #6970 from soulmachine/responses-drop-metadata-non-codex (f7342c38)
- feat(api): filter private metadata in OpenAI responses and improve SSE framing recovery (ae65e26d)
- fix(responses): reject late websocket interrupts after terminal events (9717e325)


#### What's Changed
* docs: add Ebb to "Who is with us?" by @lucasnsaraujo in https://github.com/router-for-me/CLIProxyAPI/pull/7057
* docs(readme): update Kimi and OpenAI model availability by @kdcokenny in https://github.com/router-for-me/CLIProxyAPI/pull/6989
* perf(executor): decode upstream zstd synchronously and sniff unlabeled bodies lazily by @JohnsonRan in https://github.com/router-for-me/CLIProxyAPI/pull/7023
* perf: index web-search support to remove registry write-lock convoy by @leaderlemon in https://github.com/router-for-me/CLIProxyAPI/pull/6995
* perf(api): reuse response compression encoders with a smaller zstd window by @JohnsonRan in https://github.com/router-for-me/CLIProxyAPI/pull/7022
* fix(openai/responses): drop response.metadata for non-Codex clients by @soulmachine in https://github.com/router-for-me/CLIProxyAPI/pull/6970

#### New Contributors
* @lucasnsaraujo made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7057
* @leaderlemon made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6995
* @soulmachine made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6970

---

### 8.0.45 (2026-10-27)

#### Changelog

- perf(thinking): skip document copies when deleting absent fields (6b56ce6c)
- fix(signature): recognize Vertex bare-Tink Gemini thought signatures (58a4d04f)
- fix(signature): scope Vertex bare-Tink replay to Vertex targets (1398f273)
- Merge pull request #6959 from JohnsonRan/patch/thinking-delete-missing-nocopy (c3767123)
- fix(codex): treat turn_rate_limit_exceeded as transient capacity with retry hint (9a35fa12)
- feat(codex): add workspace and cloud agent orchestrator restrictions to client models (19398539)
- fix(signature): pin Vertex bare-Tink recognition to observed key ids (a8582fba)
- Merge pull request #7016 from sususu98/fix/vertex-gemini-thought-signature-7007 (023dd2ad)
- fix(interactions): normalize gemini stream sse lines (be929f07)
- fix(signature): do not reject Antigravity CAQS signatures by channel ID (7517549a)
- Merge pull request #7042 from sususu98/fix/antigravity-caqs-channel-id (437386db)
- fix(models): preserve channel prefix in Gemini model names during prefix registration (908e95d9)
- feat(registry,management): support on-demand v8 management refresh for model catalogs (10417e5b)
- fix(responses-ws): keep downstream websocket open on upstream Codex disconnect (f73e66ac)
- fix(devin): log apply_patch rejection diagnostics and recover complete bare patches (b4f59d70)
- fix(images): apply payload default rules to xAI image endpoints (826bb167)
- feat(translator): support Vertex streaming functionCall partialArgs conversion (64316127)
- fix(codex): retry another credential on early websocket 429 without closing downstream (86a1aabf)
- fix(auth,usage): snapshot request state to avoid reading reused gin.Context (#7056) (b7442218)
- fix(api): prevent incomplete unauthenticated request bodies from exhausting descriptors (477605dc)
- fix(middleware): bound zstd decompression output and window in request logging (ad8bdd3f)


#### What's Changed
* perf(thinking): skip document copies when deleting absent fields by @JohnsonRan in https://github.com/router-for-me/CLIProxyAPI/pull/6959
* fix(signature): recognize and scope Vertex bare-Tink Gemini thought signatures by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7016
* fix(signature): do not reject Antigravity CAQS signatures by channel ID by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7042

#### New Contributors
* @JohnsonRan made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6959

---

### 8.0.44 (2026-10-26)

#### Changelog

- fix(handlers): report cancellation when stream closes before first chunk (712e4970)
- fix(auth,pluginapi,usage): share per-selection ID between Scheduler.Pick and UsageRecord (e5321f53)
- feat(codex): add full-chain compression for Codex upstream and downstream traffic (064e008b)
- fix(translator): map Claude thinking_tokens to reasoning_tokens in OpenAI chat usage (43f5386b)
- fix(codex): restore Codex commentary history via internal thinking signature marker (531721bf)
- fix(api): explicitly allow Authorization in CORS preflight responses (058b803b)
- perf(pluginhost): gate request interceptor body delivery behind schema v7 opt-out (6fe654bf)
- fix(interactions): emit [DONE] sentinel after terminal usage frame in Antigravity and Gemini streams (ede07caf)
- feat(discovery): align TXT schema with draft-su-ai-gateway-discovery-00 (8a982a52)
- chore(config): deprecate discovery advertise-management (b214385c)
- fix(claude): handle forced tool restrictions in claude 5.5 (1d45a5f3)
- fix(antigravity): accept bare content-block lists in interactions input (37bd18b0)
- fix(discovery): resolve split mDNS responses with scoped bounded caches (11e5f67b)
- docs(discovery): describe LAN resolution limits and trust boundaries (999526c7)
- fix(gemini): keep truncated HTTP 200 streams out of credential cooldown and failover (aa4130e6)
- Merge pull request #7010 from sususu98/feat/discovery-ietf-draft (ec81e70a)
- docs(readme): remove APIMart sponsor sections and assets (1f917e77)


#### What's Changed
* feat(discovery): align LAN discovery with IETF AI gateway draft by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7010

---

### 8.0.43 (2026-10-25)

#### Changelog

- fix(lint): resolve go vet lostcancel and static analysis warnings from v8.0.42 (2bb6ac6f)
- fix(codex): bind duplex websocket turns to requested client model after interceptor rewrites (6340fe43)
- fix(openai): isolate duplex turn reauthorization from gin context and enforce bound principal (3e7a21e2)
- fix(watcher): preserve file snapshot binding on persisted auth updates (32dd2c86)
- fix(auth): restore re-logged credentials to rotation after refresh failures (21553509)
- fix(util): defer Gemini array placeholder items until after ref and allOf resolution (b2fda98e)
- fix(plugin): preserve caller scope for replayed Claude OAuth MCP tool aliases (e48d780f)
- fix(xai): deduplicate tools when promoting historical additional_tools (0c61b12c)
- fix(cliproxy): back off home subscriber retries (ce433b37)
- Merge pull request #6969 from router-for-me/home (cf4fc4e7)
- fix(vertex): default credential location to global (ba06ec58)
- fix(translator): preserve finishReason in Codex and OpenAI to Gemini streams (bdde391d)
- feat(devin): aggregate swe-2 lightning UIDs into swe-2-lightning model (3dae075d)
- feat(management): support session-scoped OAuth proxy with per-account persistence (#6973) (27f3abfb)
- fix(openai): report buffered stream error when responses websocket data channel closes first (0fe4cc2c)
- fix(handlers): report stream cancellation when channel closes with canceled context (90fe5b23)
- test(executor): fix race conditions in flaky websocket executor tests (84e83441)
- fix(aistudio): translate every SSE frame of a relay stream chunk (30780351)


#### What's Changed
* fix(cliproxy): back off home subscriber retries by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6969

---

### 8.0.42 (2026-10-24)

#### Changelog

- fix(store,home): handle repository index and packfile corruption and wrap Redis connections with cancelable dialer (0d3ca1d3)
- fix(kimi): share thinking replay across K3.1 Pro variants (ab139b45)
- fix(antigravity): restore non-stream tool signatures and preserve stream call indices (da21f1e5)
- fix(pluginhost): strip credential headers across cross-origin redirects (9d08f0d4)
- fix(pluginhost): translate plugin count_tokens replies as token counts (44d1ddf5)
- feat(pluginabi): carry retry-after metadata from plugin executor errors (35e834da)
- fix(home): close underlying transport synchronously when canceling rebalance RPCs (50147aec)
- fix(pluginhost): apply user payload rules to plugin executor requests (e42eee6e)
- fix(pluginhost): run canonical thinking pipeline before plugin execution (c9af5290)
- fix(logging): prevent path traversal vulnerabilities in request log filenames (179d43dc)

---

### 8.0.41 (2026-10-23)

#### Changelog

- feat(home): add cluster latency telemetry and probing (e45f9426)
- Merge pull request #6903 from router-for-me/home (41a4b9f4)
- fix(codex): map commentary phase messages to thinking blocks in Claude response translator (376015c3)
- fix(claude): preserve tool arguments for implicitly open empty object schemas (e1fb2521)
- fix(signature): sign the first Gemini function call after a text part (e5434f65)
- fix(gemini): populate token limits in Gemini model catalog responses (83cb1b95)
- fix(gemini/vertex): preserve non-content finish reasons and surface prompt blocks (3f5d3a16)
- fix(schema): preserve Gemini $ref sibling constraints (29150a22)
- fix(api): add RESP protocol bounds validation and connection panic recovery (888f2382)
- fix(usage): preserve interactions token semantics when merging stream usage (8289ec4c)


#### What's Changed
* feat(home): add cluster latency telemetry and probing by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6903

---

### 8.0.40 (2026-10-23)

No changelog available.

---

### 8.0.39 (2026-10-22)

#### Changelog

- fix(openai): reauthorize responses websocket turns and support denied status (b9bb031d)
- chore(deps): bump Go version to 1.26.10 and update dependencies (633a294f)
- fix(auth,watcher): preserve runtime cooldowns on file snapshots and re-read stale/persisted auth files (#6844) (d5816d5e)
- perf(util): skip Gemini schema cleanup when building Responses tool reverse identity map (ac3cd66f)
- fix(codex): hold response.metadata during stream bootstrap buffering (9e79552f)
- fix(claude): map model_context_window_exceeded to length in chat completions (c2dfec28)
- fix(claude): map model_context_window_exceeded to incomplete max_output_tokens on responses (d495e24c)
- fix(claude): validate cloak_mode never headers against configured defaults (d2e61d19)
- fix(auth): skip token rejection and refresh for request-scoped 401 rules (4138edb1)
- fix(vertex): use regional endpoint hosts for multi-region us and eu locations (88732ad5)
- fix(translator): keep tool_use-deferred Claude web search open across tool outputs (df860eb9)
- fix(responses): add context_length_exceeded code to Claude prompt overflow stream errors (43f27e3a)
- test(translator): skip replay target model allocation budget test under race detector (ad09c779)
- fix(watcher): preserve file credentials when auth directory is unreadable during full scan (57a12996)
- fix(management): read Handler.cfg under h.mu in OAuth login flows and token save helpers (8bd17955)
- feat(usage): report effective outbound service tier after payload rules (07b5a7a1)
- ci(workflow): bump Go version to 1.26.10 in release pipeline (ceb045a1)

---

### 8.0.38-build.1 (2026-10-22)

底包更新至 9.5.1，无功能变更

---

### 8.0.38 (2026-10-21)

#### Changelog

- feat(home): add planned cluster rebalance handoff (befcba23)
- fix(codex): preserve explicit parallel_tool_calls false in OpenAI translators (99d1698f)
- perf(claude/responses): resolve namespaces from cached state and extract request echo once (f4a2d040)
- Merge pull request #6832 from router-for-me/home (73478825)
- Merge pull request #6834 from router-for-me/perf/responses-echo-claude (9ec96fef)
- perf(codex/chat): cache tool metadata per stream instead of rescanning per tool call (74e7ff60)
- Merge pull request #6836 from router-for-me/perf/codex-chat-tool-cache (2957d100)
- fix(antigravity): preserve tool call replay continuity and caller isolation (80aa2b1d)
- fix(auth): inherit parent credentials for guardian reviews (2f6f2924)
- fix(thinking): preserve standalone Claude effort on Codex requests (009f8d7a)
- docs(readme): add Chenju sponsor to README files (d232ee10)
- fix(codex): use original oauth credentials for alpha search (0db19025)


#### What's Changed
* feat(home): add planned cluster rebalance handoff by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6832
* perf(claude/responses): resolve namespaces from cached state and extract request echo once by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6834
* perf(codex/chat): cache tool metadata per stream instead of rescanning per tool call by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6836

---

### 8.0.37 (2026-10-21)

#### Changelog

- feat(vertex): support per-model and per-credential openapi routing settings (d44f8682)
- feat(pluginhost): add host.auth.models callback for per-credential model lookup (4846a289)
- feat(management): add read-only SIWC credential status endpoint (06fd5b8b)
- fix(claude): drop empty text blocks and skip them during cache_control injection (df07b1e5)
- fix(gemini): preserve usage after terminal stream cancellation (b12db8c3)
- perf(util): precompute Claude tool-name collision policy (80d04e19)
- perf(gemini/claude): map tool names without rescanning the request (83189e5f)
- perf(antigravity/claude): resolve request metadata once per stream (c0e619d5)
- Merge pull request #6828 from router-for-me/perf/translator-stream-metadata (33da6eca)
- perf(codex/claude): cache short-to-original tool name map per stream (95e15777)
- Merge pull request #6829 from router-for-me/perf/codex-claude-tool-names (b2e1ab21)
- perf(openai/responses): extract request echo in one pass and drop request retention (3b153145)
- Merge pull request #6831 from router-for-me/perf/responses-echo-openai (3fa76394)


#### What's Changed
* perf(translator): cache per-stream request metadata and precompute Claude tool-name mapping by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6828
* perf(codex/claude): cache short-to-original tool name map per stream by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6829
* perf(openai/responses): extract request echo in one pass and drop request retention by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6831

---

### 8.0.36 (2026-10-20)

#### Changelog

- fix(openai): preserve tool_use stop reason and omitted-index parallel tool calls for Claude responses (c449529e)
- fix(translator): map completion_tokens_details.reasoning_tokens in non-stream Responses translator (7db0935a)
- docs(readme): add Xcode sponsor and kedaya.ai to Japanese README (3f0cef01)
- fix(usage): parse flat reasoning_tokens dialect in OpenAI-compat usage (SGLang) (e198f3cd)
- fix(meta): measure streaming TTFT on effective token frames (9d463e39)
- feat(executor): pass through downstream User-Agent and set default xAI User-Agent (5026f365)
- fix(executor): count completed reasoning items toward TTFT (f434192a)
- Merge pull request #6794 from router-for-me/fix/meta-stream-ttft (c6447551)
- fix(antigravity): align Hub requests and invalidate versioned model caches (02e9e852)
- Merge pull request #6798 from router-for-me/fix/issue-6619-antigravity-fingerprint (9cd0de36)
- fix(claude): map refusal, context window and pause_turn stop reasons; honor parallel_tool_calls (aadb34f9)
- perf(codex): resolve replay target model once per request in Claude translator (77af3795)
- fix(auth): resolve relative SIWC binding paths against working directory (bb2d8f82)
- fix(watcher): preserve credentials when auth files return read errors during full scan (5fe203d5)
- fix(claude): scope web search result cache by upstream credential (cddc9bb8)
- fix(auth): fence SIWC bind commits against replaced credential accounts (6bbd2cb7)
- fix(openai): allow xAI image vendor aliases to fall back under force-model-prefix (8a3e7622)
- fix(translator): preserve gemini thought signatures across openai chat translations (38706390)
- fix(auth): serialize legacy auth-file uploads with SIWC bind commits (88041f0c)
- fix(claude): treat sdk-ts as native Claude Code and preserve caller headers under cloak_mode never (20c9095c)


#### What's Changed
* fix(meta): measure streaming TTFT on effective token frames by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/6794
* fix(antigravity): align Hub requests and invalidate versioned model caches by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/6798

---

### 8.0.35 (2026-10-20)

#### Changelog

- fix(util): strip readOnly and writeOnly keywords in Gemini schema cleaners (154d5144)
- feat(cache): add Home KV support to Claude web search result cache (ab9c06b4)
- feat(executor): support Codex remote-compaction v2 on Kimi and Meta Responses routes (344e0ef9)
- feat(management): add v8 SIWC credential binding (d50a1995)
- Merge pull request #6786 from router-for-me/feat/siwc-management-bind (c95c3e7b)
- fix(management): reject legacy SIWC callbacks and symlink targets (ae3ee3be)


#### What's Changed
* feat(management): add v8 SIWC credential binding by @LTbinglingfeng in https://github.com/router-for-me/CLIProxyAPI/pull/6786

---

### 8.0.34 (2026-10-19)

#### Changelog

- feat(signature): recognize Meta Muse reasoning envelopes and gate replay by target (7a0b7563)
- fix(translator): carry reasoning thought signatures through Gemini protocol (88ac14f3)
- fix(signature): make Gemini thought-signature carriage SDK-safe and order-preserving (a4660260)
- fix(signature): replay OpenRouter router-suffixed Meta Muse signatures (cc5682c5)
- feat(translator): relay reasoning signatures through the Interactions protocol (772df04b)
- fix(signature): support Meta Muse signatures across third-party Responses providers (674dbe8f)
- feat(signature): support router-suffixed GPT/Grok envelopes and multi-family Responses targets (be9fbd94)
- fix(signature): strip OpenRouter private RouterSuffix on official and non-OpenRouter upstreams (a68c7d8e)
- fix(logging): escape request path in access log to prevent log injection (4337f1f0)
- Merge pull request #6738 from sususu98/feat/meta-muse-signature-replay (29076c98)
- feat(util): inline local schema references in Gemini cleaners and preserve literal values (c558d320)
- feat(management): add safe Modify method for auth records with epoch validation and locking (d69962e4)
- feat(watcher): protect credentials from unindexed deletion during incomplete or in-place file writes (7484a521)
- feat(management): add support for static and plugin model definitions retrieval by channel (50cfd238)
- perf(gemini): pin request payload and resolved tool maps per stream in OpenAI response translators (5de9de9a)
- feat(auth): increase Codex proactive refresh lead to 96 hours and improve rejected token handling (feb63984)
- feat(auth): snapshot plugin scheduler and release host lock during executor registration (1ad175b6)
- feat(auth): enable expired antigravity AI credits negative hint recovery and retry logic (904ec710)
- perf(openai): cache stream preferences and tool maps per stream in Claude response translator (030d17ed)
- feat(cache): add Claude web search result caching and restoration for sessions (9d453bc0)
- fix(api): allow empty home model catalog (07feedf7)
- fix(api): reject home models error envelopes (4d34502f)
- Merge pull request #6765 from router-for-me/models (3bbd1652)
- feat(vertex): support partner and open models via endpoints/openapi route (d9451cb6)
- feat(claude): strip Claude Code identity on API keys with cloak mode never or uncloak (084b9ca7)
- fix(openai): preserve model prefix when routing xAI image requests (45ccd9c3)
- fix(codex): advertise direct tool mode and disable responses lite for non-codex routes (8df4e42a)
- fix(codex): reconcile replayed web_search_call history with tool declarations (e7d4c731)


#### What's Changed
* feat(signature): support Meta Muse & router-suffixed reasoning signatures across Responses, Claude, Gemini, and Interactions by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6738
* fix(api): allow empty home model catalog by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6765

---

### 8.0.33 (2026-10-18)

#### Changelog

- docs(readme): add Hermes CLIProxyAPI Provider to "Who is with us?" (8071ef59)
- Merge pull request #6684 from duu261/docs/readme-hermes-cliproxyapi-provider (cba68c25)
- feat(claude): synthesize adaptive thinking block binding for preserved-thinking models (e13bc9a1)
- feat(claude): support `between_tools` thinking disable type and adaptive fallbacks (ad9e456d)
- feat(gemini): strip unsupported contentMediaType and contentEncoding JSON schema keywords (a43026d7)
- feat(runtime): detect upstream stream truncation across executors and proxy handlers (4f2e5270)
- feat(auth): prevent stale file snapshots from overwriting later persisted state (c4c1d43e)
- test(cliproxy): stabilize antigravity dynamic registration lifecycle tests (16b53545)
- feat(runtime): optimize antigravity schema sanitization to scale linearly with declarations (b8d4e14a)
- feat(meta): filter subscription usage telemetry from SSE streams and responses (3a072298)
- feat(cliproxy): reconcile latest auth state when model registration is superseded mid-flight (f75ea073)
- feat(runtime): narrow Claude per-minute rate-limit cooldown when short Retry-After is present (db1bab01)
- fix(oauth): restore credential exclusion priority (b015f208)
- Refactor authentication exclusion handling and improve model registration (94d1a9a0)
- fix(auth): tolerate invalid excluded models on load (1a28c61e)
- docs(config): clarify oauth excluded-models priority (bb428247)
- fix(auth): preserve plugin excluded models on synthesis (3e309fb4)
- Merge pull request #6691 from router-for-me/fix/oauth-credential-exclusion-priority (69d0ff8e)
- fix(cliproxy): apply excluded models to plugin models (d7005b63)
- fix(pluginhost): bind catalog-only plugin models to credentials (adc436ff)
- feat(pluginhost): preserve auth identity and model registration for relative auth paths (a7608a8a)
- feat(pluginhost): remove max line buffer size limit in stream executor to preserve usage telemetry (66c27581)
- feat(sdk): expose antigravity user agent helpers (acaab599)
- feat(discovery): add robust mDNS host conflict resolution and IP binding fallback (294ed097)
- Merge pull request #6737 from router-for-me/plugins (2422c6b0)


#### What's Changed
* docs(readme): add Hermes CLIProxyAPI Provider to "Who is with us?" by @duu261 in https://github.com/router-for-me/CLIProxyAPI/pull/6684
* fix(oauth): restore credential exclusion priority by @LTbinglingfeng in https://github.com/router-for-me/CLIProxyAPI/pull/6691
* fix(cliproxy): apply excluded models to plugin models by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6737

#### New Contributors
* @duu261 made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6684

---

### 8.0.32 (2026-10-16)

#### Changelog

- feat(docs): add kedaya.ai as a new AI model API relay service provider in README files (e7003d2a)
- feat(claude): clean and normalize Claude tool arguments against original schemas (202b8b8c)
- feat(claude): add session date pin retention to preserve continuity across credential switches (7604d3df)
- test(meta): handle client disconnect gracefully after terminal stream events (088e4457)
- feat(devin): add account-wide quota exhaustion tracking and credential cooldown refresh (b946d54e)
- feat(claude): add automatic thinking block binding and beta policy for preserved-thinking models (911f49cb)

---

### 8.0.31 (2026-10-16)

#### Changelog

- feat(claude): pin validated request body per-stream in OpenAI Responses translation (7a511e4d)
- feat(management): add optimistic concurrency control with ETag and If-Match to v8 config endpoints (fa68946a)
- feat(pluginhost): add content-addressed shadow copies for dynamic library loading (355fd10e)

---

### 8.0.30 (2026-10-15)

#### Changelog

- feat(config): add operator overrides for Claude header defaults and client request ID modes (9db0729f)
- feat(config): add operator overrides for Claude header defaults and client request ID modes (4e8a4125)
- feat(config): add PreapareConfigFileForUpload and seed remote storage with hashed secrets (f9437700)
- feat(executor): drop trailing thought-only model turns in Gemini Vertex requests (ceb4397f)
- fix(watcher): guard management saves against stale config reloads and serialize file updates (1631875b)
- feat(util): strip unsupported discriminator keyword from JSON schemas for Gemini and Antigravity (e9ba5c50)
- fix(xai): drop web_search options the Responses API rejects (bbfd7886)
- feat(claude): map incomplete OpenAI Responses tool status to tool_result is_error (59930ba3)
- Merge pull request #6642 from trukhinyuri/fix/xai-web-search-unsupported-args (207d119d)
- fix(auth): protect active model and credential cooldowns from being cleared by stale in-flight execution successes (35af74f9)
- feat(registry): add gemini-4-argon model definition (74592556)
- feat(vertex): honor full /publishers/ prefix in API-key base-url (2d7f5377)
- Merge pull request #6658 from xyonium/feat/vertex-api-key-full-baseurl (5be2cdab)


#### What's Changed
* fix(xai): drop web_search options the Responses API rejects by @trukhinyuri in https://github.com/router-for-me/CLIProxyAPI/pull/6642
* feat(vertex): honor full /publishers/ prefix in API-key base-url by @xyonium in https://github.com/router-for-me/CLIProxyAPI/pull/6658

#### New Contributors
* @xyonium made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6658

---

### 8.0.29 (2026-10-14)

#### Changelog

- feat(registry): add gemini-3.8 model variants and update test cases (a19a8ecd)
- feat(claude): ensure unique tool use IDs across turns in Gemini response translator (58257007)
- feat(gemini): treat MALFORMED_FUNCTION_CALL as retryable API error in Claude translation (7f2f17d7)
- fix(antigravity): correct token usage calculations for cached tokens in Gemini responses (912a038b)
- feat(registry): add muse-wonder-full-1.0 model variants and update context limits (f9ac397b)
- fix(antigravity): raise fallback client version to 2.23.0 (8fb633c9)
- feat(pluginapi): expose config field defaults (50eaed0d)
- feat(claude): add timeout and retry logic for silent TLS handshakes (345cc9d5)
- refactor(config): move tls-handshake-timeout-seconds to root request configuration (b3dc6c3f)
- feat(antigravity): flatten multi-branch tool unions for Claude model requests (5efe9758)
- fix(cliproxy): add model registration fencings and epoch-checked publications to prevent superseded updates (08e5762a)
- feat(watcher): add file removal tracking and single-file auth snapshotting for robust deletion reconciliation (5fc580b1)

---

### 8.0.28 (2026-10-14)

#### Changelog

- docs(readme): clarify Antigravity Claude 5.5 availability (a4a545c0)
- docs(readme): add Haiku 5.5 and refresh Antigravity availability (02efbf13)
- fix(claude): restore passthrough MCP tools wrapped with their full mcp__ name (02fc76b1)
- Merge pull request #6543 from RoySRose/pr/claude-oauth-wrapped-full-mcp-name (fb87727d)
- docs(readme): note Meta Muse Wonder availability (333f62b3)
- docs(readme): list Muse Wonder models first (50bfc50f)
- feat(registry): add muse-wonder-1.0 models (4c159069)
- feat(registry): add web_search native capability (4f9630df)
- fix(claude): keep prompt cache when tool_search discovers the first deferred tool (97ba1e89)
- Merge pull request #6560 from gracjankubicki/fix/tool-search-deferred-anchor (1fbb06d5)
- fix(server): prevent data races during concurrent config access and reloads (e235fb3d)
- fix(schema): preserve multi-branch anyOf/oneOf unions during schema sanitization (a0fd8448)
- feat(gemini): support client-executed tool_search in OpenAI Responses translator (77fd91e8)
- feat(registry): add claude-haiku-5-5 and remove legacy gemini models (f62d4d28)
- feat(httptransport): add request-scoped HTTP transport decorator (51952a7b)
- docs(readme): note Gemini 4 Argon availability (39ace7e9)
- docs(readme): keep Gemini model list consistent (c96d9c92)
- Merge pull request #6327 from kdcokenny/docs/antigravity-claude-55-availability (f88b6b2f)
- feat(registry): add gemini-4-argon-high model (866d84d0)
- feat(sse): implement CodexSSEScanner for improved event data handling (7795de19)
- feat(registry): add gemini-4-argon model (6143cc11)
- feat(kimi): support schema normalization for namespaced tools and input tool lists (40ce0e01)
- fix(codex): strip out-of-range int64 numeric bounds from tool schemas (57d005fe)
- fix(cliproxy): treat HTTP/2 closed connection errors as transient lifecycle drops (56eee6a4)
- fix(server): prevent data races during concurrent config access and reloads (e230a04b)
- feat(translator): use unique prefixes for fallback item IDs in OpenAI responses stream (b0db5448)
- fix(server): prevent data races during concurrent config access and reloads (81573f04)
- feat(claude): support model-specific default max tokens from registry in OpenAI chat completions (0d18d3b3)


#### What's Changed
* fix(claude): restore passthrough MCP tools wrapped with their full mcp__ name by @RoySRose in https://github.com/router-for-me/CLIProxyAPI/pull/6543
* fix(claude): keep prompt cache when tool_search discovers the first deferred tool by @gracjankubicki in https://github.com/router-for-me/CLIProxyAPI/pull/6560
* docs(readme): update Claude, Gemini and Meta model availability by @kdcokenny in https://github.com/router-for-me/CLIProxyAPI/pull/6327

#### New Contributors
* @RoySRose made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6543

---

### 8.0.27-build.2 (2026-10-13)

Dockerfile + rootfs 变更
（本次构建无代码变更）

---

### 8.0.27-build.1 (2026-10-13)

Dockerfile + rootfs 变更
（本次构建无代码变更）

---

### 8.0.27 (2026-10-13)

#### Changelog

- feat(streaming): support send-keepalive-before-ft option (519d590e)
- Merge pull request #6557 from devbymak/docs/add-sub2api (bf934162)


#### What's Changed
* docs: add sub2api to "Who is with us?" by @devbymak in https://github.com/router-for-me/CLIProxyAPI/pull/6557

#### New Contributors
* @devbymak made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6557

---

### 8.0.26 (2026-10-12)

#### Changelog

- test(claude): pin executor clock in tool_search disabled golden (77cf88b0)
- fix(executor): preserve websocket sessions across reload and auth removal (1e37b52b)
- feat(server): support max-request-body-bytes request body limit (dd7b4334)
- feat(auth): enhance plugin auth handling with multi-auth support and improved state management (fdbc6103)
- Merge pull request #6548 from gracjankubicki/fix/tool-search-golden-date (a27799ec)


#### What's Changed
* test(claude): pin executor clock in tool_search disabled golden by @gracjankubicki in https://github.com/router-for-me/CLIProxyAPI/pull/6548

#### New Contributors
* @gracjankubicki made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6548

---

### 8.0.24-build.1 (2026-10-12)

Dockerfile + rootfs 变更
（本次构建无代码变更）

---

### 8.0.24 (2026-10-12)

#### Changelog

- fix(claude): ignore invalid and null cache control entries in executor (be8c35f2)
- Merge pull request #6499 from seakee/docs/update-cpamp-description (763b41d4)
- fix(codex): shorten over-length tool call IDs in chat completions (b0debb35)
- fix(auth): preserve upstream error cooldown on canceled stream contexts (5dbd92a0)
- fix(devin): do not seed input token estimates for claude streams (cad1b503)
- feat(usage): propagate access provider and native key metadata to usage records (37fe2608)
- fix(antigravity): omit tool_calls from default streaming delta template (dfe0a0ef)
- docs(readme): remove aiberm sponsorship (3de4e248)
- feat(claude): support Codex client tool_search on the Responses API (58c0f6a2)
- fix(claude): address tool_search review findings (a68ad134)
- refactor(registry): use model getters for Devin and Meta (18b6cc8a)
- Merge pull request #6525 from router-for-me/models (d739485d)
- Merge pull request #6520 from gitrvc-hub/fix/claude-responses-tool-search (82912f24)
- feat(executor): add Responses tool_search strip and legacy model helpers (48ad3487)
- feat(claude): emit native deferred tools and tool_reference for tool_search (aeec5e97)
- feat(config): add native-tool-search switch for Claude API keys (ae33711c)
- feat(claude): fall back to pre-tool-search translation on unsupported upstreams (52992659)
- feat(codex): advertise tool search only for natively supported Claude routes (11f04c20)
- fix(claude): drop cache_control from deferred tool_search tools (8eed08ef)
- feat(config): add upstream.claude.tool-search switch (77e3d0d3)
- feat(claude): gate Responses tool_search translation behind upstream.claude.tool-search (956c3da1)
- feat(claude): honor upstream.claude.tool-search in executor, catalog and server (03a3cfec)
- fix(claude): pin upstream.claude.tool-search per request (29bd0415)
- test(claude): cover a reload between tool_search fallback and translation (ce518c9b)
- feat(sponsorship): add Modelflare sponsorship details to README files (0cb6ecfd)
- fix(assets): update Modelflare logo image (f1d4a94e)
- Merge branch 'pr6520' into dev (89006da1)
- fix(gemini): ensure trailing user turn for function response with media (15d2148b)
- fix(antigravity): drop trailing thought-only model turns (a2718314)
- feat(antigravity): persist model capability hints in auth metadata (091ff27f)


#### What's Changed
* docs: update CPA-Manager-Plus description in multilingual READMEs by @seakee in https://github.com/router-for-me/CLIProxyAPI/pull/6499
* refactor(registry): use model getters for Devin and Meta by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6525
* feat(claude): support Codex client tool_search on the Responses API by @gitrvc-hub in https://github.com/router-for-me/CLIProxyAPI/pull/6520

#### New Contributors
* @gitrvc-hub made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6520

---

### 8.0.23-build.1 (2026-10-10)

CI 变更
- feat(addons): 为 6 个 addon 补充图标

---

### 8.0.23 (2026-10-10)

#### Changelog

- fix(codex): preserve resolved upstream model in direct openai image requests (51bde0ff)
- fix(claude): defer stream message delta emission to trailing usage chunk (9a7db8e3)
- fix(claude): preserve mid-conversation effort directives during system insertion (2d8ec73b)
- fix(openai-compat): measure streaming TTFT on effective token frames (f8e4a840)
- fix(auth): skip local filtering for home dispatch (4a8ecf5c)
- Merge pull request #6488 from router-for-me/fix/openai-compat-stream-ttft (84740392)
- fix(executor): normalize and restore non-portable tool call IDs (e9c8769a)
- Merge pull request #6490 from router-for-me/home (9612b7ac)
- fix(xai): reset terminal error on websocket connection configuration (76c87ce9)
- fix(codex): handle late response interrupts on websocket sessions (d318bcc3)


#### What's Changed
* fix(openai-compat): measure streaming TTFT on effective token frames by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6488
* fix(auth): skip local filtering for home dispatch by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6490

<!-- auto-generated by CI -->
