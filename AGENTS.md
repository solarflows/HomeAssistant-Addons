# HomeAssistant-Addons

> Owner: solarflows | Maintainer: Husky
> Repo definition: `repository.yaml`

## Agent Working Rules

- Before editing, inspect `git status --short --branch` and preserve unrelated user changes.
- Prefer evidence in Dockerfiles, `rootfs/`, `config.yaml`, workflows, tests, and Git history. Treat `analysis.yaml`, summary tables, and upstream documentation as hypotheses until they match the current runtime files.
- Use repository-local `AGENTS.md`, `.github/instructions/`, `.github/skills/`, and `docs/` as the portable project knowledge base. Do not move project rules into user/plugin memory.
- Do not commit, push, rebase, merge, tag, or change branches unless the user explicitly asks.
- Do not manually update CI-owned metadata: `config.yaml.version`, `CHANGELOG.md`, or `version.yaml.tracking.file_sha` / `build_num`. See [addon-editing.instructions.md](.github/instructions/addon-editing.instructions.md).
- Before enabling or restoring Ingress, verify the pinned upstream version and relevant Git history, then test the HA subpath behavior, redirects, static assets, APIs, and WebSockets. Use direct `webui` and ports when support is not proven.

## Repository Shape

Each addon normally contains `analysis.yaml`, `config.yaml`, `Dockerfile`, `version.yaml`, `README.md`, `DOCS.md`, `CHANGELOG.md`, `translations/`, and `rootfs/`. The reusable skeleton is in [.github/templates/addon/](.github/templates/addon/).

The repository has no single project-wide test command. The normal local verification is targeted YAML parsing, shell syntax checks, a single-platform Docker build, and a cold-start smoke test against the image health endpoint. See [Validation](#validation).

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
| filebrowser-quantum | gtsteffaniak/filebrowser | binary download | 8080 | yes |
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
- **Build**: multi-stage source / upstream image adaptation / base+binary / base+JAR. Check the current Dockerfile before choosing a strategy.
- **CI**: `Version_Check (6h cron) -> Release -> multi-arch build -> ghcr.io -> independent metadata commits`; details are in [fix-ci/SKILL.md](.github/skills/fix-ci/SKILL.md).
- **Runtime**: S6 longruns must keep the application in the foreground and `exec` the real process. `flaresolverr` is the upstream-image exception and uses its own entrypoint.
- **Troubleshooting**: [addon-troubleshooting.instructions.md](.github/instructions/addon-troubleshooting.instructions.md) is auto-loaded for Dockerfiles, Shell, `config.yaml`, and `version.yaml`.

## Runtime Boundaries

- `/config` is shared by addons and backed up by Home Assistant. Namespace addon data under `/config/<slug>/`; never write directly to `/config`.
- `/data` is persistent and isolated per addon but is not part of the normal backup. Use it for caches, indexes, and large application data when appropriate.
- `/share` is cross-addon storage; `/ssl` contains certificates. Do not assume an upstream Docker `VOLUME` is automatically mapped to the correct HA path.
- Audit upstream `VOLUME`, hardcoded absolute paths, working-directory assumptions, entrypoint/init logic, and build-time resource paths. Add the required directories and symlinks in `00-init.sh`.
- Reuse upstream initialization and startup logic where it exists. Keep initialization in `00-init.sh` and the foreground service in the S6 `run` script.
- `debian-base:9.3.0` carries an older S6. Do not add unsupported service files such as `notification-fd` or `timeout-up`; keep the existing `S6_STAGE2_HOOK` pattern where required.
- After `COPY rootfs /`, make shell entrypoints executable. This matters especially after a Windows checkout.
- Do not silently swallow failures with `|| true`. For an intentionally non-fatal operation, capture the exit code, log the reason, and document why startup can continue.

## Version and CI Contract

- `version.yaml.version` is the clean upstream comparison version. `config.yaml.version` is generated by CI and may include `-build.N`.
- Every `version.yaml.build_args` key must match a Dockerfile `ARG`. Check tag prefixes and transformations per addon before changing version logic.
- `Version_Check.yml` runs every six hours and on manual dispatch; `Release.yml` builds the matrix for the configured architectures and pushes `ghcr.io/solarflows/<addon-slug>`.
- The current push path filter watches addon `Dockerfile`, addon `rootfs/**`, `Release.yml`, `.github/actions/**`, and `.github/scripts/**`. Do not assume a config-only or version-only change will trigger a build; inspect [Version_Check.yml](.github/workflows/Version_Check.yml) when the trigger matters.
- Build args and GitHub Actions outputs are structured data. Preserve the existing `yq -> JSON -> jq` flow and heredoc format for multiline `GITHUB_OUTPUT` values.

## Validation

For a changed addon, use the smallest useful check first:

1. Parse `repository.yaml`, the target `config.yaml`, `version.yaml`, and `analysis.yaml` with `yq`.
2. Run `bash -n` (or `shellcheck` when available) on changed `rootfs` scripts and verify executable permissions in the Dockerfile.
3. Run a single-platform Buildx build for `linux/amd64`, passing every build argument declared in the target `version.yaml`:

	 ```bash
	 docker buildx build --platform linux/amd64 \
		 --build-arg <ARG>=<value> \
		 -f <addon>/Dockerfile <addon> --load --tag local/<addon>:check
	 ```

4. Start the image with an empty data directory and exercise the declared `HEALTHCHECK`, primary port, and any secondary service ports. For web applications, check redirects, static assets, API calls, and WebSockets when Ingress or a reverse proxy is involved.
5. Do not describe a build or runtime behavior as verified when Docker, the required upstream network access, or a Home Assistant environment was unavailable.

## Navigation

| Need | Read |
|---|---|
| Create a new addon | [create-addon/SKILL.md](.github/skills/create-addon/SKILL.md) |
| Analyze an upstream project | [plan-addon/SKILL.md](.github/skills/plan-addon/SKILL.md) |
| Update an existing addon | [update-addon/SKILL.md](.github/skills/update-addon/SKILL.md) |
| Diagnose CI or release failures | [fix-ci/SKILL.md](.github/skills/fix-ci/SKILL.md) |
| Edit addon manifests, Ingress, init, or Dockerfiles | [addon-editing.instructions.md](.github/instructions/addon-editing.instructions.md) |
| Review known build/runtime pitfalls | [addon-troubleshooting.instructions.md](.github/instructions/addon-troubleshooting.instructions.md) |
| Understand an addon’s user-facing behavior | `<addon>/DOCS.md` and `<addon>/README.md` |
| Check repository metadata and workflows | [repository.yaml](repository.yaml), [Version_Check.yml](.github/workflows/Version_Check.yml), [Release.yml](.github/workflows/Release.yml) |

## Skills
| Skill | File | Use when |
|---|---|---|
| create-addon | `.github/skills/create-addon/SKILL.md` | Scaffold new addon skeleton with empty analysis.yaml (run first) |
| plan-addon | `.github/skills/plan-addon/SKILL.md` | Analyze upstream service & fill analysis.yaml (run after create-addon) |
| update-addon | `.github/skills/update-addon/SKILL.md` | Manually update existing addon for upstream changes |
| fix-ci | `.github/skills/fix-ci/SKILL.md` | Debug CI/CD failures |
