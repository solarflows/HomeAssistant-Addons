#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# ADDON_SLUG 初始化脚本
# 创建持久化目录、symlink、调用上游 init 脚本（如有）
# ==============================================================================

bashio::log.info "Initializing ADDON_SLUG..."

# ---- HA addon 配置 ----
# TODO: read addon config options
# EXAMPLE=$(bashio::config "EXAMPLE" "default")

# ---- 持久化目录 ----
# /config/ 是共享空间，必须用 slug 子目录隔离
mkdir -p /config/ADDON_SLUG
# /data/ 自动按 addon 隔离
mkdir -p /data/ADDON_SLUG

# TODO: symlink upstream hardcoded paths → /config/ADDON_SLUG/ or /data/ADDON_SLUG/
# Example: ln -sf /data/ADDON_SLUG /app/data
# Example: ln -sf /config/ADDON_SLUG/config.yaml /app/config.yaml

# TODO: call upstream init scripts if applicable
# Example:
#   set +e
#   /docker/scripts/init.sh
#   init_rc=$?
#   set -e
#   [ $init_rc -ne 0 ] && bashio::log.warning "upstream init script exited with code $init_rc"

# 生成首启就绪标志（供 run 脚本有界等待，防止并发竞态）
touch /run/ADDON_SLUG-initialized
bashio::log.info "ADDON_SLUG initialization completed"
