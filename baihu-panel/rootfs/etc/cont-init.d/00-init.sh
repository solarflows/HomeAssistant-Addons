#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Baihu Panel 初始化脚本
# ==============================================================================

bashio::log.info "Initializing Baihu Panel..."

# 创建持久化目录
mkdir -p /config/baihu-panel/data
mkdir -p /config/baihu-panel/configs
mkdir -p /config/baihu-panel/envs

# /app/data 持久化（脚本、WebUI 等用户数据）
if [ ! -L /app/data ]; then
    rm -rf /app/data
    ln -sf /config/baihu-panel/data /app/data
fi

# ---- mise 运行时环境 ----
mkdir -p /config/baihu-panel/mise
mkdir -p /app/envs
if [ ! -L /app/envs/mise ]; then
    ln -sf /config/baihu-panel/mise /app/envs/mise
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

# ---- 导出运行环境变量 (端口/host/DB路径均为内部实现，不暴露用户配置) ----
export BH_SERVER_PORT=8052
export BH_SERVER_HOST=0.0.0.0
export BH_DB_PATH=/config/baihu-panel/data/baihu.db

bashio::log.info "Baihu Panel config: port=${BH_SERVER_PORT}, host=${BH_SERVER_HOST}"

bashio::log.info "Baihu Panel initialization completed"
