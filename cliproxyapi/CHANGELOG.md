### 8.0.31 (2026-10-16)
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

### 8.0.30 (2026-10-15)
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

### 8.0.29 (2026-10-14)
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

### 8.0.28 (2026-10-14)
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

### 8.0.27-build.2 (2026-10-13)
Dockerfile + rootfs 变更
（本次构建无代码变更）

### 8.0.27-build.1 (2026-10-13)
Dockerfile + rootfs 变更
（本次构建无代码变更）

### 8.0.27 (2026-10-13)
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

### 8.0.26 (2026-10-12)
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

### 8.0.24-build.1 (2026-10-12)
Dockerfile + rootfs 变更
（本次构建无代码变更）

### 8.0.24 (2026-10-12)
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

### 8.0.23-build.1 (2026-10-10)
CI 变更
- feat(addons): 为 6 个 addon 补充图标

### 8.0.23 (2026-10-10)
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