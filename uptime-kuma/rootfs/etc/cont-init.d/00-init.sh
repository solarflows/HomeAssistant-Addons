#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Uptime Kuma 初始化脚本
# 参照: louislam/uptime-kuma docker/debian-base.dockerfile
# ==============================================================================
set -e

bashio::log.info "Initializing Uptime Kuma..."

################
# DATA DIR     #
################
DATA_DIR="/config/uptime-kuma/data"

if [ ! -d "$DATA_DIR" ]; then
    if [ -d /opt/uptime-kuma/data ] && [ "$(ls -A /opt/uptime-kuma/data 2>/dev/null)" ]; then
        bashio::log.info "Migrating existing data to ${DATA_DIR}"
        mkdir -p /config/uptime-kuma
        cp -rn /opt/uptime-kuma/data/* /config/uptime-kuma/
    fi
fi
mkdir -p "$DATA_DIR"

if [ ! -L /opt/uptime-kuma/data ]; then
    rm -rf /opt/uptime-kuma/data
    ln -s "$DATA_DIR" /opt/uptime-kuma/data
    bashio::log.info "Linked data directory to ${DATA_DIR}"
fi

################
# MARIADB      #
################
# 确保 MariaDB 数据目录可写 (UPTIME_KUMA_ENABLE_EMBEDDED_MARIADB=1 时可选使用)
MYSQL_DIR="/config/uptime-kuma/mysql"
if [ ! -d "$MYSQL_DIR" ]; then
    mkdir -p "$MYSQL_DIR"
    bashio::log.info "Created MariaDB data dir: ${MYSQL_DIR}"
fi

# 如果 /var/lib/mysql 不存在或为空，link 到持久化目录
if [ ! -d /var/lib/mysql ] || [ -z "$(ls -A /var/lib/mysql 2>/dev/null)" ]; then
    rm -rf /var/lib/mysql
    ln -s "$MYSQL_DIR" /var/lib/mysql
    bashio::log.info "Linked MariaDB data to ${MYSQL_DIR}"
fi

################
# NSCD (DNS)   #
################
# 启动 nscd 缓存 DNS 查询，加速大量监控目标的域名解析
if [ -x /usr/sbin/nscd ]; then
    bashio::log.info "Starting nscd DNS cache..."
    /usr/sbin/nscd -f /etc/nscd.conf || bashio::log.warning "Failed to start nscd"
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
