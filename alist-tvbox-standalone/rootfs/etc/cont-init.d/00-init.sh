#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox-standalone 初始化脚本
# ==============================================================================
# 上游 entrypoint 将 Spring Boot 数据写入 /data/，symlink 到持久化目录

bashio::log.info "Initializing alist-tvbox-standalone..."

# 创建持久化目录
mkdir -p /config/data
mkdir -p /config/atv/config
mkdir -p /data/log

# symlink /data/store → /config/data/store（Spring Boot atv 数据）
if [ ! -L /data/store ]; then
    mkdir -p /config/data/store
    rm -rf /data/store
    ln -sf /config/data/store /data/store 2>/dev/null || true
fi

bashio::log.info "alist-tvbox-standalone initialization completed"
