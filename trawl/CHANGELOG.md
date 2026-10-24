### 1.9.3 (2026-10-24)
## Highlights

- **Readable UTF-8 fragments:** preserve charset-less HTML across the native API, FlareSolverr API, MCP and proxy, while keeping JavaScript-rendered content and solved challenges intact.
- **Safer Cloudflare interaction:** stop pending click and keyboard fallbacks after an interstitial clears.
- **Patched runtimes:** Bun 1.4.4 and Node.js build tooling 26.12.1 include the upstream Brotli security fixes.
- Compatible dependency updates, Nginx 1.31.8 for web/docs, and the TRAWL logo favicon.

## Major changes

- c10eaab preserves UTF-8 fragments without replacing rendered results with stale source (#251, #252).
- 80a6f72 retains adjacent fragment text in MCP outputs; 675c393 stops delayed Cloudflare clicks after clearance.
- 8ec4e7d updates Bun to 1.4.4; 94aa3a4 updates Node.js build tooling to 26.12.1.
- 0098977 updates web/docs favicons. 5fa105f refreshes compatible workspace and transitive dependencies, Docker images and versioned examples.

Thanks to @everpcpc and @Project516 for their contributions.

**Full changelog:** https://github.com/germondai/trawl/compare/v1.9.2...v1.9.3

### 1.9.2 (2026-10-20)
## Highlights

- **Prometheus metrics:** monitor main browser pool utilization, waiting requests and checkout counters through `GET /metrics`.
- **Opt-in graceful shutdown:** let accepted HTTP requests finish before sessions and browsers close. The default remains immediate shutdown.
- **Short document support:** use `allowShortContent` in native scraping for browser documents under 100 characters, while retaining challenge and network-error checks.
- **MHTML compatibility:** export folded archive headers that work with readers expecting Blink-style boundaries.

## Major changes

- bf0b439 fixes MHTML Content-Type header folding (#243).
- 1aa41ed adds `allowShortContent`; c38f449 retains rejection of short error pages (#246, #247).
- 5a9d9bf adds Prometheus pool metrics; cea549c excludes failed checkout waits and 81d8237 exports cumulative wait in seconds (#244, #248).
- 75790ef adds shutdown draining; c4af8ba coordinates HTTP, named sessions and browser signal handling within one drain window (#245, #249).
- b4d96b4 forwards the drain setting in all Compose variants; 6707315 refreshes compatible build dependencies and prepares v1.9.2.

Thanks to @emandel2630 for the contributions.

**Full changelog:** https://github.com/germondai/trawl/compare/v1.9.1...v1.9.2

### 1.9.1 (2026-10-19)
No changelog available.

### 1.9.0 (2026-10-19)
## Highlights

- **Faster repeat requests:** reuse browser-verified Cloudflare and Anubis clearance over HTTP without another browser navigation. Every request still fetches fresh content, with browser fallback when clearance is rejected.
- **Less unnecessary browser work:** reduce repeated challenge checks, overlap supported widget verification with page settling, and improve Cloudflare, Turnstile, GeeTest and Anubis flows.
- **More reliable page delivery:** preserve delayed JavaScript content, avoid passive reCAPTCHA v3 false positives, and keep cached sessions bound to their proxy.
- **More control:** configure the default scrape deadline, choose whether to solve embedded widgets, or opt into Firefox TLS/HTTP2 impersonation while keeping Bun fetch as the default.
- **Refreshed release stack:** compatible dependency updates, updated standard and baseline images, and clearer deployment and performance documentation.

## Major changes

- fc1aa5f and e11ad5a add automatic Cloudflare and Anubis HTTP clearance reuse. 03eb092 extends replay to other direct sessions only for a verified URL and matching document content, and avoids repeated HTTP attempts for known JavaScript shells (#222, #229).
- 68b1701, 6d02547 and ba420c7 reduce unnecessary challenge waits, overlap widget verification with page settling and streamline GeeTest drags. f1f34bc preserves delayed JavaScript content (#222).
- e100e2d and 8519904 separate page delivery from optional embedded CAPTCHA completion. FlareSolverr-compatible /v1 requests prioritize page content; native and MCP scraping expose solveEmbeddedCaptchas (#222).
- 7c93b84 and 9c9ecb2 bound Cloudflare recovery and retain time for residential fallback. db12f68 recognizes Turnstile tokens consumed during widget removal (#219, #221).
- a2023ea preserves proxy identity in cached sessions, 5996492 honors client Accept-Encoding, and 679b66b fixes MITM certificate serial encoding (#212, #218, #217).
- 868ffc6 captures supported Cloudflare Challenge Page parameters for the optional 2Captcha fallback without a site profile. Paid-provider acceptance remains unverified (#220).
- d5a426c adds SCRAPE_MAX_TIMEOUT_MS across scraping entry points. ed08d4f adds opt-in TIER1_TRANSPORT=wreq; Bun fetch remains the default (#214, #217, #231).

d63a6ea updates Bun to 1.4.3, camoufox-js to 0.13.0 and Nuxt to 4.6.2. Node.js is used for web/docs builds; the scraper service remains on Bun. Existing benchmark reports retain their original measurement date and build provenance.

Thanks to @HenrINC and @DuLerWeil for their contributions.

**Full changelog:** https://github.com/germondai/trawl/compare/v1.8.0...v1.9.0

### 1.8.0-build.1 (2026-10-10)
CI 变更
- feat(addons): 为 6 个 addon 补充图标

### 1.8.0 (2026-10-10)
## Highlights

- **Browser sessions:** keep cookies, localStorage and sessionStorage across requests, with shared session support for the native API, MCP and FlareSolverr-compatible clients.
- **Better resource management:** bounded request deadlines, cancellation cleanup, browser crash recovery and memory-aware recycling. Optional controls let smaller deployments disable ad blocking, adjust advertised browser concurrency or retire idle browsers.
- **More challenge support:** native Anubis and CAP handling, improvements to Cloudflare and other CAPTCHA flows, and an optional 2Captcha fallback.
- **Faster browser flows:** avoid unnecessary network-idle waits when a content selector is provided, while preserving default JavaScript settling.
- **Updated release stack:** refresh compatible dependencies and build web/docs images from the monorepo lockfile.

## Major changes

- ca4bb00 and 4cabc71 add isolated browser sessions and FlareSolverr session compatibility (#188, #207).
- efda2f0 improves resource cleanup, deadlines, browser recovery and challenge solvers; 35d99ba moves dashboard history aggregation into SQLite (#191, #205).
- 4de58d5 improves Anubis detection and bounded browser recovery (#189, #197). a156b9c verifies every visible CAP widget.
- 33aabee adds optional 2Captcha fallback and site-specific task profiles (#27, #206). Real paid-service acceptance remains unverified.
- b04ea4d shares browser execution and preserves content readiness; db33272 bounds shutdown after unexpected process errors (#209).
- 7a86a7d adds opt-in meta refresh following; fbdf69c preserves raw text responses; 22a8475 validates custom Firefox preferences (#192, #201, #203).
- 8e8bebb updates compatible dependencies, 57e0d9d fixes web/docs Docker builds, and 2f1b8b6 prepares v1.8.0 (#210).

Thanks to @StLyn4, @elazar and @yuxi-liu-wired for their contributions.

**Full changelog:** https://github.com/germondai/trawl/compare/v1.7.0...v1.8.0

<!-- auto-generated by CI -->