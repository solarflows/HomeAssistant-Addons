#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Qinglong 初始化脚本
# ==============================================================================
# 使用 QL_DATA_DIR 环境变量直接指向持久化目录，无需 symlink

bashio::log.info "Initializing Qinglong..."

# 创建持久化目录
mkdir -p /config/qinglong/data

# 迁移旧数据：如果旧 symlink 目标有数据，保留
if [ -d /ql/data ] && [ ! -L /ql/data ] && [ "$(ls -A /ql/data 2>/dev/null)" ]; then
    if [ ! "$(ls -A /config/qinglong/data 2>/dev/null)" ]; then
        bashio::log.info "Migrating existing data to persistent storage..."
        cp -rn /ql/data/* /config/qinglong/data/ 2>/dev/null || true
    fi
    rm -rf /ql/data
fi

bashio::log.info "Qinglong initialization completed"
