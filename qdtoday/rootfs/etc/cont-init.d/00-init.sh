#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# QD-Today 初始化脚本
# ==============================================================================
# QD 不支持命令行参数或环境变量指定 config 目录路径，使用 symlink 实现持久化

bashio::log.info "Initializing QD-Today..."

# 创建持久化目录
mkdir -p /config/qd

# 如果默认 config 目录存在，迁移到持久化目录
if [ -d /usr/src/app/config ] && [ ! -L /usr/src/app/config ] && [ "$(ls -A /usr/src/app/config 2>/dev/null)" ]; then
    if [ ! "$(ls -A /config/qd 2>/dev/null)" ]; then
        bashio::log.info "Migrating existing data to persistent storage..."
        cp -rn /usr/src/app/config/* /config/qd/ 2>/dev/null || true
    fi
    rm -rf /usr/src/app/config
fi

# 创建符号链接
if [ ! -L /usr/src/app/config ]; then
    rm -rf /usr/src/app/config
    ln -sf /config/qd /usr/src/app/config
fi

bashio::log.info "QD-Today initialization completed"

rm -f /run/service/qdtoday/down 2>/dev/null
