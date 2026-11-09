#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Baihu Panel 初始化脚本
# 零软链架构：app_config 直挂 /app/data，双轨自愈探测 /legacy_ha
# ==============================================================================

bashio::log.info "Initializing Baihu Panel..."

mkdir -p /app/data /app/configs /data/mise

# ---- 双轨存量自愈平滑迁移（一次性探测老 Core /legacy_ha 目录） ----
if [ ! -f /app/data/.migrated_from_legacy ]; then
    MIGRATION_SRC=""
    if [ -d /legacy_ha/baihu-panel ] && [ ! -f /app/data/baihu.db ]; then
        MIGRATION_SRC="/legacy_ha/baihu-panel"
    elif [ -d /legacy_ha/baihu ] && [ ! -f /app/data/baihu.db ]; then
        MIGRATION_SRC="/legacy_ha/baihu"
    fi

    if [ -n "${MIGRATION_SRC}" ]; then
        bashio::log.info "检测到历史 Core 存量数据 (${MIGRATION_SRC})，执行一次性增量平移..."
        if [ -d "${MIGRATION_SRC}/data" ]; then
            cp -an "${MIGRATION_SRC}/data/." /app/data/ 2>/dev/null || true
        else
            cp -an "${MIGRATION_SRC}/." /app/data/ 2>/dev/null || true
        fi
        touch /app/data/.migrated_from_legacy
        echo "${MIGRATION_SRC}" > /run/migration_cleanup_pending
        bashio::log.info "存量数据平移完成，服务启动验证通过后将登记清理。"
    else
        touch /app/data/.migrated_from_legacy
    fi
fi

# ---- mise 运行时环境 (存放于 /data/mise 私有卷，避开 HA 备份膨胀) ----
if [ -d /opt/mise-base ] && [ -z "$(ls -A /data/mise 2>/dev/null)" ]; then
    bashio::log.info "同步内置 mise 运行时环境基座至 /data/mise..."
    rsync -a /opt/mise-base/ /data/mise/ 2>/dev/null || cp -a /opt/mise-base/. /data/mise/ 2>/dev/null || true
fi

# ---- 导出运行环境变量 (端口/host/DB路径均为内部实现，不暴露用户配置) ----
export BH_SERVER_PORT=8052
export BH_SERVER_HOST=0.0.0.0
export BH_DB_PATH=/app/data/baihu.db

bashio::log.info "Baihu Panel config: port=${BH_SERVER_PORT}, host=${BH_SERVER_HOST}, db=${BH_DB_PATH}"

# 生成初始化放行锁屏障
touch /run/baihu-initialized
bashio::log.info "Baihu Panel initialization completed"
