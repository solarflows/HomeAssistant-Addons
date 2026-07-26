---
name: fix-ci
description: 调试和修复 GitHub Actions CI/CD 问题。构建失败、工作流语法错误、发布管道异常时使用。
---

# CI Fix Guide

## CI Flow
```
Version_Check (cron 0 */6 * * *) → workflow_call → Release → per-addon build → push ghcr.io → independent commits
```

## Workflow Details

### Version_Check.yml
- **Trigger**: cron (every 6h) + workflow_dispatch
- **Role**: detect upstream changes & debian-base updates → output `has_changes` + `matrix` JSON
- **Permissions**: `contents: write, actions: write, packages: write` (packages:write critical for workflow_call)
- Detect priority: `version_changed` > `base_updated` > `file_changed` > `force_rebuild`
- File trigger sub-types: `dockerfile` / `rootfs` / `config` / `workflow`
- Compound reason: accumulates unique triggers (`dockerfile,rootfs`)
- Matrix (4 fields): `addon` / `reason` / `new_ver` / `commit_msg`
- `commit_msg`: per-addon git log filtered by `${ADDON_DIR}/`, passed to Release for CHANGELOG

### Release.yml
- **Trigger**: workflow_call (from Version_Check) + workflow_dispatch (manual)
- **Jobs**: build (matrix); each job does config update + changelog + git commit
- **Matrix parse**: `fromJson(needs.check-versions.outputs.matrix || inputs.matrix || '{"include":[]})' `)
- Release computes `build_version`/`build_num`/`base_tag` from version.yaml at runtime
- CHANGELOG: uses matrix `commit_msg` first, falls back to `git log file_sha..HEAD`
- Compound reason: `IFS=',' read -ra` splits → builds label like `Dockerfile + rootfs 变更`
- `IS_FILE_TRIGGER` matches with glob: `dockerfile*|rootfs*|...`

## GHA Common Pitfalls
- `${{ }}` pipes `|` → use `jq -r` to read files
- `strategy.matrix` must be `{include: [...]}`, not bare `[]`
- `yq eval` defaults YAML; add `-o=json` for jq
- `needs.<job>` must be declared in `needs:` list
- Action versions: use `@v4` (`@v7`/`@v8` may not exist)
- `workflow_call` inherits caller's permissions

## GITHUB_OUTPUT
- Multiline: use heredoc, **never** `tr '\n' ' '` or `echo "key=$val"` (causes `Invalid format`)
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

## cleanup-runs (replaces cleanup-changelog)
- Runs after Release, deletes workflow runs >30 days via `gh api`
- No repo checkout needed, uses `GH_TOKEN`

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
