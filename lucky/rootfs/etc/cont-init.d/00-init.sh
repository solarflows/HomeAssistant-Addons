#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Lucky 初始化脚本
# 零软链架构：app_config 直挂 /goodluck，双轨自愈探测 /legacy_ha
# ==============================================================================

bashio::log.info "Initializing Lucky..."

DATA_DIR="/goodluck"
mkdir -p "${DATA_DIR}"

# ---- 双轨存量自愈平滑迁移（一次性探测老 Core /legacy_ha 目录） ----
if [ ! -f "${DATA_DIR}/.migrated_from_legacy" ]; then
    MIGRATION_SRC=""
    if [ -f /legacy_ha/lucky/lucky.conf ] && [ ! -f "${DATA_DIR}/lucky.conf" ]; then
        MIGRATION_SRC="/legacy_ha/lucky"
    elif [ -f /legacy_ha/luckyconf/lucky.conf ] && [ ! -f "${DATA_DIR}/lucky.conf" ]; then
        MIGRATION_SRC="/legacy_ha/luckyconf"
    fi

    if [ -n "${MIGRATION_SRC}" ]; then
        bashio::log.info "检测到历史 Core 存量数据 (${MIGRATION_SRC})，执行一次性增量平移..."
        cp -an "${MIGRATION_SRC}/." "${DATA_DIR}/" 2>/dev/null || true
        touch "${DATA_DIR}/.migrated_from_legacy"
        echo "${MIGRATION_SRC}" > /run/migration_cleanup_pending
        bashio::log.info "存量数据平移完成，服务启动验证通过后将登记清理。"
    else
        touch "${DATA_DIR}/.migrated_from_legacy"
    fi
fi

touch /run/lucky-initialized
bashio::log.info "Lucky initialization completed"
