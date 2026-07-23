#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Baihu Panel 初始化脚本
# ==============================================================================
# BH_DB_PATH 直接指向持久化目录 → 无需 /app/data symlink
# /app/configs 和 /app/envs 无原生环境变量可改路径 → 保留 symlink

bashio::log.info "Initializing Baihu Panel..."

# 创建持久化目录
mkdir -p /config/baihu/data
mkdir -p /config/baihu/configs
mkdir -p /config/baihu/envs

# 链接配置和变量目录
mkdir -p /app/configs
if [ ! -L /app/configs ]; then
    rm -rf /app/configs
    ln -sf /config/baihu/configs /app/configs
fi

mkdir -p /app/envs
if [ ! -L /app/envs ]; then
    rm -rf /app/envs
    ln -sf /config/baihu/envs /app/envs
fi

bashio::log.info "Baihu Panel initialization completed"

rm -f /run/service/baihu/down 2>/dev/null
