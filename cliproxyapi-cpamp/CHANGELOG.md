### 8.0.48-1.14.5 (2026-10-30)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* Fix WebSocket disconnect test and Devin diagnostics by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7092
* feat(usage): capture structured upstream usage details across Anthropic, xAI, OpenAI/Codex, and Gemini by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7074
* fix(aistudio): reassemble SSE frames across relay chunks by @wozhenbang2004 in https://github.com/router-for-me/CLIProxyAPI/pull/7095
* fix(home): restrict websocket access in home mode by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/7102
* fix(logging): prevent deferred request retention on Responses WebSockets by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/7106
* fix(auth): write the cooldown state next to the auth file when auth-dir is relative by @eaxeax in https://github.com/router-for-me/CLIProxyAPI/pull/7109
* fix(gemini): preserve Claude tool-result error semantics by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/6838

## New Contributors
* @wozhenbang2004 made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7095
* @eaxeax made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7109

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.47...v8.0.48

### 8.0.47-1.14.5 (2026-10-29)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

- perf(pluginhost): allow frontend auth providers to opt out of request body delivery (e324e481)
- feat(pluginhost): support raw request body byte-range patching (0fe38224)
- docs(readme): add Nia Live Demo to "Who is with us?" (535110e1)
- Merge pull request #7082 from nia-teams-admin/docs/add-nia-live-demo (3f2b8f28)
- fix(responses): use tsc_ item id prefix for Gemini tool search calls (90c447d3)


## What's Changed
* docs(readme): add Nia Live Demo to "Who is with us?" by @nia-teams-admin in https://github.com/router-for-me/CLIProxyAPI/pull/7082

## New Contributors
* @nia-teams-admin made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7082

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.46...v8.0.47

### 8.0.46-1.14.5 (2026-10-28)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* docs: add Ebb to "Who is with us?" by @lucasnsaraujo in https://github.com/router-for-me/CLIProxyAPI/pull/7057
* docs(readme): update Kimi and OpenAI model availability by @kdcokenny in https://github.com/router-for-me/CLIProxyAPI/pull/6989
* perf(executor): decode upstream zstd synchronously and sniff unlabeled bodies lazily by @JohnsonRan in https://github.com/router-for-me/CLIProxyAPI/pull/7023
* perf: index web-search support to remove registry write-lock convoy by @leaderlemon in https://github.com/router-for-me/CLIProxyAPI/pull/6995
* perf(api): reuse response compression encoders with a smaller zstd window by @JohnsonRan in https://github.com/router-for-me/CLIProxyAPI/pull/7022
* fix(openai/responses): drop response.metadata for non-Codex clients by @soulmachine in https://github.com/router-for-me/CLIProxyAPI/pull/6970

## New Contributors
* @lucasnsaraujo made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/7057
* @leaderlemon made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6995
* @soulmachine made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6970

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.45...v8.0.46

### 8.0.45-1.14.5 (2026-10-27)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* perf(thinking): skip document copies when deleting absent fields by @JohnsonRan in https://github.com/router-for-me/CLIProxyAPI/pull/6959
* fix(signature): recognize and scope Vertex bare-Tink Gemini thought signatures by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7016
* fix(signature): do not reject Antigravity CAQS signatures by channel ID by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7042

## New Contributors
* @JohnsonRan made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6959

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.44...v8.0.45

### 8.0.44-1.14.5 (2026-10-26)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* feat(discovery): align LAN discovery with IETF AI gateway draft by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/7010


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.43...v8.0.44

### 8.0.43-1.14.5 (2026-10-25)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* fix(cliproxy): back off home subscriber retries by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6969


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.42...v8.0.43

### 8.0.42-1.14.5 (2026-10-24)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.41...v8.0.42

### 8.0.41-1.14.5 (2026-10-23)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* feat(home): add cluster latency telemetry and probing by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6903


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.40...v8.0.41

### 8.0.40-1.14.5 (2026-10-23)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

- fix(usage): propagate claude usage.speed into response service tier (b90190db)
- test(pluginhost,handlers): fix flaky races in plugin load and stream cancel tests (a014ba0e)
- fix(pluginhost): pass decoded request body to frontend auth plugins (13874f1f)
- fix(gemini): enable server-side tool invocations when mixing built-in and function tools (45501610)
- feat(codex): ignore use_siwc and enforce non-SIWC credentials for Codex client requests (d946c4fb)


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.39...v8.0.40

### 8.0.39-1.14.5 (2026-10-22)
No changelog available.

### 8.0.38-1.14.5-build.1 (2026-10-22)
底包更新至 9.5.1，无功能变更

### 8.0.38-1.14.5 (2026-10-21)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* feat(home): add planned cluster rebalance handoff by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6832
* perf(claude/responses): resolve namespaces from cached state and extract request echo once by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6834
* perf(codex/chat): cache tool metadata per stream instead of rescanning per tool call by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6836


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.37...v8.0.38

### 8.0.37-1.14.5 (2026-10-21)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* perf(translator): cache per-stream request metadata and precompute Claude tool-name mapping by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6828
* perf(codex/claude): cache short-to-original tool name map per stream by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6829
* perf(openai/responses): extract request echo in one pass and drop request retention by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6831


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.36...v8.0.37

### 8.0.36-1.14.5 (2026-10-20)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* fix(meta): measure streaming TTFT on effective token frames by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/6794
* fix(antigravity): align Hub requests and invalidate versioned model caches by @GavinKung in https://github.com/router-for-me/CLIProxyAPI/pull/6798


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.35...v8.0.36

### 8.0.35-1.14.5 (2026-10-20)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

- fix(util): strip readOnly and writeOnly keywords in Gemini schema cleaners (154d5144)
- feat(cache): add Home KV support to Claude web search result cache (ab9c06b4)
- feat(executor): support Codex remote-compaction v2 on Kimi and Meta Responses routes (344e0ef9)
- feat(management): add v8 SIWC credential binding (d50a1995)
- Merge pull request #6786 from router-for-me/feat/siwc-management-bind (c95c3e7b)
- fix(management): reject legacy SIWC callbacks and symlink targets (ae3ee3be)


## What's Changed
* feat(management): add v8 SIWC credential binding by @LTbinglingfeng in https://github.com/router-for-me/CLIProxyAPI/pull/6786


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.34...v8.0.35

### 8.0.34-1.14.5 (2026-10-19)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* feat(signature): support Meta Muse & router-suffixed reasoning signatures across Responses, Claude, Gemini, and Interactions by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6738
* fix(api): allow empty home model catalog by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6765


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.33...v8.0.34

### 8.0.33-1.14.5 (2026-10-18)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* docs(readme): add Hermes CLIProxyAPI Provider to "Who is with us?" by @duu261 in https://github.com/router-for-me/CLIProxyAPI/pull/6684
* fix(oauth): restore credential exclusion priority by @LTbinglingfeng in https://github.com/router-for-me/CLIProxyAPI/pull/6691
* fix(cliproxy): apply excluded models to plugin models by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6737

## New Contributors
* @duu261 made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6684

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.32...v8.0.33

### 8.0.32-1.14.5 (2026-10-16)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

- feat(docs): add kedaya.ai as a new AI model API relay service provider in README files (e7003d2a)
- feat(claude): clean and normalize Claude tool arguments against original schemas (202b8b8c)
- feat(claude): add session date pin retention to preserve continuity across credential switches (7604d3df)
- test(meta): handle client disconnect gracefully after terminal stream events (088e4457)
- feat(devin): add account-wide quota exhaustion tracking and credential cooldown refresh (b946d54e)
- feat(claude): add automatic thinking block binding and beta policy for preserved-thinking models (911f49cb)


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.31...v8.0.32

### 8.0.31-1.14.5 (2026-10-16)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

- feat(claude): pin validated request body per-stream in OpenAI Responses translation (7a511e4d)
- feat(management): add optimistic concurrency control with ETag and If-Match to v8 config endpoints (fa68946a)
- feat(pluginhost): add content-addressed shadow copies for dynamic library loading (355fd10e)


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.30...v8.0.31

### 8.0.30-1.14.5 (2026-10-15)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* fix(xai): drop web_search options the Responses API rejects by @trukhinyuri in https://github.com/router-for-me/CLIProxyAPI/pull/6642
* feat(vertex): honor full /publishers/ prefix in API-key base-url by @xyonium in https://github.com/router-for-me/CLIProxyAPI/pull/6658

## New Contributors
* @xyonium made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6658

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.29...v8.0.30

### 8.0.29-1.14.5 (2026-10-14)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.28...v8.0.29

### 8.0.28-1.14.5 (2026-10-14)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* fix(claude): restore passthrough MCP tools wrapped with their full mcp__ name by @RoySRose in https://github.com/router-for-me/CLIProxyAPI/pull/6543
* fix(claude): keep prompt cache when tool_search discovers the first deferred tool by @gracjankubicki in https://github.com/router-for-me/CLIProxyAPI/pull/6560
* docs(readme): update Claude, Gemini and Meta model availability by @kdcokenny in https://github.com/router-for-me/CLIProxyAPI/pull/6327

## New Contributors
* @RoySRose made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6543

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.27...v8.0.28

### 8.0.27-1.14.5-build.2 (2026-10-13)
Dockerfile + rootfs 变更
（本次构建无代码变更）

### 8.0.27-1.14.5-build.1 (2026-10-13)
Dockerfile + rootfs 变更
（本次构建无代码变更）

### 8.0.27-1.14.5 (2026-10-13)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

- feat(streaming): support send-keepalive-before-ft option (519d590e)
- Merge pull request #6557 from devbymak/docs/add-sub2api (bf934162)


## What's Changed
* docs: add sub2api to "Who is with us?" by @devbymak in https://github.com/router-for-me/CLIProxyAPI/pull/6557

## New Contributors
* @devbymak made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6557

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.26...v8.0.27

### 8.0.26-1.14.5 (2026-10-12)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

- test(claude): pin executor clock in tool_search disabled golden (77cf88b0)
- fix(executor): preserve websocket sessions across reload and auth removal (1e37b52b)
- feat(server): support max-request-body-bytes request body limit (dd7b4334)
- feat(auth): enhance plugin auth handling with multi-auth support and improved state management (fdbc6103)
- Merge pull request #6548 from gracjankubicki/fix/tool-search-golden-date (a27799ec)


## What's Changed
* test(claude): pin executor clock in tool_search disabled golden by @gracjankubicki in https://github.com/router-for-me/CLIProxyAPI/pull/6548

## New Contributors
* @gracjankubicki made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6548

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.25...v8.0.26

### 8.0.24-1.14.5-build.1 (2026-10-12)
Dockerfile + rootfs 变更
（本次构建无代码变更）

### 8.0.24-1.14.5 (2026-10-12)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* docs: update CPA-Manager-Plus description in multilingual READMEs by @seakee in https://github.com/router-for-me/CLIProxyAPI/pull/6499
* refactor(registry): use model getters for Devin and Meta by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6525
* feat(claude): support Codex client tool_search on the Responses API by @gitrvc-hub in https://github.com/router-for-me/CLIProxyAPI/pull/6520

## New Contributors
* @gitrvc-hub made their first contribution in https://github.com/router-for-me/CLIProxyAPI/pull/6520

**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.23...v8.0.24

### 8.0.23-1.14.5-build.1 (2026-10-10)
CI 变更
- feat(addons): 为 6 个 addon 补充图标

### 8.0.23-1.14.5 (2026-10-10)
<!-- cliproxyapi-linux-release-assets:start -->
## Linux release assets

- `CLIProxyAPI_<version>_linux_<arch>.tar.gz` is the default Linux build. It supports dynamic library plugins and is built against a GLIBC 2.17 baseline.
- `CLIProxyAPI_<version>_linux_<arch>_no-plugin.tar.gz` is the portable Linux build for musl-based or older systems such as OpenWrt. It does not support dynamic library plugins.

## FreeBSD release assets

- `CLIProxyAPI_<version>_freebsd_aarch64_no-plugin.tar.gz` is the FreeBSD arm64 build. It is built without CGO and does not support dynamic library plugins.

<!-- cliproxyapi-linux-release-assets:end -->

## Changelog

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


## What's Changed
* fix(openai-compat): measure streaming TTFT on effective token frames by @sususu98 in https://github.com/router-for-me/CLIProxyAPI/pull/6488
* fix(auth): skip local filtering for home dispatch by @hkfires in https://github.com/router-for-me/CLIProxyAPI/pull/6490


**Full Changelog**: https://github.com/router-for-me/CLIProxyAPI/compare/v8.0.22...v8.0.23

<!-- auto-generated by CI -->