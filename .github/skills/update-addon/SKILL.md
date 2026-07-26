---
name: update-addon
description: 手动更新已有 HA 加载项的流程。适用于上游版本变更、架构调整或构建失败时的人工介入。
---

# Addon Update Guide

## When to Use
- CI reports `version_changed` but build failed
- Upstream has breaking changes (new deps, base image, VOLUME)
- Need to adjust symlinks or init scripts
- Manual version bump needed

## Steps

### 1. Check CI Failure
- Read Release.yml workflow run logs
- Identify which addon failed and at which step (build / push / git commit)
- Common causes: missing ARG, incompatible builder, branch divergence

### 2. Inspect Upstream Changes
- Compare upstream tags: `https://github.com/<owner>/<repo>/compare/<old>...<new>`
- Check upstream Dockerfile and entrypoint.sh for changes
- Look for new/changed VOLUME mounts, env vars, or dependencies

### 3. Adapt Addon Files
- Update `00-init.sh` symlinks if upstream paths changed
- Modify Dockerfile build strategy if upstream changed toolchain
- Update config.yaml if upstream added new config options

### 4. Bump Version
- Edit `version.yaml` → update `tracking.file_sha` or trigger via `workflow_dispatch`

### 5. Record Lessons Learned
Append a dated entry to `.github/instructions/addon-troubleshooting.instructions.md` so future fixes benefit from this experience.
