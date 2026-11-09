#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Qinglong 初始化脚本
# ==============================================================================
# 将镜像内的 /ql 源码迁移到 /config（HA 自动备份持久化）
# 保留 /ql 作为 symlink 兜底所有硬编码路径（shell 脚本、docker-entrypoint 等）

bashio::log.info "Initializing Qinglong..."

mkdir -p /config

# ---- 一次性兼容历史子目录平铺（服务启动成功后清理旧源） ----
if [ ! -f /config/.migrated ]; then
    if [ -d /config/qinglong ] && [ ! -f /config/run.py ]; then
        bashio::log.info "检测到历史 qinglong 子目录，平铺至 /config 根目录..."
        cp -an /config/qinglong/. /config/
        echo "/config/qinglong" > /run/migration_cleanup_pending
    else
        touch /config/.migrated
    fi
fi

# 1. 首次启动：迁移源码到持久化目录（跳过 data 避免覆盖已有数据）
if [ ! -f /config/run.py ]; then
    bashio::log.info "First boot: migrating source to persistent storage..."
    find /ql -mindepth 1 -maxdepth 1 -not -name data \
        -exec cp -an {} /config/ \;
fi

# 2. 确保 data 目录存在
mkdir -p /config/data

# 3. 替换 /ql 为 symlink（兜底所有硬编码 /ql/xxx 路径）
#    QL_DIR 默认 = /ql → symlink → /config
if [ ! -L /ql ]; then
    rm -rf /ql
    ln -sf /config /ql
fi

# 4. 初始化 .env（上游 Dockerfile 同款操作，缺失会导致 app 崩溃）
if [ -f /ql/.env.example ] && [ ! -f /ql/.env ]; then
    bashio::log.info "Creating .env from .env.example..."
    cp /ql/.env.example /ql/.env
fi

touch /run/qinglong-initialized
bashio::log.info "Qinglong initialization completed"
