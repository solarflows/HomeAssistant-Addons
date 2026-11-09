#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Lucky 初始化脚本
# ==============================================================================
# Lucky 使用 -c 指定配置文件路径，数据库等会写入同目录，无需 symlink

bashio::log.info "Initializing Lucky..."

mkdir -p /config

# ---- 一次性兼容历史子目录平铺（服务启动成功后清理旧源） ----
if [ ! -f /config/.migrated ]; then
    if [ -d /config/luckyconf ]; then
        if [ -f /config/luckyconf/lucky.conf ] && [ ! -f /config/lucky.conf ]; then
            cp -an /config/luckyconf/lucky.conf /config/lucky.conf
        fi
        echo "/config/luckyconf" > /run/migration_cleanup_pending
    else
        touch /config/.migrated
    fi
fi

bashio::log.info "Lucky initialization completed"
