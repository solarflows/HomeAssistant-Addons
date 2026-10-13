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