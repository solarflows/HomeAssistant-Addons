---
name: addon-troubleshooting
description: "HomeAssistant-Addons 的 Dockerfile、Shell、config.yaml、version.yaml 构建或运行故障经验。"
applyTo: ["**/*.sh", "**/Dockerfile", "**/config.yaml", "**/version.yaml"]
---

# Addon Troubleshooting & Lessons Learned

> When you fix an issue, append a new entry to the applicable section below.
> Format: `YYYY-MM-DD: description → solution`.

## Repository-wide
- 2026-07-26: `ha-addon-conventions` skill merged into `create-addon`. AGENTS.md references updated.
- 2026-07-26: New workflow established: `create-addon` (skeleton + empty analysis.yaml) → `plan-addon` (fill data) → push → CI build.
- 2026-09-08: `alist-tvbox-standalone` CI failed on `ADD https://.../alist-tvbox-1.0.jar` with `connection reset by peer`. Bare `ADD` has no retry. Use `curl --retry` in Dockerfiles; Version Check / Release retry GitHub API, image build/push, and git push with backoff.
- 2026-10-10: A new addon's first build left `config.yaml.version` at `0.0.0-build.0` and did not generate `CHANGELOG.md`. Root cause: Version_Check emits a **composite** reason for a brand-new addon (`version_changed,dockerfile,rootfs`), while Release.yml matched it with a **prefix** `case "$REASON" in dockerfile*|...)` — a value starting with `version_changed,` matched neither that nor the exact `REASON = "version_changed"`, so both write branches were skipped. **Fixed**: Release.yml now splits `REASON` on commas up front and derives `IS_VERSION_CHANGE` / `IS_FILE_TRIGGER` flags (never prefix-match a composite reason). Note: fixing it changed `Release.yml`, which triggers a **full rebuild of every addon**.
- 2026-10-10: Follow-up regression from the fix above — `config.yaml.version` and `CHANGELOG.md` were *still* not written for the 5 new addons, while the 9 existing ones were fine. Cause: **each GitHub Actions step is a separate shell**, so a plain shell variable (`IS_VERSION_CHANGE`) set in the `Prepare environment` step is **empty** in the later `Prepare config updates & commit` step — every check depending on it silently evaluated false. `IS_FILE_TRIGGER` only worked because it was already exported. **Rule**: any flag a later step reads must be exported via `echo "key=$val" >> $GITHUB_OUTPUT` and read back as `KEY="${{ steps.prep.outputs.key || 'false' }}"`. Symptom to recognize: a CI commit touching only `version.yaml` (no `config.yaml` / `CHANGELOG.md`).
- 2026-10-10: "CI 变更" CHANGELOG entries listed up to 9 unrelated historical commits (`chore(<addon>): upstream X → Y`). Cause: the `COMMIT_MSG` fallback used `git log -10 -- <addon>/`, which pulls that directory's recent history regardless of relevance, and the filter only excluded `^- build(`. **Fixed**: both `Version_Check.yml` and `Release.yml` now derive commits strictly from `file_sha..HEAD` (no `-10` fallback), and the filter also excludes `chore(<addon>): upstream `. When nothing remains the entry reads `（本次构建无代码变更）`. Historical noise was cleaned from the 9 affected addons.
- 2026-10-10: Addon icons are plain `icon.png` / `logo.png` files in the addon directory (HA reads them from the repo); `config.yaml` may additionally set an `icon: mdi:...` fallback. New addons shipped without them showed a grey puzzle placeholder in the store. Note these files are **not** in the CI trigger paths (`**/Dockerfile`, `**/rootfs/**`), so adding icons does not trigger a rebuild.

## Build Strategies

### Python (qdtoday)
- C-extensions (pycurl, ddddocr) must compile at runtime, not in builder.
  → `sed -i '/^pkg/d' requirements.txt` in builder; pip install at runtime.
- A `pip --prefix` builder must use the same Python minor version as the runtime. Otherwise packages land under a versioned `site-packages` directory that the runtime does not scan.

### Node.js (qinglong, uptime-kuma)
- Native modules (sqlite3, cpu-features) need `npm rebuild` at runtime.
  → Don't COPY builder's `node_modules`; run `npm rebuild` in runtime stage.
- Builder and runtime stages that reuse native modules must use the same libc family. Never copy Alpine/musl `node_modules` into a Debian/glibc runtime; reinstall or rebuild them in the runtime stage.

### Go (baihu-panel, lucky)
- `CGO_ENABLED=0` → static binary, no libc concerns. Safe to COPY from any builder.

### Java (alist-tvbox, alist-tvbox-standalone)
- Spring Boot `additional-location` silently skips missing dirs (no crash, but config is ignored).
  → Must `mkdir -p` the target dir in 00-init.sh.

## Upstream Path Adaptations

| Addon | Hardcoded Path | Fix |
|-------|---------------|-----|
| alist-tvbox | `/jre/bin/java`, `/app_version`, `/docker.version` | Dockerfile symlinks + files |
| alist-tvbox | `/opt/atv/BOOT-INF/lib/h2-*.jar` | `find + ln -sf` from snapshot-dependencies |
| alist-tvbox | `/h2-2.1.214.jar` | `curl` download in Dockerfile |
| alist-tvbox | `/var/lib/data.zip` | `COPY --from=alist-source` |
| alist-tvbox | `/alist.json` | `COPY --from=source /src/config/alist.json` |
| alist-tvbox-standalone | Spring `file:/data/atv/config/` | `mkdir -p` in 00-init.sh |
| baihu-panel | `/app/data`, `/app/configs`, `/app/envs` | Symlinks in 00-init.sh |
| qinglong | `/ql/` | Symlink `/ql → /config/qinglong` |
| qdtoday | `/usr/src/app/config` | Symlink in 00-init.sh |
| uptime-kuma | `/opt/uptime-kuma/data` | Symlink in 00-init.sh |

## S6 Pitfalls
- **No `notification-fd` / `timeout-up`**: debian-base:9.3.0 S6 is too old. Unknown files cause service to silently skip.
- **S6 Stage 2 Hook required**: `S6_STAGE2_HOOK` env + hook script to remove `down` files. Do NOT use cont-init `rm -f down` workarounds — they race with s6 startup.
- **`set -e` in upstream scripts**: any missing file kills the entire init process.
- **chmod after COPY rootfs**: always run `RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run`.

## Chromium Addons
- Grant `SYS_ADMIN` or `IPC_LOCK` only when the addon's documented Chromium runtime requires it; do not apply these capabilities to unrelated addons.
- Chromium 140+ wrappers used by FlareSolverr require Bash when they contain Bash-only conditionals. Keep the repository's entrypoint compatibility patch aligned with the upstream wrapper.

## Upstream Integration Principles (alist-tvbox)
- **00-init.sh = upstream entrypoint.sh init portion** (minus `exec java`). Do NOT reimplement upstream's init_directories/setup_symlinks logic.
- **S6 longrun = upstream entrypoint.sh service portion** (httpd + nginx + exec java).
- **Do NOT bypass upstream's is_initialized logic** with custom marker files (h2.version.txt hack, .ha_init_done, etc.). Upstream relies on container restart to recover from failed first init — S6 oneshot has the same behavior.
- **Audit ALL upstream hardcoded paths**: `/opt/atv/BOOT-INF/lib/`, `/jre/bin/java`, `/h2-*.jar`, `/var/lib/data.zip`, `/alist.json`, `/app_version` — create corresponding symlinks or COPY in Dockerfile.

## HAOS-Specific Adaptations (alist-tvbox)
- `/opt/alist/data` → lost on restart, needs `ln -sf /data/alist /opt/alist/data` (persistent volume)
- `/entrypoint.sh` → symlink for inDocker detection
- `MEM_OPT` → export in 00-init.sh, inherited by S6 longrun via with-contenv

## Addon Development Workflow
1. **Upstream Analysis**: Document upstream architecture in `addon/DOCS.md` BEFORE building (Docker image, scripts, services, data layout, init flow, env vars, ports).
2. **Build Addon**: Use DOCS.md as blueprint for Dockerfile + rootfs scripts. Identify gaps: base image differences, missing tools, path mismatches.
3. **Key Patterns**:
   - HAOS mounts `/data/` as persistent volume (upstream Docker does NOT)
   - Resource files must go to `/` (image layer), not `/data/` (volume)
   - Debian vs Alpine: nginx paths, java paths, busybox-extras missing
