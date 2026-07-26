---
name: addon-troubleshooting
description: Cross-addon known issues, fixes, and lessons learned. Consult when debugging build failures or runtime problems.
applyTo: "**/*.sh **/Dockerfile **/config.yaml **/version.yaml"
---

# Addon Troubleshooting & Lessons Learned

> When you fix an issue, append a new entry to the applicable section below.
> Format: `YYYY-MM-DD: description → solution`.

## Repository-wide
- 2026-07-26: `ha-addon-conventions` skill merged into `create-addon`. AGENTS.md references updated.
- 2026-07-26: New workflow established: `create-addon` (skeleton + empty analysis.yaml) → `plan-addon` (fill data) → push → CI build.

## Build Strategies

### Python (qdtoday)
- C-extensions (pycurl, ddddocr) must compile at runtime, not in builder.
  → `sed -i '/^pkg/d' requirements.txt` in builder; pip install at runtime.

### Node.js (qinglong, uptime-kuma)
- Native modules (sqlite3, cpu-features) need `npm rebuild` at runtime.
  → Don't COPY builder's `node_modules`; run `npm rebuild` in runtime stage.

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
