#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# ADDON_SLUG 初始化脚本
# 原生直挂校验、存量自愈探测、执行权限检查与启动屏障锁
# ==============================================================================

bashio::log.info "Initializing ADDON_SLUG..."

# ---- HA app 配置读取 ----
# TODO: read app config options
# EXAMPLE=$(bashio::config "EXAMPLE" "default")

# ---- 持久化与双轨自愈探测 (零软链架构) ----
# 数据目录由 config.yaml 中 type: app_config 直挂（如 /app/data）
# 探测旧版 Core (/legacy_ha/ADDON_SLUG) 历史数据并一次性迁移平移
DATA_DIR="/app/data"
mkdir -p "${DATA_DIR}"

if [ -d "/legacy_ha/ADDON_SLUG" ] && [ ! -f "${DATA_DIR}/.migrated_from_legacy" ]; then
    if [ -z "$(ls -A "${DATA_DIR}" 2>/dev/null)" ]; then
        bashio::log.info "检测到历史 Core 目录存量数据，执行一次性增量平移..."
        cp -a /legacy_ha/ADDON_SLUG/. "${DATA_DIR}/" || bashio::log.warning "存量数据迁移复制存在异常"
        touch "${DATA_DIR}/.migrated_from_legacy"
        bashio::log.info "存量数据已完成平移。"
    fi
fi

# TODO: call upstream init scripts if applicable
# Example:
#   set +e
#   /docker/scripts/init.sh
#   init_rc=$?
#   set -e
#   [ $init_rc -ne 0 ] && bashio::log.warning "upstream init script exited with code $init_rc"

# 生成首启就绪标志（供 S6 run 脚本自旋等待，彻底消除启动竞态）
touch /run/ADDON_SLUG-initialized
bashio::log.info "ADDON_SLUG initialization completed"
