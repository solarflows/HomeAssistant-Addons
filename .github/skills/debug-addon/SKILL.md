---
name: debug-addon
description: 调试 HA 加载项构建或运行时问题的指南。涵盖 CI 日志分析、Docker 构建排错、S6 容器调试。
---

# Addon Debug Guide

## CI Build Failures

| Step | Common Cause | Check |
|------|-------------|-------|
| `docker build` | Missing ARG, network timeout, incompatible builder | Verify `build_args` in version.yaml match Dockerfile |
| `docker push` | ghcr auth, package write permission | Check workflow permissions |
| `git commit` | Branch divergence, rebase conflict | CI retries up to 3x with pull+rebase |

## Docker Build Debug
- Verify `${BUILD_FROM}` / `${BUILD_ARCH}` are passed correctly in version.yaml
- Check upstream base image availability (especially for `FROM upstream/img`)
- For multi-stage builds, test each stage independently

## S6 Runtime Debug
| Symptom | Likely Cause |
|---------|-------------|
| Container exits immediately | S6 stage2 hook missing or broken |
| Service not starting | `down` file present in s6-rc.d |
| Init script fails silently | `set -e` + missing file kills the script |

## Local Inspection
```bash
# Build locally
docker build -t test-addon ./<addon-slug>/

# Run and inspect
docker run --rm -it test-addon /bin/bash
# Inside container:
#   s6-rc -d list        # check service status
#   ls /etc/cont-init.d/ # verify init scripts
#   ls /run/service/      # check for down files
```
