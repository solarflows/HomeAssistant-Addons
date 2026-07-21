#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Baihu Panel 初始化脚本
# ==============================================================================

bashio::log.info "Initializing Baihu Panel..."

# 创建持久化目录
mkdir -p /config/baihu/data
mkdir -p /config/baihu/configs
mkdir -p /config/baihu/envs
mkdir -p /app/data
mkdir -p /app/configs
mkdir -p /app/envs

# 链接持久化目录
if [ -d /config/baihu/data ]; then
    rm -rf /app/data
    ln -sf /config/baihu/data /app/data
fi

if [ -d /config/baihu/configs ]; then
    rm -rf /app/configs
    ln -sf /config/baihu/configs /app/configs
fi

if [ -d /config/baihu/envs ]; then
    rm -rf /app/envs
    ln -sf /config/baihu/envs /app/envs
fi

bashio::log.info "Baihu Panel initialization completed"
