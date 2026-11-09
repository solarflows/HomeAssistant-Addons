#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Lucky 初始化脚本
# ==============================================================================
# Lucky 使用 -c 指定配置文件路径，数据库等会写入同目录，无需 symlink

bashio::log.info "Initializing Lucky..."

# 若存在历史 luckyconf 子目录配置，自动平铺至 /config 根目录
if [ -d /config/luckyconf ]; then
    if [ -f /config/luckyconf/lucky.conf ] && [ ! -f /config/lucky.conf ]; then
        mv /config/luckyconf/lucky.conf /config/lucky.conf
    fi
    rm -rf /config/luckyconf
fi

bashio::log.info "Lucky initialization completed"
