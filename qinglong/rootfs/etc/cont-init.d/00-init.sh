#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Qinglong 初始化脚本
# ==============================================================================
# 将镜像内的 /ql 源码迁移到 /config/qinglong（HA 自动备份持久化）
# 保留 /ql 作为 symlink 兜底所有硬编码路径（shell 脚本、docker-entrypoint 等）

bashio::log.info "Initializing Qinglong..."

# 1. 首次启动：迁移源码到持久化目录（跳过 data 避免覆盖已有数据）
if [ ! -f /config/qinglong/run.py ]; then
    bashio::log.info "First boot: migrating source to persistent storage..."
    mkdir -p /config/qinglong
    find /ql -mindepth 1 -maxdepth 1 -not -name data \
        -exec cp -an {} /config/qinglong/ \;
fi

# 2. 确保 data 目录存在
mkdir -p /config/qinglong/data

# 3. 替换 /ql 为 symlink（兜底所有硬编码 /ql/xxx 路径）
#    QL_DIR 默认 = /ql → symlink → /config/qinglong
if [ ! -L /ql ]; then
    rm -rf /ql
    ln -sf /config/qinglong /ql
fi

# 4. 初始化 .env（上游 Dockerfile 同款操作，缺失会导致 app 崩溃）
if [ -f /ql/.env.example ] && [ ! -f /ql/.env ]; then
    bashio::log.info "Creating .env from .env.example..."
    cp /ql/.env.example /ql/.env
fi

bashio::log.info "Qinglong initialization completed"

rm -f /run/service/qinglong/down 2>/dev/null
