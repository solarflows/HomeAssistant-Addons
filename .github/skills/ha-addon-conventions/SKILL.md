---
name: ha-addon-conventions
description: HA addon dev conventions. Use for config.yaml schemas, S6 run scripts, translations, build strategies, CI logic.
---

# HA Addon Conventions

## Base Rules
- **Base image**: `ghcr.io/hassio-addons/debian-base:9.3.0` or `alpine-base`, built-in S6 overlay
- **Filesystem**: `/config` (persistent/backup), `/data` (internal), `/share` (cross-addon), `/ssl` (certs)
- **Dockerfile**: `{addon-slug}/Dockerfile` (same dir as config.yaml)
- **Version**: `{addon-slug}/version.yaml` per addon

## config.yaml
```yaml
init: false            # debian-base has built-in S6
boot: manual
startup: application
ingress: true
ingress_port: 8923     # app port
arch: [aarch64, amd64]
map: [config:rw]       # minimum; add ssl:ro, share:rw as needed
```
- No `codenotary` (deprecated). No `panel_icon` → use `icon`.
- `tmpfs: true` (bool), not array syntax.
- No `VOLUME ["/config","/data"]` — Supervisor auto-injects.
- `environment` block: only app-specific vars. No `TZ` (S6 `base-app-timezone` handles it).

## Schema types (source: supervisor `apps/options.py`)
| Type | Usage |
|------|-------|
| `bool` / `bool?` | Toggle |
| `str` / `str?` | Text; `""` is valid for optional |
| `int` / `int?` | Number |
| `password` / `password?` | Password field |
| `email` | Email validation |
| `url` / `url?` | URL (not `str`) |
| `match(^.+$)` | Regex; empty string fails `.+` |
| `list(a\|b\|c)` | Dropdown |
- Suffix `?` → optional, user can leave empty.
- `options` values must be raw types (str/bool/int), not objects. Descriptions go in `translations/`.

## S6 overlay
```bash
# rootfs/etc/cont-init.d/00-init.sh
#!/usr/bin/with-contenv bashio
mkdir -p /config/<app> && ln -sf /config/<app> /app/data

# rootfs/etc/s6-overlay/s6-rc.d/<name>/run  (health-check + wait loop)
#!/usr/bin/with-contenv bashio
APP_PID=
trap 'kill $APP_PID 2>/dev/null; exit 0' TERM INT
/app &
APP_PID=$!
for i in $(seq 1 120); do
    if curl -sf http://127.0.0.1:PORT/ 2>/dev/null; then
        wait $APP_PID; exit $?
    fi
    sleep 1
done
kill $APP_PID 2>/dev/null; exit 1

# rootfs/etc/s6-overlay/s6-rc.d/<name>/type
longrun
```
- After `COPY rootfs /`: `RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run`
- ⚠️ No `notification-fd` / `timeout-up` — debian-base:9.3.0 S6 is too old; unknown files cause service to silently skip.
- **S6 Stage 2 Hook**: debian-base uses legacy-services for user-defined services under `/etc/s6-overlay/s6-rc.d/`.
  - s6-rc reads the `/run/service/` tree at boot and creates `down` files for non-builtin services **before** cont-init runs.
  - Without intervention, user services start in "down" state and `s6-supervise` never launches them.
  - **Solution**: `S6_STAGE2_HOOK` env + hook script (after cont-init, before service start):
    ```sh
    # Dockerfile
    ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh
    RUN chmod a+x ... /etc/s6-overlay/scripts/stage2_hook.sh
    ```
    Hook script: remove `down` + `s6-svc -u` for each user service (skip `s6-*` builtins).
    Ref: tailscale addon pattern.
  - **Do NOT** use cont-init `rm -f down` / `s6-svc -o` workarounds — they race with s6 startup.

## translations/
```yaml
# en.yaml
---
configuration:
  OPT_KEY:
    name: Display Name
    description: >-
      Multi-line description.
network:
  8080/tcp: Web UI
```
- Each addon needs `translations/en.yaml` + `translations/zh-Hans.yaml`.

## version.yaml
```yaml
version: "2.4.0"
source: github           # or github_tags
repo: owner/repo
build_args:
  APP_VERSION: "${version}"   # key must match Dockerfile ARG
changelog:
  source: release_body   # or file (URL) or tag_file (GitHub Contents API)
  mode: prepend          # or replace
tracking:
  base_tag: "9.3.0"      # omit for non-debian-base addons
  file_sha: ""           # empty = new addon, CI triggers first build
  build_num: 0
```
- No `tag_prefix` — CI strips `v` uniformly.
- `version` = single source of truth (cleaned, no `v` prefix).

## Build Strategies
| Strategy | Example addons | Pattern |
|----------|---------------|---------|
| Multi-stage source | qinglong/qdtoday/baihu/uptime-kuma | `FROM lang:ver AS builder` → `FROM debian-base` COPY |
| Binary download | lucky/filebrowser | `FROM debian-base` + `curl` release binary |
| Upstream image ref | flaresolverr | `FROM upstream/img` + ENTRYPOINT wrapper |
| Release JAR | alist-tvbox/standalone | `FROM debian-base` + JAR download |

## Builder → Runtime Compatibility
debian-base:9.3.0 runtime: Python 3.13, Node 22 (Trixie apt). **Builder should use same base image** (`FROM ${BUILD_FROM}`) whenever possible.

| Scenario | Fix |
|----------|-----|
| Python pip packages with C extensions (pycurl, ddddocr) | **Compile at runtime, not in builder** — skip in builder (`sed -i '/^pkg/d' requirements.txt`) |
| Node.js native modules (sqlite3, cpu-features) | **npm rebuild at runtime** — don't reuse builder's node_modules |
| Go `CGO_ENABLED=0` | ✅ Static binary, no libc concern |
| Pure Python/JS/Java | ✅ Safe to COPY from any builder |

## CI (Version_Check + Release)
- **Version_Check** triggers: cron 6h / push (path: Dockerfile,rootfs/,version.yaml,config.yaml,workflows) / workflow_dispatch
- Detect priority: version_changed > base_updated > file_changed > force_rebuild
- File trigger sub-types: `dockerfile` / `rootfs` / `config` / `workflow`
- Matrix (3 fields only): `addon` / `reason` / `new_ver`
- Release computes `build_version`/`build_num`/`base_tag` from version.yaml at runtime
- debian-base API: `hassio-addons/addon-debian-base/releases/latest` → strip `v` before compare
- Commits: independent per-addon, 3x retry pull+push. Tag for changelog: `v${VERSION}` (fallback: `${VERSION}`)
