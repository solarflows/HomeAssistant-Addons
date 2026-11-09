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
# ---- 一次性兼容历史子目录平铺（服务启动成功后清理旧源） ----
if [ ! -f /config/.migrated ]; then
    if [ -d /config/filebrowser-quantum ] && [ ! -f /config/config.yaml ]; then
        bashio::log.info "检测到历史 filebrowser-quantum 子目录，自动平铺至 /config 根目录..."
        cp -an /config/filebrowser-quantum/. /config/
        echo "/config/filebrowser-quantum" > /run/migration_cleanup_pending
    else
        touch /config/.migrated
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
server:
  port: 8080
  listen: 0.0.0.0
  database: /config/database.db
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
# SERVER       #
################
bashio::log.info "Applying server config..."
yq e -i '.server.port = 8080'                      "$FILEBROWSER_CONFIG"
yq e -i '.server.listen = "0.0.0.0"'               "$FILEBROWSER_CONFIG"
yq e -i '.server.database = "/config/database.db"' "$FILEBROWSER_CONFIG"
yq e -i '.server.cacheDir = "/cache"'               "$FILEBROWSER_CONFIG"

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

touch /run/filebrowser-initialized
bashio::log.info "FileBrowser Quantum initialization completed"
