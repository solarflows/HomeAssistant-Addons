# HomeAssistant-Addons

> Owner: solarflows | Maintainer: Husky
> Repo definition: `repository.yaml`

## Addons (8)

| slug | upstream | strategy | port | S6 |
|---|---|---|---|---|
| alist-tvbox | power721/alist-tvbox | JAR + haroldli/alist | 4567, 80→5344 | yes |
| alist-tvbox-standalone | same | JAR (no alist) | 4567, 5244 | yes |
| lucky | gdy666/lucky | binary download | 16601 (host) | yes |
| flaresolverr | FlareSolverr/FlareSolverr | upstream image | 8191, 8192 | no |
| qdtoday | qd-today/qd | Python src build | 8923 | yes |
| qinglong | whyour/qinglong | Node.js src build | 5700 | yes |
| baihu-panel | engigu/baihu-panel | Go src build | 8052 | yes |
| filebrowser-quantum | gtsteffaniak/filebrowser | upstream image | 8080 | no |

### Version prefixes

| slug | tag_prefix | example | config version |
|---|---|---|---|
| alist-tvbox | "" | 1.24.0 | 1.24.0 |
| lucky | "v" | v2.27.2 | 2.27.2 |
| flaresolverr | "v" | v3.5.0 | 3.5.0 |
| qdtoday | "" | 20250803 | 20250803 |
| qinglong | "v" | v2.21.0 | 2.21.0 |
| baihu-panel | "v" | v1.1.21 | 1.1.21 |
| filebrowser-quantum | "v" + transform | v1.4.0-stable | 1.4.0-stable |

## Dev Guide

### Base rules
- **Base image**: `ghcr.io/hassio-addons/debian-base:9.3.0` or `alpine-base`, built-in S6 overlay
- **Filesystem**: `/config` (persistent/backup), `/data` (internal), `/share` (cross-addon), `/ssl` (certs)
- **Dockerfile**: `{addon-slug}/Dockerfile` (same dir as config.yaml)
- **Version**: `{addon-slug}/version.yaml` per addon

### config.yaml
- `init: false` — debian-base has built-in S6, Supervisor skips injection
- `boot: manual` — user starts manually
- `startup: application` — required
- `ingress: true` + `ingress_port` — HA injects `X-Ingress-Path` header
- `map: [config:rw]` — persistent config
- `arch: [aarch64, amd64]` — default dual-arch

### S6 overlay (debian-base addons only)
- Use S6 longrun; **never override `/init` with ENTRYPOINT**
- `cont-init.d/00-init.sh` — init (dirs, symlinks, data migration)
- `s6-rc.d/<service>/type` — content: `longrun`
- `s6-rc.d/<service>/run` — `#!/usr/bin/with-contenv bashio`, ends with `exec <app>` (must block foreground)
- **rootfs can't be empty**: Docker COPY fails on empty dir → add `.gitkeep`
- **bashio**: `bashio::config`, `bashio::log`, `bashio::addon.ingress_entry`
- **Exception**: non-debian-base images (flaresolverr, filebrowser-quantum) use ENTRYPOINT wrapper

### Build strategies

| Strategy | When | Example |
|---|---|---|
| Multi-stage source build | OSS with build toolchain | qinglong (Node), qdtoday (Python), baihu-panel (Go) |
| Upstream image ref | Complex build, official image exists | flaresolverr, filebrowser-quantum |
| HA base + binary | Closed-source or simple binary | lucky |
| HA base + release JAR | Java/Spring Boot | alist-tvbox, alist-tvbox-standalone |

### AList ecosystem
- `alist-org/alist` was compromised post-acquisition (telemetry) — **do not use**
- `power721/PowerList` = clean fork (Anti Trust Crisis, AGPL-3.0)
- `haroldli/alist` = DockerHub clean image (PowerList CI build), binary at `/opt/alist/alist`
- `haroldli/alist-base` = `haroldli/alist` + JRE + Spring Boot + atv-cli
- alist-tvbox: `config.json` generated at runtime by `init-alist.sh` from `/alist.json` (VOLUME dir, not pre-baked)
- Upstream `init-alist.sh` line 39: `if [ -f /opt/alist/alist ]; then` — confirms path

### alexbelgium/hassio-addons reference
- Largest community HA addon collection
- Uses `ha_automodules.sh` / `ha_autoapps.sh` for deps
- Uses `bashio-standalone.sh` for bashio support
- Dockerfile pattern: `FROM <upstream> + COPY rootfs/ + ENTRYPOINT [/ha_entrypoint.sh]`

## New Addon Template

### Dir structure
```
<addon-slug>/
├── config.yaml
├── Dockerfile
├── version.yaml
├── rootfs/etc/cont-init.d/00-init.sh
├── README.md
├── CHANGELOG.md          # auto-generated
└── DOCS.md               # optional
```

### Steps
1. **version.yaml**: `source: github|github_tags`, `repo`, `tag_prefix`, optional `build_args` with `${version}`/`${tag}` placeholders, `changelog` block
2. **config.yaml**: standard HA addon config (see Dev Guide section)
3. **Dockerfile**: multi-stage or upstream ref per build strategy
4. **00-init.sh**: `#!/usr/bin/with-contenv bashio`, `mkdir -p /config/<data>`
5. **README.md**: add entry to Add-ons table
6. **No CI changes needed**: Version_Check.yml + Release.yml handle everything

### Changelog sources
| source | mechanism | use case |
|---|---|---|
| `release_body` | GitHub Release API `.body` | most addons |
| `file` | `curl` remote URL | projects with standalone CHANGELOG.md |
| `tag_file` | GitHub Contents API `?ref=${TAG}` | tag-only repos (e.g. qinglong) |

## CI/CD

### Flow
```
Version_Check (cron 0 */6 * * *) → workflow_call → Release → per-addon build → push ghcr.io → independent commits
```

### Version_Check.yml
- **Trigger**: cron + workflow_dispatch
- **Role**: detect upstream changes & debian-base updates → output `has_changes` + `matrix` JSON
- **Permissions**: `contents: write, actions: write, packages: write` (packages:write critical for workflow_call)

### Release.yml
- **Trigger**: workflow_call (from Version_Check) + workflow_dispatch (manual)
- **Jobs**: scan-all → build (matrix); each job does config update + changelog + git commit
- **Matrix parse**: `fromJson(needs.scan-all.outputs.matrix || inputs.matrix || '{"include":[]}')`

### Version detection
- Read `*/version.yaml` → `source` → fetch upstream tag → strip `tag_prefix` → compare with local config.yaml version
- `version_changed` → update config.yaml + CHANGELOG.md
- `base_updated` → keep version, rebuild all addons

### Independent commit strategy
- Each addon commits & pushes its own config.yaml/CHANGELOG immediately after build
- Race prevention: 3x `pull --rebase origin main && push` retry
- Commit: `chore(${ADDON}): update to ${VERSION}`
- debian-base tag updates also committed independently

### build-args
- `version.yaml` `build_args` use `${version}`/`${tag}` placeholders → CI replaces via jq `gsub`
- `upstream_tag_transform` for extra processing (e.g. filebrowser-quantum `s/\.0-stable/-stable/`)
- **Multiline output**: `GITHUB_OUTPUT` must use heredoc, **never** `tr '\n' ' '` (causes `invalid reference format`)

### ghcr.io
- Package: `ghcr.io/solarflows/<addon-slug>`
- Old packages may be unwritable under new permission model → delete & recreate
- Avoid too-short names (2-char triggers limits)

### GHA pitfalls
- `${{ }}` pipes `|` → use `jq -r` to read files
- `strategy.matrix` must be `{include: [...]}`, not bare `[]`
- `yq eval` defaults YAML; add `-o=json` for jq
- `needs.<job>` must be declared in `needs:` list
- Action versions: use `@v4` (`@v7`/`@v8` may not exist)
