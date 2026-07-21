#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox 初始化脚本
# ==============================================================================

bashio::log.info "Initializing alist-tvbox..."

# 创建持久化目录
mkdir -p /config/data
mkdir -p /config/atv/config
mkdir -p /data/log

# 如果 /config/data 存在，创建符号链接
if [ -d /config/data ]; then
    ln -sf /config/data /opt/alist/data 2>/dev/null || true
fi

bashio::log.info "alist-tvbox initialization completed"
