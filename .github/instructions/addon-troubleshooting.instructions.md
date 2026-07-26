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
