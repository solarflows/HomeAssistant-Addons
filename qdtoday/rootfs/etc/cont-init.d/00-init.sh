#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# QD-Today 初始化脚本
# ==============================================================================

bashio::log.info "Initializing QD-Today..."

# 创建持久化目录
mkdir -p /config/qd
mkdir -p /usr/src/app/config

# 如果配置目录为空，复制默认配置
if [ ! -f /usr/src/app/config/config.json ]; then
    if [ -f /usr/src/app/config/config.default.json ]; then
        cp /usr/src/app/config/config.default.json /usr/src/app/config/config.json
    fi
fi

bashio::log.info "QD-Today initialization completed"
