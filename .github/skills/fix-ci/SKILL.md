---
name: fix-ci
description: Debug and fix GitHub Actions CI/CD issues in this repository. Use when CI fails, build errors occur, workflow syntax needs debugging, or release pipeline breaks.
---

# CI Fix Guide

## GHA Common Pitfalls
- `${{ }}` pipes `|` → use `jq -r` to read files
- `strategy.matrix` must be `{include: [...]}`, not bare `[]`
- `yq eval` defaults YAML; add `-o=json` for jq
- `needs.<job>` must be declared in `needs:` list
- Action versions: use `@v4` (`@v7`/`@v8` may not exist)
- `workflow_call` inherits caller's permissions

## GITHUB_OUTPUT
- Multiline: use heredoc, **never** `tr '\n' ' '` (causes `invalid reference format`)
```bash
{
  echo "matrix<<EOF"
  echo "${JSON}"
  echo "EOF"
} >> "${GITHUB_OUTPUT}"
```

## Version detection
- Read `*/version.yaml` → `source` → fetch upstream tag → strip `tag_prefix` → compare
- `version_changed` → update config.yaml + CHANGELOG.md
- `base_updated` → keep version, rebuild all addons
- New addon: `file_sha: ""` triggers first-build detection

## build-args
- `version.yaml` `build_args` use `${version}`/`${tag}` placeholders → CI replaces via jq `gsub`
- Key name must match the ARG in Dockerfile

## debian-base
- Release API: `hassio-addons/addon-debian-base/releases/latest`
- Tag is `v9.3.0` format → always `sed 's/^v//'` before comparing with stored `base_tag`

## Commit & push
- Independent commits per addon after build → 3x retry pull+push
- Commit: `chore(${ADDON}): update to ${VERSION}`
- push retry: 3 attempts, `exit 1` on final failure (not silent skip)

## ghcr.io
- Package: `ghcr.io/solarflows/<addon-slug>`
- Old packages may be unwritable under new permission model → delete & recreate
- Avoid too-short names (2-char triggers limits)
