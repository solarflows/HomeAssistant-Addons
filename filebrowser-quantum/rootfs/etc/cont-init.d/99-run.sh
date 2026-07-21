#!/bin/bash
# shellcheck shell=bash
# ==============================================================================
# FileBrowser Quantum 启动脚本
# ==============================================================================

set -e

############
# TIMEZONE #
############

if [ -n "$TZ" ]; then
    echo "Setting timezone to $TZ"
    if [ -f /usr/share/zoneinfo/"$TZ" ]; then
        ln -snf /usr/share/zoneinfo/"$TZ" /etc/localtime
        echo "$TZ" > /etc/timezone
    fi
fi

############################
# FILEBROWSER CONFIGURATION #
############################

FILEBROWSER_CONFIG="/config/filebrowser-quantum/config.yaml"

# 确保配置文件存在
if [ ! -f "$FILEBROWSER_CONFIG" ]; then
    mkdir -p "$(dirname "$FILEBROWSER_CONFIG")"
    cp /home/filebrowser/data/config.yaml "$FILEBROWSER_CONFIG" 2>/dev/null || true
fi

# 更新配置
if [ -f "$FILEBROWSER_CONFIG" ]; then
    echo "Updating FileBrowser config..."

    # 设置端口
    yq e -i ".server.port = 8080" "$FILEBROWSER_CONFIG" 2>/dev/null || true
    yq e -i ".server.listen = \"0.0.0.0\"" "$FILEBROWSER_CONFIG" 2>/dev/null || true

    # 设置数据库路径
    yq e -i ".server.database = \"/config/filebrowser-quantum/database.db\"" "$FILEBROWSER_CONFIG" 2>/dev/null || true

    # 设置缓存目录
    yq e -i ".server.cacheDir = \"/cache\"" "$FILEBROWSER_CONFIG" 2>/dev/null || true
fi

######################
# LAUNCH FILEBROWSER #
######################

echo "Starting FileBrowser Quantum..."

# 使用配置文件启动
cd /home/filebrowser
exec ./filebrowser --config "$FILEBROWSER_CONFIG"
