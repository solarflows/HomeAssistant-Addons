#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox 初始化脚本 (纯本地离线秒启版)
# 负责存储路径映射、离线基础数据播种、H2 迁移，严禁包含任何阻塞式公网网络下载
# ==============================================================================
set -e

export INSTALL=xiaoya

# ---- HA addon JVM 内存基准 ----
LOW_MEMORY=$(bashio::config "LOW_MEMORY" "true")
if [ "${LOW_MEMORY}" = "true" ]; then
    export MEM_OPT="-Xmx512M"
else
    export MEM_OPT="-Xmx1024M"
fi
bashio::log.info "alist-tvbox JVM memory: ${MEM_OPT}"

# 确保持久化与配置目录存在
mkdir -p /config /config/alist /data/atv/config /data/log /data/index /data/index115 /data/atv /www/cgi-bin /www/cat /www/pg /www/zx /www/tvbox /var/cache/nginx/image

# 标记 H2 数据库版本，避免反复触发旧版本升级逻辑
[ -f /data/h2.version.txt ] || echo "2.3.232" > /data/h2.version.txt

# ---- 一次性存量数据迁移（服务启动成功后清理旧源） ----
if [ ! -f /config/.migrated ]; then
    MIGRATION_ITEMS=""
    # 双轨探测：若存量数据位于旧版 HA 路径 /legacy_ha/alist-tvbox，自动自愈迁移至 /config
    if [ -d /legacy_ha/alist-tvbox ] && [ ! -f /config/atv.mv.db ]; then
        bashio::log.info "检测到旧版 HA 路径 /legacy_ha/alist-tvbox 存量数据，自动自愈迁移..."
        cp -an /legacy_ha/alist-tvbox/* /config/ 2>/dev/null || true
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

# inDocker 检测：上游 entrypoint.sh 本身就存在于 /，用 symlink 兼容
[ -f /entrypoint.sh ] || ln -sf /docker/scripts/entrypoint.sh /entrypoint.sh

# 小雅大体积索引目录（保留在私有 /data/index，防止臃肿污染 HA 备份）
[ -e /index ] || ln -sf /data/index /index

# 桥接配置路径
[ -e /data/config ] || ln -sf /config /data/config
[ -e /opt/atv/config ] || ln -sf /config /opt/atv/config
[ -e /opt/atv/log ] || ln -sf /data/log /opt/atv/log

# 兼容上游 shell 脚本对 /data 下配置文件名硬编码的检索
for f in proxy.txt github_proxy.txt env my.json iptv.m3u; do
    if [ -f "/config/$f" ] && [ ! -e "/data/$f" ]; then
        ln -sf "/config/$f" "/data/$f"
    fi
done

# ---- 纯本地数据初始化与播种 (零公网请求) ----
if [ ! -f /config/alist/data.db ]; then
    bashio::log.info "首次启动：未检测到持久化数据库，正在从镜像预置包释放离线基础数据..."

    # 1. 解压 /var/lib/data.zip 获取初始 AList SQLite 库与 CGI 脚本
    mkdir -p /tmp/pxg
    unzip -q -o /var/lib/data.zip -d /tmp/pxg

    mv /tmp/pxg/data.db /config/alist/data.db

    sed -i 's!/"$after"!"$after"!' /tmp/pxg/search
    mv /tmp/pxg/search /www/cgi-bin/search
    mv /tmp/pxg/sou /www/cgi-bin/sou
    mv /tmp/pxg/whatsnew /www/cgi-bin/whatsnew
    mv /tmp/pxg/header.html /www/cgi-bin/header.html
    chmod +x /www/cgi-bin/*

    # 配置 AList config.json
    if [ ! -f /config/alist/config.json ]; then
        cp /alist.json /config/alist/config.json
        NEW_SECRET=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 16)
        sed -i "s/Y3JIG4vxT22wn9cq/${NEW_SECRET}/" /config/alist/config.json
        sed -i "s/127.0.0.1/0.0.0.0/" /config/alist/config.json
    fi

    if [ -f /tmp/pxg/mobi.tgz ]; then
        tar -zxf /tmp/pxg/mobi.tgz -C /www/ 2>/dev/null || true
    fi
    rm -rf /tmp/pxg

    # 2. 导入镜像预置小雅云盘列表 (/update.sql)
    if [ -f /update.sql ]; then
        bashio::log.info "正在载入镜像内置预设云盘 (/update.sql)..."
        sqlite3 /config/alist/data.db ".read /update.sql" || true
    fi

    # 3. 解包预置 tvbox 基础包
    if [ -f /tvbox.zip ]; then
        unzip -q -o /tvbox.zip -d /www/ || true
    fi

    # 4. 播种 115 索引种子
    if [ -f /115.index.zip ] && [ ! -d /data/index115 ]; then
        mkdir -p /data/index115.tmp
        unzip -q -o /115.index.zip -d /data/index115.tmp || true
        mv /data/index115.tmp /data/index115
    fi

    # 5. 解包分享索引初值
    if [ -f /index.share.zip ]; then
        unzip -q -o /index.share.zip -d /tmp/share_idx
        if [ -f /tmp/share_idx/index.share.txt ]; then
            cp -f /tmp/share_idx/index.share.txt /data/index/index.share.txt
            cp -f /tmp/share_idx/share_version /data/index/share_version 2>/dev/null || true
            cat /data/index/index.share.txt >> /data/index/index.video.txt 2>/dev/null || true
            cat /data/index/index.share.txt >> /data/index/index.txt 2>/dev/null || true
        fi
        rm -rf /tmp/share_idx
    fi

    echo "1" > /config/alist/.init
    bashio::log.info "离线基础数据播种完毕。"
else
    bashio::log.info "持久化数据已就绪，进入毫秒级离线快速启动..."

    # 热重启时，若容器文件系统为全新层，补齐 /www 下的非持久化脚本
    if [ ! -f /www/cgi-bin/search ]; then
        mkdir -p /tmp/pxg
        unzip -q -o /var/lib/data.zip -d /tmp/pxg
        sed -i 's!/"$after"!"$after"!' /tmp/pxg/search
        mv /tmp/pxg/search /www/cgi-bin/search
        mv /tmp/pxg/sou /www/cgi-bin/sou
        mv /tmp/pxg/whatsnew /www/cgi-bin/whatsnew
        mv /tmp/pxg/header.html /www/cgi-bin/header.html
        chmod +x /www/cgi-bin/*
        rm -rf /tmp/pxg
    fi

    if [ ! -d /www/tvbox ] && [ -f /tvbox.zip ]; then
        unzip -q -o /tvbox.zip -d /www/ || true
    fi
fi

# 解压 cat/pg/zx 爬虫解析包
if [ ! -d /www/cat ] || [ -z "$(ls -A /www/cat 2>/dev/null)" ]; then
    [ -f /cat.zip ] && unzip -q -o /cat.zip -d /www/cat || true
fi
[ -d /data/cat ] && cp -r /data/cat/* /www/cat/ 2>/dev/null || true

if [ ! -d /www/pg ] || [ -z "$(ls -A /www/pg 2>/dev/null)" ]; then
    [ -f /pg.zip ] && unzip -q -o /pg.zip -d /www/pg || true
fi
[ -d /data/pg ] && cp -r /data/pg/* /www/pg/ 2>/dev/null || true

if [ ! -d /www/zx ] || [ -z "$(ls -A /www/zx 2>/dev/null)" ]; then
    [ -f /zx.zip ] && unzip -q -o /zx.zip -d /www/zx || true
fi
[ -d /data/zx ] && cp -r /data/zx/* /www/zx/ 2>/dev/null || true

# 电影数据基线纯本地检查（与镜像 /base_version 比对）
if [ -f /data.zip ] && [ -f /base_version ]; then
    LOCAL="0.0.0"
    [ -f /data/atv/base_version ] && LOCAL=$(head -n1 /data/atv/base_version)
    REMOTE=$(head -n1 /base_version)
    if [ "$LOCAL" != "$REMOTE" ]; then
        bashio::log.info "检测到镜像自带更新版电影基线 (local=${LOCAL}, remote=${REMOTE})，解包中..."
        unzip -q -o /data.zip -d /data/atv/
        cp /base_version /data/atv/base_version
        rm -f /data/atv/sql/*.sql /data/atv/movie_version 2>/dev/null || true
    fi
fi

# 挂载用户自定义 TvBox 配置
if [ -f /config/my.json ]; then
    rm -f /www/tvbox/my.json
    ln -sf /config/my.json /www/tvbox/my.json
fi
if [ -f /config/iptv.m3u ]; then
    rm -f /www/tvbox/iptv.m3u
    ln -sf /config/iptv.m3u /www/tvbox/iptv.m3u
fi

bashio::log.info "alist-tvbox 纯本地初始化完成。"
