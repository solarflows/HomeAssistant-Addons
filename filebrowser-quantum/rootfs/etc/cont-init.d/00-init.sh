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
mkdir -p /config/filebrowser-quantum /cache

################
# CONFIG FILE  #
################
FILEBROWSER_CONFIG="/config/filebrowser-quantum/config.yaml"
DEFAULT_CONFIG="/usr/local/share/filebrowser/config.yaml"

# 复制默认配置 (首次启动)
if [ ! -f "$FILEBROWSER_CONFIG" ]; then
    # 生成最小默认配置
    cat > "$FILEBROWSER_CONFIG" << 'YAML'
server:
  port: 8080
  listen: 0.0.0.0
  database: /config/filebrowser-quantum/database.db
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
yq e -i '.server.database = "/config/filebrowser-quantum/database.db"' "$FILEBROWSER_CONFIG"
yq e -i '.server.cacheDir = "/cache"'               "$FILEBROWSER_CONFIG"

# Ingress baseURL
INGRESS_ENTRY=$(bashio::addon.ingress_entry)
if [ -n "$INGRESS_ENTRY" ] && [ "$INGRESS_ENTRY" != "/" ]; then
    bashio::log.info "Setting baseURL to ${INGRESS_ENTRY}"
    yq e -i ".server.baseURL = \"${INGRESS_ENTRY}\"" "$FILEBROWSER_CONFIG"
fi

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

rm -f /run/service/filebrowser-quantum/down 2>/dev/null