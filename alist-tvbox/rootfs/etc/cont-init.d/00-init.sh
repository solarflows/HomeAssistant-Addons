#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox 初始化脚本
# 等价于上游 entrypoint.sh 的初始化部分（去掉 JVM 启动，由 S6 longrun 接管）
# ==============================================================================

export INSTALL=xiaoya

# ---- HA addon 配置 ----
LOW_MEMORY=$(bashio::config "LOW_MEMORY" "true")
if [ "${LOW_MEMORY}" = "true" ]; then
    export MEM_OPT="-Xmx512M"
else
    export MEM_OPT="-Xmx1024M"
fi
bashio::log.info "alist-tvbox JVM memory: ${MEM_OPT}"

# 确保持久化与配置目录存在
mkdir -p /config /config/alist /data/atv/config/ /data/log /data/index

# 标记 H2 数据库版本，避免反复触发旧版本升级逻辑
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
    if [ -d /data/alist ] && [ ! -f /config/alist/data.db ] && [ ! -f /config/alist/config.json ]; then
        bashio::log.info "检测到历史 /data/alist 数据，迁移至 /config/alist 目录..."
        cp -an /data/alist/* /config/alist/ 2>/dev/null || true
        MIGRATION_ITEMS="${MIGRATION_ITEMS} /data/alist"
    fi

    # 迁移历史散落配置文件至 /config
    for f in proxy.txt github_proxy.txt env my.json iptv.m3u; do
        if [ -f "/data/$f" ] && [ ! -e "/config/$f" ]; then
            mv "/data/$f" "/config/$f" 2>/dev/null || true
        fi
    done

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

# ---- AList 与上游脚本路径桥接 ----
# AList 数据持久化定向至 /config/alist
rm -rf /opt/alist/data
ln -sf /config/alist /opt/alist/data

# inDocker 检测：上游 entrypoint.sh 本身就存在于 /，我们用 symlink 兼容
[ -f /entrypoint.sh ] || ln -sf /docker/scripts/entrypoint.sh /entrypoint.sh

# 确保小雅大体积索引目录存在（保留在私有 /data/index，防止臃肿污染 HA 备份）
[ -e /index ] || ln -sf /data/index /index

# 兼容上游 shell 脚本对 /data 下配置文件名硬编码的检索（如 proxy.txt, my.json 等）
for f in proxy.txt github_proxy.txt env my.json iptv.m3u; do
    if [ -f "/config/$f" ] && [ ! -e "/data/$f" ]; then
        ln -sf "/config/$f" "/data/$f"
    fi
done

# ---- 以下与上游 entrypoint.sh 保持一致 ----
. /docker/scripts/lib/common.sh
. /docker/scripts/lib/proxy.sh

load_custom_env
setup_env_proxy
chmod a+x /docker/scripts/*.sh /docker/scripts/lib/*.sh
ensure_dir /data/log

bashio::log.info "Running upstream init-xiaoya.sh..."
# init-xiaoya.sh 有 set -e，某些步骤（索引下载、grep 等）可能非致命失败
# 记录退出码但不传播给 S6，防止 cont-init 标记为 failed 导致容器重启
set +e
/docker/scripts/init-xiaoya.sh 2>&1 | tee /data/log/init.log
init_exit=${PIPESTATUS[0]}
set -e
if [ ${init_exit} -ne 0 ]; then
    bashio::log.warning "init-xiaoya.sh exited with code ${init_exit} (non-fatal, continuing)"
fi

touch /run/atv-initialized
bashio::log.info "alist-tvbox initialization completed"
