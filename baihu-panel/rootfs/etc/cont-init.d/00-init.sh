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

# /app/data 持久化（脚本、WebUI 等用户数据）
if [ ! -L /app/data ]; then
    rm -rf /app/data
    ln -sf /config/baihu/data /app/data
fi

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

# ---- 读取 HA addon 配置选项并导出为环境变量 ----
export BH_SERVER_PORT=$(bashio::config 'BH_SERVER_PORT' '8052')
export BH_SERVER_HOST=$(bashio::config 'BH_SERVER_HOST' '0.0.0.0')
export BH_DB_PATH=$(bashio::config 'BH_DB_PATH' '/config/baihu/data/baihu.db')
bashio::log.info "Baihu Panel config: port=${BH_SERVER_PORT}, host=${BH_SERVER_HOST}"

bashio::log.info "Baihu Panel initialization completed"
