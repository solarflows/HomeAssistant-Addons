### 2.4.0 (2026-07-22)
### 🆕 New Features
- #7434 feat(notification): add EgoSMS SMS provider for Uganda (Thanks @kristianinc @cursoragent)
- #7420 feat: Add incidents to RSS (Thanks @dj-tuxis)
- #7365 feat: Add VKTeams bot notification provider (Thanks @aleshasam)

### 💇‍♀️ Improvements
- #7433 feat: add optional token field for gamedig monitors (Thanks @aminoacidity)
- #7415 feat: Adding bearer token  (Thanks @aminoacidity @nyeswant)
- #7431 fix: Add bearer token support to WebSocket upgrade monitor (Thanks @aminoacidity @nyeswant)
- #7373 fix: update link to documentation about API keys (Thanks @eleanordoesntcode)

### 🐞 Bug Fixes
- ~#7453 fix(docker-only): add Let's Encrypt Gen Y root certificates~ (Please ignore this change)
- #7451 fix: handling npm 11.16.0 
- #7351 fix: NTLM monitor over plain HTTP fails with 400 Bad Request (Thanks @karzac)

### ⬆️ Security Fixes
-  (Admin only/Authenticated only) Fix: LiquidJS is Vulnerable to Remote Code Execution, a vulnerability from an upstream dependency. In Uptime Kuma, LiquidJS should be used in notification template. (https://github.com/advisories/GHSA-gf2q-c269-pqgc)

### 🦎 Translation Contributions
- #7366 #7353 chore: Translations Update from Weblate (Thanks @aindriu80 @Aluisio @andibing @AnnAngela @Arden-Ahmad @bartoostveen @cyril59310 @dodog @Gringit @helakostain @ivanbratovic @Jumala9163 @Kf637 @master3395 @MrEddX @OnyxOracle @PolarniMeda @samsilveira @toniv90 @ttymayor @Virenbar @xuantan97)

### Others
- #7432 chore: Implement dev data directory handling for non-master branches 
- #7390 fix: normalize hidden log level lookup (Thanks @aqilaziz)

