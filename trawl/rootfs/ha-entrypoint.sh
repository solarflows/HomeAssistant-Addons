#!/bin/bash
#=============================================================================
# TRAWL HA 适配入口
#=============================================================================
#   1) 数据目录: /data/trawl（metrics SQLite + MITM CA，addon 隔离持久化）
#   2) /dev/shm 扩容: 上游 compose 使用 shm_size: 1gb；HA 不支持 shm_size，
#      改用 SYS_ADMIN 权限 remount（失败仅告警，不阻断启动）
#   3) HA addon options → 环境变量（jq，覆盖 Dockerfile ENV 默认值）
#   4) 链到上游 tini + 原始 CMD
#=============================================================================
set -e

echo "[trawl] Preparing persistent directories..."
mkdir -p /data/trawl/proxy-ca /data/trawl/metrics

# ---- /dev/shm 扩容到 1g（best-effort，需要 SYS_ADMIN）----
if mount -o remount,size=1g /dev/shm 2>/dev/null; then
    echo "[trawl] /dev/shm enlarged to 1g"
else
    echo "[trawl] WARNING: failed to enlarge /dev/shm; heavy pages may crash the browser." \
         "Lower BROWSER_MAX_CONTENT_PROCESSES / BROWSER_POOL_SIZE if instability occurs."
fi

# ---- HA addon options → 环境变量 ----
if [ -f /data/options.json ] && command -v jq >/dev/null 2>&1; then
    echo "[trawl] Reading HA addon options..."
    jq -r 'to_entries[]
        | select(.value != null and ((.value | tostring) != ""))
        | "\(.key)=\((.value | tostring) | @sh)"' /data/options.json > /tmp/ha_options.env
    set -a; . /tmp/ha_options.env; set +a
    rm -f /tmp/ha_options.env
fi

echo "[trawl] Starting..."
if [ "$#" -gt 0 ]; then
    exec /usr/bin/tini -- "$@"
else
    exec /usr/bin/tini -- bun run apps/api/src/index.ts
fi