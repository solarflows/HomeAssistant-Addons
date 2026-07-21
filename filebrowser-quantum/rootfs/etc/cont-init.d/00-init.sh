#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# FileBrowser Quantum 初始化脚本
# ==============================================================================

bashio::log.info "Initializing FileBrowser Quantum..."

# 创建持久化目录
mkdir -p /config/filebrowser-quantum
mkdir -p /cache

# 创建默认配置（如果不存在）
FILEBROWSER_CONFIG="/config/filebrowser-quantum/config.yaml"

if [ ! -f "$FILEBROWSER_CONFIG" ]; then
    bashio::log.info "Creating default FileBrowser Quantum configuration..."
    mkdir -p "$(dirname "$FILEBROWSER_CONFIG")"

    cat > "$FILEBROWSER_CONFIG" << 'EOF'
server:
  port: 8080
  listen: "0.0.0.0"
  database: "/config/filebrowser-quantum/database.db"
  cacheDir: "/cache"
  baseURL: "/"
  sources:
    - path: "/"
      name: "Default"

auth:
  methods:
    password:
      enabled: true
    noauth:
      enabled: false
    proxy:
      enabled: false
    oidc:
      enabled: false
EOF
fi

bashio::log.info "FileBrowser Quantum initialization completed"
