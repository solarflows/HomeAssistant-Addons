# HomeAssistant-Addons

> Owner: solarflows | Maintainer: Husky
> Repo definition: `repository.yaml`

## Addons (9)

| slug | upstream | strategy | port | S6 |
|---|---|---|---|---|
| alist-tvbox | power721/alist-tvbox | JAR + haroldli/alist | 4567, 80→5344 | yes |
| alist-tvbox-standalone | same | JAR (no alist, no nginx) | 4567 | yes |
| lucky | gdy666/lucky | binary download | 16601 (host) | yes |
| flaresolverr | FlareSolverr/FlareSolverr | upstream image | 8191, 8192 | no |
| qdtoday | qd-today/qd | Python src build | 8923 | yes |
| qinglong | whyour/qinglong | Node.js src build | 5700 | yes |
| baihu-panel | engigu/baihu-panel | Go src build | 8052 | yes |
| filebrowser-quantum | gtsteffaniak/filebrowser | upstream image | 8080 | yes |
| uptime-kuma | louislam/uptime-kuma | Node.js src build | 3001 | yes |

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
| uptime-kuma | "v" | v2.4.0 | 2.4.0 |

## Quick Reference
- **Base**: `debian-base:9.3.0` (S6 built-in) | **Paths**: `/config` (persistent), `/share` (cross-addon), `/ssl` (certs)
- **Build**: multi-stage source / upstream image ref / base+binary / base+JAR → see SKILL:ha-addon-conventions
- **CI**: `Version_Check (6h cron) → Release → build → ghcr.io → independent commits` → see SKILL:fix-ci

## Skills
| Skill | File | Use when |
|---|---|---|
| ha-addon-conventions | `.github/skills/ha-addon-conventions/SKILL.md` | config.yaml schema, S6 scripts, build strategies, CI details |
| create-addon | `.github/skills/create-addon/SKILL.md` | scaffold new addon directory |
| fix-ci | `.github/skills/fix-ci/SKILL.md` | debug CI/CD failures |
