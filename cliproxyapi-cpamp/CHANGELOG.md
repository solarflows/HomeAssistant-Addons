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