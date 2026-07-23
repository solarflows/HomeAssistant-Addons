#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Qinglong 初始化脚本
# ==============================================================================
# QL_DATA_DIR 环境变量告诉上游 TypeScript/Shell 脚本数据目录位置
# symlink /ql/data → /config/qinglong/data 兜底硬编码 /ql/data 路径
#   （如 docker-entrypoint.sh 权限检查、用户脚本等）

bashio::log.info "Initializing Qinglong..."

# 创建持久化目录
mkdir -p /config/qinglong/data

# 迁移旧数据
if [ -d /ql/data ] && [ ! -L /ql/data ] && [ "$(ls -A /ql/data 2>/dev/null)" ]; then
    if [ ! "$(ls -A /config/qinglong/data 2>/dev/null)" ]; then
        bashio::log.info "Migrating existing data to persistent storage..."
        cp -rn /ql/data/* /config/qinglong/data/ 2>/dev/null || true
    fi
    rm -rf /ql/data
fi

# 确保 symlink（兜底硬编码 /ql/data 路径的访问）
if [ ! -L /ql/data ]; then
    rm -rf /ql/data 2>/dev/null || true
    ln -sf /config/qinglong/data /ql/data
fi

bashio::log.info "Qinglong initialization completed"
