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

# ---- mise 运行时环境 ----
mkdir -p /config/baihu/mise
mkdir -p /app/envs
if [ ! -L /app/envs/mise ]; then
    ln -sf /config/baihu/mise /app/envs/mise
fi
# 从预装基座同步 mise 环境（--ignore-existing 保护用户自定义的 runtime）
if [ -d /opt/mise-base ]; then
    rsync -a --ignore-existing /opt/mise-base/ /app/envs/mise/ || true
fi

# 链接配置目录
if [ ! -L /app/configs ]; then
    rm -rf /app/configs
    ln -sf /config/baihu/configs /app/configs
fi

bashio::log.info "Baihu Panel initialization completed"

rm -f /run/service/baihu/down 2>/dev/null
