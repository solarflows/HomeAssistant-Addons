#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# QD-Today 初始化脚本
# ==============================================================================
# QD 不支持命令行/环境变量指定 config 目录，用 symlink 实现持久化
# /data/qd → addon 私有工作目录（数据库、运行时数据），不污染 /config

bashio::log.info "Initializing QD-Today..."

# 持久化数据目录（/data 为 HA supervisor 按 addon 分配的私有卷）
mkdir -p /data/qd

# 首次启动迁移内置数据
if [ -d /usr/src/app/config ] && [ ! -L /usr/src/app/config ] && [ "$(ls -A /usr/src/app/config 2>/dev/null)" ]; then
    if [ ! "$(ls -A /data/qd 2>/dev/null)" ]; then
        bashio::log.info "Migrating initial data to /data/qd..."
        cp -rn /usr/src/app/config/* /data/qd/ 2>/dev/null || true
    fi
    rm -rf /usr/src/app/config
fi

# 创建符号链接
if [ ! -L /usr/src/app/config ]; then
    rm -rf /usr/src/app/config
    ln -sf /data/qd /usr/src/app/config
fi

bashio::log.info "QD-Today initialization completed"
