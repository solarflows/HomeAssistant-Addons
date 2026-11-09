#!/bin/sh
#=============================================================================
# ADDON_SLUG HA 适配入口脚本
#=============================================================================
#   1) 数据持久化目录校验 (原生直挂 /app/data，零软链接)
#   2) 存量历史数据双轨自愈探测 (/legacy_ha/ADDON_SLUG)
#   3) HA app options -> 环境变量转换
#   4) 链式启动上游主程序 (由 dumb-init 守护)
#=============================================================================
set -e

DATA_DIR="/app/data"
echo "[ADDON_SLUG] Checking persistent directories..."
mkdir -p "${DATA_DIR}"

# ---- 存量历史数据自愈平移 ----
if [ -d "/legacy_ha/ADDON_SLUG" ] && [ ! -f "${DATA_DIR}/.migrated_from_legacy" ]; then
    if [ -z "$(ls -A "${DATA_DIR}" 2>/dev/null)" ]; then
        echo "[ADDON_SLUG] Migrating legacy Core data..."
        cp -a /legacy_ha/ADDON_SLUG/. "${DATA_DIR}/" || echo "[ADDON_SLUG] Warning: Migration copy returned non-zero"
        touch "${DATA_DIR}/.migrated_from_legacy"
        echo "[ADDON_SLUG] Legacy data migrated successfully."
    fi
fi

# ---- 解析 /data/options.json 导出环境变量 ----
if [ -f /data/options.json ] && command -v jq >/dev/null 2>&1; then
    echo "[ADDON_SLUG] Reading HA app options..."
    eval "$(jq -r 'to_entries[] | select(.value != null and ((.value | tostring) != "")) | "export \(.key)=\(.value | @sh)"' /data/options.json)"
fi

echo "[ADDON_SLUG] Starting application..."
if command -v dumb-init >/dev/null 2>&1; then
    exec dumb-init -- "$@"
else
    exec "$@"
fi
