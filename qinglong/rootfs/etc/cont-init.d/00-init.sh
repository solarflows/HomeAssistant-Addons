#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Qinglong 初始化脚本
# ==============================================================================

bashio::log.info "Initializing Qinglong..."

# 创建持久化目录
mkdir -p /config/qinglong/data
mkdir -p /ql/data

# 如果 /config/qinglong/data 有内容，链接到 /ql/data
if [ -d /config/qinglong/data ] && [ "$(ls -A /config/qinglong/data 2>/dev/null)" ]; then
    # 备份旧数据
    if [ -d /ql/data ] && [ "$(ls -A /ql/data 2>/dev/null)" ]; then
        bashio::log.info "Migrating existing data to persistent storage..."
        cp -rn /ql/data/* /config/qinglong/data/ 2>/dev/null || true
    fi
fi

# 创建符号链接
rm -rf /ql/data
ln -sf /config/qinglong/data /ql/data

bashio::log.info "Qinglong initialization completed"
