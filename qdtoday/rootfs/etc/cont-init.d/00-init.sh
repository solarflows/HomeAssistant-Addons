#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# QD-Today 初始化脚本
# 零软链架构：app_config 直挂 /usr/src/app/config，双轨自愈探测 /legacy_ha
# ==============================================================================

bashio::log.info "Initializing QD-Today..."

DATA_DIR="/usr/src/app/config"
mkdir -p "${DATA_DIR}"

# ---- 双轨存量自愈平滑迁移（一次性探测老 Core /legacy_ha 与 /data/qd） ----
if [ ! -f "${DATA_DIR}/.migrated_from_legacy" ]; then
    MIGRATION_SRC=""
    if [ -f /legacy_ha/qdtoday/database.db ] && [ ! -f "${DATA_DIR}/database.db" ]; then
        MIGRATION_SRC="/legacy_ha/qdtoday"
    elif [ -f /data/qd/database.db ] && [ ! -f "${DATA_DIR}/database.db" ]; then
        MIGRATION_SRC="/data/qd"
    fi

    if [ -n "${MIGRATION_SRC}" ]; then
        bashio::log.info "检测到历史存量数据 (${MIGRATION_SRC})，执行一次性增量平移..."
        cp -an "${MIGRATION_SRC}/." "${DATA_DIR}/" 2>/dev/null || true
        touch "${DATA_DIR}/.migrated_from_legacy"
        echo "${MIGRATION_SRC}" > /run/migration_cleanup_pending
        bashio::log.info "存量数据平移完成，服务启动验证通过后将登记清理。"
    else
        touch "${DATA_DIR}/.migrated_from_legacy"
    fi
fi

touch /run/qdtoday-initialized
bashio::log.info "QD-Today initialization completed"
