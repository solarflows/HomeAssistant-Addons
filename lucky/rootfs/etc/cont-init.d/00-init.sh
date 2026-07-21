#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Lucky 初始化脚本
# ==============================================================================

bashio::log.info "Initializing Lucky..."

# 创建持久化目录
mkdir -p /config/luckyconf
mkdir -p /etc/lucky

# 如果配置文件不存在，创建默认配置
if [ ! -f /etc/lucky/lucky.conf ]; then
    bashio::log.info "Creating default Lucky configuration..."
    # Lucky 会自动创建默认配置，这里只是确保目录存在
fi

# 如果持久化目录有配置，链接到 /etc/lucky
if [ -f /config/luckyconf/lucky.conf ]; then
    ln -sf /config/luckyconf/lucky.conf /etc/lucky/lucky.conf
fi

bashio::log.info "Lucky initialization completed"
