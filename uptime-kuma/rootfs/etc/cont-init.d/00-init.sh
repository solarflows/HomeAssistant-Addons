#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Uptime Kuma 初始化脚本
# 零软链架构：app_config 直挂 /opt/uptime-kuma/data，双轨自愈探测 /legacy_ha
# ==============================================================================
set -e

bashio::log.info "Initializing Uptime Kuma..."

DATA_DIR="/opt/uptime-kuma/data"
mkdir -p "$DATA_DIR"

# ---- 双轨存量自愈平滑迁移（一次性探测老 Core /legacy_ha 目录） ----
if [ ! -f "${DATA_DIR}/.migrated_from_legacy" ]; then
    MIGRATION_SRC=""
    if [ -d /legacy_ha/uptime-kuma ] && [ ! -f "${DATA_DIR}/kuma.db" ]; then
        MIGRATION_SRC="/legacy_ha/uptime-kuma"
    fi

    if [ -n "${MIGRATION_SRC}" ]; then
        bashio::log.info "检测到历史 Core 存量数据 (${MIGRATION_SRC})，执行一次性增量平移..."
        if [ -d "${MIGRATION_SRC}/data" ]; then
            cp -an "${MIGRATION_SRC}/data/." "${DATA_DIR}/" 2>/dev/null || true
        else
            cp -an "${MIGRATION_SRC}/." "${DATA_DIR}/" 2>/dev/null || true
        fi
        touch "${DATA_DIR}/.migrated_from_legacy"
        echo "${MIGRATION_SRC}" > /run/migration_cleanup_pending
        bashio::log.info "存量数据平移完成，服务启动验证通过后将登记清理。"
    else
        touch "${DATA_DIR}/.migrated_from_legacy"
    fi
fi

# ---- 兼容过渡期历史版本（当数据曾存放在子目录 data/ 时的平铺自愈） ----
if [ -d "${DATA_DIR}/data" ] && [ ! -f "${DATA_DIR}/kuma.db" ]; then
    bashio::log.info "检测到过渡期 data 子目录存量数据，自动平铺上移..."
    cp -an "${DATA_DIR}/data/." "${DATA_DIR}/" 2>/dev/null || true
    rm -rf "${DATA_DIR}/data" 2>/dev/null || true
fi

# ---- MariaDB 数据目录 (存放在 /data/mysql 私有卷，避开 HA 备份膨胀) ----
MYSQL_DIR="/data/mysql"
mkdir -p "$MYSQL_DIR"
if [ ! -d /var/lib/mysql ] || [ -z "$(ls -A /var/lib/mysql 2>/dev/null)" ]; then
    rm -rf /var/lib/mysql
    ln -sf "$MYSQL_DIR" /var/lib/mysql 2>/dev/null || true
fi

# ---- NSCD (DNS 缓存加速) ----
if [ -x /usr/sbin/nscd ]; then
    bashio::log.info "Starting nscd DNS cache..."
    /usr/sbin/nscd -f /etc/nscd.conf || bashio::log.warning "Failed to start nscd"
fi

touch /run/kuma-initialized
bashio::log.info "Uptime Kuma initialization completed"
