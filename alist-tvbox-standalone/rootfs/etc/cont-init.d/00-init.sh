#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox-standalone 初始化脚本 (纯本地离线秒启版)
# ==============================================================================
set -e

bashio::log.info "Initializing alist-tvbox-standalone..."

# 确保持久化与配置目录存在
mkdir -p /config /data/atv/config /data/log /data/atv /data/index /www/cat /www/pg /www/zx /www/tvbox

# 标记 H2 数据库版本，避免反复触发旧版本升级逻辑
[ -f /data/h2.version.txt ] || echo "2.3.232" > /data/h2.version.txt

# ---- 一次性存量数据迁移（服务启动成功后清理旧源） ----
if [ ! -f /config/.migrated ]; then
    MIGRATION_ITEMS=""
    if [ -d /legacy_ha/alist-tvbox-standalone ] && [ ! -f /config/atv.mv.db ]; then
        bashio::log.info "检测到旧版 HA 路径存量数据，自动自愈迁移..."
        cp -an /legacy_ha/alist-tvbox-standalone/* /config/ 2>/dev/null || true
    fi

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

# ---- 环境变量与路径桥接 ----
LOW_MEMORY=$(bashio::config 'LOW_MEMORY' 'true')
if [ "${LOW_MEMORY}" = "true" ]; then
    export MEM_OPT="-Xmx512M"
else
    export MEM_OPT="-Xmx1024M"
fi
bashio::log.info "alist-tvbox-standalone JVM memory: ${MEM_OPT}"

[ -f /entrypoint.sh ] || ln -sf /docker/scripts/entrypoint.sh /entrypoint.sh
[ -e /data/config ] || ln -sf /config /data/config
[ -e /opt/atv/config ] || ln -sf /config /opt/atv/config
[ -e /opt/atv/log ] || ln -sf /data/log /opt/atv/log
[ -e /index ] || ln -sf /data/index /index

for f in proxy.txt github_proxy.txt env my.json iptv.m3u; do
    if [ -f "/config/$f" ] && [ ! -e "/data/$f" ]; then
        ln -sf "/config/$f" "/data/$f"
    fi
done

# ---- 纯本地基础资源准备 (0 网络依赖) ----
# 解压 tvbox 静态包
if [ ! -d /www/tvbox ] || [ -z "$(ls -A /www/tvbox 2>/dev/null)" ]; then
    if [ -f /tvbox.zip ]; then
        unzip -q -o /tvbox.zip -d /www/ || true
    elif [ -f /data/tvbox.zip ]; then
        unzip -q -o /data/tvbox.zip -d /www/ || true
    fi
fi

# 解压爬虫包
for pkg in cat pg zx; do
    if [ ! -d "/www/$pkg" ] || [ -z "$(ls -A "/www/$pkg" 2>/dev/null)" ]; then
        if [ -f "/${pkg}.zip" ]; then
            unzip -q -o "/${pkg}.zip" -d "/www/$pkg" || true
        elif [ -f "/data/${pkg}.zip" ]; then
            unzip -q -o "/data/${pkg}.zip" -d "/www/$pkg" || true
        fi
    fi
done

# 电影数据基线比对
if [ -f /data.zip ] || [ -f /data/data.zip ]; then
    ZIP_PATH="/data.zip"
    [ -f /data/data.zip ] && ZIP_PATH="/data/data.zip"
    BASE_VER="/base_version"
    [ -f /data/base_version ] && BASE_VER="/data/base_version"
    
    if [ -f "${BASE_VER}" ]; then
        LOCAL="0.0.0"
        [ -f /data/atv/base_version ] && LOCAL=$(head -n1 /data/atv/base_version)
        REMOTE=$(head -n1 "${BASE_VER}")
        if [ "$LOCAL" != "$REMOTE" ]; then
            bashio::log.info "检测到新版电影基线数据，更新中..."
            unzip -q -o "${ZIP_PATH}" -d /data/atv/
            cp "${BASE_VER}" /data/atv/base_version
            rm -f /data/atv/sql/*.sql /data/atv/movie_version 2>/dev/null || true
        fi
    fi
fi

# 挂载用户自定义配置
if [ -f /config/my.json ]; then
    rm -f /www/tvbox/my.json
    ln -sf /config/my.json /www/tvbox/my.json
fi
if [ -f /config/iptv.m3u ]; then
    rm -f /www/tvbox/iptv.m3u
    ln -sf /config/iptv.m3u /www/tvbox/iptv.m3u
fi

bashio::log.info "alist-tvbox-standalone initialization completed"
