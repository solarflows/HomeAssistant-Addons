#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# FileBrowser Quantum 初始化脚本
# ==============================================================================
set -e

bashio::log.info "Initializing FileBrowser Quantum..."

################
# DIRS         #
################
# ---- 双轨存量自愈平滑迁移（一次性探测老 Core /homeassistant 目录） ----
if [ ! -f /config/.migrated_from_legacy ]; then
    if [ -d /homeassistant/filebrowser-quantum ] && [ ! -f /config/config.yaml ]; then
        bashio::log.info "检测到历史 Core 存量数据，自动平铺至 /config 根目录..."
        cp -an /homeassistant/filebrowser-quantum/. /config/ 2>/dev/null || true
        echo "/homeassistant/filebrowser-quantum" > /run/migration_cleanup_pending
    else
        touch /config/.migrated_from_legacy
    fi
fi

mkdir -p /config /cache

################
# CONFIG FILE  #
################
FILEBROWSER_CONFIG="/config/config.yaml"
DEFAULT_CONFIG="/usr/local/share/filebrowser/config.yaml"

# 复制默认配置 (首次启动)
if [ ! -f "$FILEBROWSER_CONFIG" ]; then
    # 生成最小默认配置
    cat > "$FILEBROWSER_CONFIG" << 'YAML'
http:
  port: 8080
  listen: 0.0.0.0
server:
  database:
    path: /config/filebrowser.sqlite
  cacheDir: /cache
  sources:
    - path: /
      name: Default
      config:
        defaultUserScope: /
auth:
  methods:
    noauth: false
    password:
      enabled: true
    proxy:
      enabled: false
    oidc:
      enabled: false
YAML
    bashio::log.info "Default config created at ${FILEBROWSER_CONFIG}"
fi

################
# SERVER & HTTP#
################
bashio::log.info "Applying server & http config..."
# 清理可能存在的历史遗留字段（避免 DisallowUnknownField 报错）
yq e -i 'del(.server.port) | del(.server.listen)' "$FILEBROWSER_CONFIG"
if [ "$(yq e '.server.database | type' "$FILEBROWSER_CONFIG" 2>/dev/null)" = "!!str" ]; then
    yq e -i 'del(.server.database)' "$FILEBROWSER_CONFIG"
fi

# 兼容历史 database.db 文件迁移（gtsteffaniak/filebrowser 要求旧库重命名为 .old 触发自动迁移）
if [ -f /config/database.db ] && [ ! -f /config/filebrowser.sqlite ]; then
    bashio::log.info "检测到历史 database.db，更名为 database.db.old 以便触发自动迁移..."
    mv -f /config/database.db /config/database.db.old
    yq e -i '.server.database.migrateFrom = "/config/database.db.old"' "$FILEBROWSER_CONFIG"
fi

yq e -i '.http.port = 8080'                                    "$FILEBROWSER_CONFIG"
yq e -i '.http.listen = "0.0.0.0"'                             "$FILEBROWSER_CONFIG"
yq e -i '.server.database.path = "/config/filebrowser.sqlite"' "$FILEBROWSER_CONFIG"
yq e -i '.server.cacheDir = "/cache"'                          "$FILEBROWSER_CONFIG"

################
# USER SCOPE   #
################
DEFAULT_USER_SCOPE=$(bashio::config 'default_user_scope' '/')
if [ "${DEFAULT_USER_SCOPE:0:1}" != "/" ]; then
    bashio::log.fatal "default_user_scope must be an absolute path"
    exit 1
fi
if [ ! -d "$DEFAULT_USER_SCOPE" ]; then
    bashio::log.warning "default_user_scope '${DEFAULT_USER_SCOPE}' does not exist, using /"
    DEFAULT_USER_SCOPE="/"
fi
bashio::log.info "Default user scope: ${DEFAULT_USER_SCOPE}"
yq e -i ".server.sources[0].path = \"${DEFAULT_USER_SCOPE}\""                         "$FILEBROWSER_CONFIG"
yq e -i ".server.sources[0].config.defaultUserScope = \"${DEFAULT_USER_SCOPE}\""      "$FILEBROWSER_CONFIG"

################
# AUTH METHOD  #
################
AUTH_METHOD=$(bashio::config 'auth_method' 'password')
bashio::log.info "Auth method: ${AUTH_METHOD}"
case "$AUTH_METHOD" in
    noauth)
        yq e -i '.auth.methods.noauth = true'             "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.password.enabled = false'  "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.proxy.enabled = false'     "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.oidc.enabled = false'      "$FILEBROWSER_CONFIG"
        ;;
    proxy)
        yq e -i '.auth.methods.noauth = false'            "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.password.enabled = false'  "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.proxy.enabled = true'      "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.oidc.enabled = false'      "$FILEBROWSER_CONFIG"
        ;;
    oidc)
        yq e -i '.auth.methods.noauth = false'            "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.password.enabled = false'  "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.proxy.enabled = false'     "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.oidc.enabled = true'       "$FILEBROWSER_CONFIG"
        ;;
    password|*)
        yq e -i '.auth.methods.noauth = false'            "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.password.enabled = true'   "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.proxy.enabled = false'     "$FILEBROWSER_CONFIG"
        yq e -i '.auth.methods.oidc.enabled = false'      "$FILEBROWSER_CONFIG"
        ;;
esac

bashio::log.info "FileBrowser Quantum initialization completed"
