#!/bin/sh
#=============================================================================
# ADDON_SLUG HA 适配入口脚本
#=============================================================================
#   1) 数据持久化目录接管 (/config/ADDON_SLUG 与 /data/ADDON_SLUG)
#   2) 上游硬编码路径软链接建立
#   3) HA addon options -> 环境变量转换
#   4) 链式启动上游主程序 (由 dumb-init 守护)
#=============================================================================
set -e

echo "[ADDON_SLUG] Preparing persistent directories..."
mkdir -p /config/ADDON_SLUG /data/ADDON_SLUG

# ---- 软链接接管上游数据目录示例 ----
# if [ ! -L /app/data ]; then
#     [ -d /app/data ] && cp -a /app/data/. /config/ADDON_SLUG/ && rm -rf /app/data
#     ln -s /config/ADDON_SLUG /app/data
# fi

# ---- 解析 /data/options.json 导出环境变量 ----
if [ -f /data/options.json ] && command -v jq >/dev/null 2>&1; then
    echo "[ADDON_SLUG] Reading HA addon options..."
    eval "$(jq -r 'to_entries[] | select(.value != null and ((.value | tostring) != "")) | "export \(.key)=\(.value | @sh)"' /data/options.json)"
fi

echo "[ADDON_SLUG] Starting application..."
if command -v dumb-init >/dev/null 2>&1; then
    exec dumb-init -- "$@"
else
    exec "$@"
fi
