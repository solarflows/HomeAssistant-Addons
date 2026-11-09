#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# QD-Today 初始化脚本
# ==============================================================================
# QD 不支持命令行/环境变量指定 config 目录，用 symlink 实现持久化
# 映射至 /config（由 addon_config:rw 提供，随 HA 备份持久化）

bashio::log.info "Initializing QD-Today..."

mkdir -p /config

# 兼容存量升级：若 /data/qd 存在且 /config 为空，则自动迁移旧数据
if [ -d /data/qd ] && [ "$(ls -A /data/qd 2>/dev/null)" ] && [ ! "$(ls -A /config 2>/dev/null)" ]; then
    bashio::log.info "Migrating historical /data/qd to /config..."
    cp -an /data/qd/* /config/ 2>/dev/null || true
fi

# 首次启动迁移内置数据
if [ -d /usr/src/app/config ] && [ ! -L /usr/src/app/config ] && [ "$(ls -A /usr/src/app/config 2>/dev/null)" ]; then
    if [ ! "$(ls -A /config 2>/dev/null)" ]; then
        bashio::log.info "Migrating initial data to /config..."
        cp -rn /usr/src/app/config/* /config/ 2>/dev/null || true
    fi
    rm -rf /usr/src/app/config
fi

# 创建符号链接
if [ ! -L /usr/src/app/config ]; then
    rm -rf /usr/src/app/config
    ln -sf /config /usr/src/app/config
fi

bashio::log.info "QD-Today initialization completed"
