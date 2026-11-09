#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox-standalone 初始化脚本
# ==============================================================================
# /data 由 HAOS Supervisor 自动挂载

bashio::log.info "Initializing alist-tvbox-standalone..."

# 确保持久化目录存在（/config 映射自 addon_config:rw）
mkdir -p /config /data/log

# 标记 H2 数据库版本，避免新装或已升级系统反复触发旧版本升级逻辑
[ -f /data/h2.version.txt ] || echo "2.3.232" > /data/h2.version.txt

# ---- 一次性存量数据迁移（服务启动成功后清理旧源） ----
if [ ! -f /config/.migrated ]; then
    MIGRATION_ITEMS=""
    if [ -f /data/atv.mv.db ] && [ ! -f /config/atv.mv.db ]; then
        bashio::log.info "检测到历史 atv.mv.db 数据库，迁移至 /config..."
        cp -an /data/atv.mv.db* /config/ 2>/dev/null || true
        MIGRATION_ITEMS="${MIGRATION_ITEMS} /data/atv.mv.db*"
    fi
    if [ -d /data/store ] && [ ! -d /config/store ]; then
        bashio::log.info "检测到历史 store 目录，迁移至 /config..."
        cp -an /data/store /config/ 2>/dev/null || true
        MIGRATION_ITEMS="${MIGRATION_ITEMS} /data/store"
    fi

    if [ -n "${MIGRATION_ITEMS}" ]; then
        echo "${MIGRATION_ITEMS}" > /run/migration_cleanup_pending
        bashio::log.info "已暂存迁移数据，待服务启动成功并验证后清空旧目录"
    else
        touch /config/.migrated
    fi
fi

# 兼容用户放置在 /config 中的 database.zip 恢复包
if [ -f /config/database.zip ] && [ ! -e /data/database.zip ]; then
    cp -an /config/database.zip /data/database.zip
fi

# ---- 读取 HA addon 配置选项并导出为环境变量 ----
LOW_MEMORY=$(bashio::config 'LOW_MEMORY' 'true')
if [ "${LOW_MEMORY}" = "true" ]; then
    export MEM_OPT="-Xmx512M"
else
    export MEM_OPT="-Xmx1024M"
fi
bashio::log.info "alist-tvbox-standalone JVM memory: ${MEM_OPT}"

# 上游 inDocker 检测需要 /entrypoint.sh 存在
[ -f /entrypoint.sh ] || ln -sf /docker/scripts/entrypoint.sh /entrypoint.sh

# 调用上游初始化脚本（配置 AList 等）
bashio::log.info "Running upstream initialization..."
export INSTALL=new
set +e
/docker/scripts/init-alist.sh 2>&1 | tee /data/log/init.log
init_exit=${PIPESTATUS[0]}
set -e
if [ ${init_exit} -ne 0 ]; then
    bashio::log.warning "init-alist.sh exited with code ${init_exit} (non-fatal, continuing)"
fi

touch /run/atv-initialized
bashio::log.info "alist-tvbox-standalone initialization completed"
