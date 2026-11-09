#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Qinglong 初始化脚本
# 零软链架构：app_config 直挂 /ql/data，镜像代码保存在 /ql，双轨自愈探测 /legacy_ha
# ==============================================================================

bashio::log.info "Initializing Qinglong..."

DATA_DIR="/ql/data"
mkdir -p "${DATA_DIR}"

# ---- 双轨存量自愈平滑迁移（一次性探测老 Core /legacy_ha 目录） ----
if [ ! -f "${DATA_DIR}/.migrated_from_legacy" ]; then
    MIGRATION_SRC=""
    if [ -d /legacy_ha/qinglong/data ] && [ ! -f "${DATA_DIR}/db/database.sqlite" ]; then
        MIGRATION_SRC="/legacy_ha/qinglong/data"
    elif [ -d /legacy_ha/qinglong ] && [ ! -f "${DATA_DIR}/db/database.sqlite" ]; then
        MIGRATION_SRC="/legacy_ha/qinglong"
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

# 初始化 .env（上游要求，缺失会导致应用启动异常）
if [ -f /ql/.env.example ] && [ ! -f /ql/.env ]; then
    bashio::log.info "Creating .env from .env.example..."
    cp /ql/.env.example /ql/.env
fi

touch /run/qinglong-initialized
bashio::log.info "Qinglong initialization completed"
