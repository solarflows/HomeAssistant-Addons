#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Baihu Panel 初始化脚本
# ==============================================================================

bashio::log.info "Initializing Baihu Panel..."

mkdir -p /config

# ---- 一次性兼容历史子目录平铺（服务启动成功后清理旧源） ----
if [ ! -f /config/.migrated ]; then
    MIGRATION_ITEMS=""
    if [ -d /config/baihu-panel ] && [ ! -d /config/data ]; then
        bashio::log.info "检测到历史 baihu-panel 子目录，平铺至 /config 根目录..."
        cp -an /config/baihu-panel/. /config/
        MIGRATION_ITEMS="${MIGRATION_ITEMS} /config/baihu-panel"
    fi
    if [ -d /config/baihu ]; then
        cp -an /config/baihu/. /config/ 2>/dev/null || true
        MIGRATION_ITEMS="${MIGRATION_ITEMS} /config/baihu"
    fi

    if [ -n "${MIGRATION_ITEMS}" ]; then
        echo "${MIGRATION_ITEMS}" > /run/migration_cleanup_pending
    else
        touch /config/.migrated
    fi
fi

# 创建持久化目录
mkdir -p /config/data /config/configs /config/envs /config/mise /app/envs

# /app/data 持久化（脚本、WebUI 等用户数据）
if [ ! -L /app/data ]; then
    rm -rf /app/data
    ln -sf /config/data /app/data
fi

# ---- mise 运行时环境 ----
if [ ! -L /app/envs/mise ]; then
    ln -sf /config/mise /app/envs/mise
fi
# 从预装基座同步 mise 环境（--ignore-existing 保护用户自定义的 runtime）
if [ -d /opt/mise-base ]; then
    rsync -a --ignore-existing /opt/mise-base/ /app/envs/mise/ || true
fi

# 链接配置目录
if [ ! -L /app/configs ]; then
    rm -rf /app/configs
    ln -sf /config/configs /app/configs
fi

# ---- 导出运行环境变量 (端口/host/DB路径均为内部实现，不暴露用户配置) ----
export BH_SERVER_PORT=8052
export BH_SERVER_HOST=0.0.0.0
export BH_DB_PATH=/config/data/baihu.db

bashio::log.info "Baihu Panel config: port=${BH_SERVER_PORT}, host=${BH_SERVER_HOST}"

bashio::log.info "Baihu Panel initialization completed"
