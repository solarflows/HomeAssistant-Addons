#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# QD-Today 初始化脚本
# ==============================================================================
# QD 不支持命令行/环境变量指定 config 目录，用 symlink 实现持久化
# 映射至 /config（由 addon_config:rw 提供，随 HA 备份持久化）

bashio::log.info "Initializing QD-Today..."

mkdir -p /config

# ---- 一次性存量数据迁移（服务启动成功后清理旧源） ----
if [ ! -f /config/.migrated ]; then
    MIGRATION_ITEMS=""
    if [ -d /data/qd ] && [ "$(ls -A /data/qd 2>/dev/null)" ] && [ ! "$(ls -A /config 2>/dev/null)" ]; then
        bashio::log.info "检测到历史 /data/qd 数据，迁移至 /config..."
        cp -an /data/qd/* /config/ 2>/dev/null || true
        MIGRATION_ITEMS="${MIGRATION_ITEMS} /data/qd"
    fi

    # 首次启动迁移内置数据
    if [ -d /usr/src/app/config ] && [ ! -L /usr/src/app/config ] && [ "$(ls -A /usr/src/app/config 2>/dev/null)" ]; then
        if [ ! "$(ls -A /config 2>/dev/null)" ]; then
            bashio::log.info "首次启动：迁移内置种子数据至 /config..."
            cp -rn /usr/src/app/config/* /config/ 2>/dev/null || true
        fi
        rm -rf /usr/src/app/config
    fi

    if [ -n "${MIGRATION_ITEMS}" ]; then
        echo "${MIGRATION_ITEMS}" > /run/migration_cleanup_pending
        bashio::log.info "已暂存迁移数据，待服务启动成功并验证后清空旧目录"
    else
        touch /config/.migrated
    fi
fi

# 创建符号链接指向 /config
if [ ! -L /usr/src/app/config ]; then
    rm -rf /usr/src/app/config
    ln -sf /config /usr/src/app/config
fi

bashio::log.info "QD-Today initialization completed"
