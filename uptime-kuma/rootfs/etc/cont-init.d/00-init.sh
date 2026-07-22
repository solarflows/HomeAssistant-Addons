#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Uptime Kuma 初始化脚本
# ==============================================================================
set -e

bashio::log.info "Initializing Uptime Kuma..."

################
# DATA DIR     #
################
mkdir -p /config/uptime-kuma

# data 目录需要持久化，使用 bind mount 比 symlink 更可靠
# 但如果 /opt/uptime-kuma/data 已经是一个目录（非 symlink），迁移数据后替换
DATA_DIR="/config/uptime-kuma/data"

if [ ! -d "$DATA_DIR" ]; then
    if [ -d /opt/uptime-kuma/data ] && [ "$(ls -A /opt/uptime-kuma/data 2>/dev/null)" ]; then
        bashio::log.info "Migrating existing data to ${DATA_DIR}"
        mkdir -p /config/uptime-kuma
        cp -rn /opt/uptime-kuma/data/* /config/uptime-kuma/
    fi
fi

# 确保 /config 下 data 目录存在
mkdir -p "$DATA_DIR"

# 替换 /opt/uptime-kuma/data 为持久化目录的 symlink
if [ ! -L /opt/uptime-kuma/data ]; then
    rm -rf /opt/uptime-kuma/data
    ln -s "$DATA_DIR" /opt/uptime-kuma/data
    bashio::log.info "Linked data directory to ${DATA_DIR}"
fi

################
# TIMEZONE     #
################
if bashio::config.has_value 'TZ'; then
    TZ=$(bashio::config 'TZ')
    if [ -f "/usr/share/zoneinfo/${TZ}" ]; then
        ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
        echo "${TZ}" > /etc/timezone
        bashio::log.info "Timezone set to ${TZ}"
    fi
fi

bashio::log.info "Uptime Kuma initialization completed"
