#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# CLIProxyAPI + CPAMP 初始化脚本
# ==============================================================================
# 数据布局:
#   /config/cliproxyapi-cpamp/config.yaml          主配置（首次启动生成）
#   /config/cliproxyapi-cpamp/auths/               OAuth 凭据（随 HA 备份）
#   /config/cliproxyapi-cpamp/management_key.txt   管理密钥明文副本
#   /config/cliproxyapi-cpamp/cpamp/               CPAMP 数据（usage.sqlite/data.key，随 HA 备份）
#   /data/cliproxyapi-cpamp/{logs,plugins,static}  日志/插件/面板缓存（不备份）
# ==============================================================================
set -e

bashio::log.info "Initializing CLIProxyAPI + CPAMP..."

CONFIG_DIR="/config/cliproxyapi-cpamp"
DATA_DIR="/data/cliproxyapi-cpamp"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"
AUTH_DIR="${CONFIG_DIR}/auths"
CPAMP_DATA_DIR="${CONFIG_DIR}/cpamp"

################
# DIRS         #
################
mkdir -p "${CONFIG_DIR}" "${AUTH_DIR}" "${CPAMP_DATA_DIR}" \
         "${DATA_DIR}/logs" "${DATA_DIR}/plugins" "${DATA_DIR}/static" "${DATA_DIR}/discovery"

################
# CONFIG FILE  #
################
# 仅首次启动生成；之后配置完全由用户/管理面板接管（seed-once 语义）
if [ ! -f "${CONFIG_FILE}" ]; then
    MANAGEMENT_KEY=$(bashio::config 'MANAGEMENT_KEY' '')
    if [ -z "${MANAGEMENT_KEY}" ]; then
        MANAGEMENT_KEY="$(head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')"
        bashio::log.warning "MANAGEMENT_KEY 未配置，已生成随机管理密钥（面板登录 / API 管理 / CPAMP 连接均使用）"
    fi
    printf '%s' "${MANAGEMENT_KEY}" > "${CONFIG_DIR}/management_key.txt"
    chmod 600 "${CONFIG_DIR}/management_key.txt"

    # YAML 双引号字符串转义（防注入/解析失败）
    MANAGEMENT_KEY_ESC=${MANAGEMENT_KEY//\\/\\\\}
    MANAGEMENT_KEY_ESC=${MANAGEMENT_KEY_ESC//\"/\\\"}

    PROXY_URL=$(bashio::config 'PROXY_URL' '')

    {
        cat << 'YAML'
# CLIProxyAPI v8 配置（由 addon 首次启动生成）
config-version: 8

# 管理 API / 管理面板
management:
  # 允许非本机（局域网浏览器）访问管理 API；管理面板本身仍需密钥
  allow-remote: true
  disable-control-panel: false
  # 管理面板 GitHub 仓库（CPAMP 轻量版，CPA 会按此自动更新面板）
  panel-github-repository: "https://github.com/seakee/CPA-Manager-Plus"
YAML
        printf '  secret-key: "%s"\n' "${MANAGEMENT_KEY_ESC}"
        cat << 'YAML'

# 客户端访问密钥（占位符会触发 CPA 安全模式，请在管理面板中替换为真实密钥）
access:
  api-keys:
    - "your-api-key-1"

# OAuth/文件凭据目录（持久化，随 HA 备份）
oauth:
  auth-dir: "/config/cliproxyapi-cpamp/auths"

# 用量统计（CPAMP 请求监控依赖此项）
observability:
  usage:
    usage-statistics-enabled: true
YAML
        if [ -n "${PROXY_URL}" ]; then
            PROXY_URL_ESC=${PROXY_URL//\\/\\\\}
            PROXY_URL_ESC=${PROXY_URL_ESC//\"/\\\"}
            printf '\n# 上游请求代理（也可在管理面板中修改）\nrequests:\n  proxy-url: "%s"\n' "${PROXY_URL_ESC}"
        fi
    } > "${CONFIG_FILE}"

    bashio::log.info "已生成默认配置: ${CONFIG_FILE}"
    bashio::log.info "管理密钥同时保存在: ${CONFIG_DIR}/management_key.txt"
fi

################
# SYMLINKS     #
################
# 上游默认认证目录 → 持久化 auths（配置中已显式指定 auth-dir，此处为双保险）
ln -sfn "${AUTH_DIR}" /root/.cli-proxy-api

# 应用工作目录内的相对路径 → 持久化 /data
ln -sfn "${DATA_DIR}/logs" /CLIProxyAPI/logs
ln -sfn "${DATA_DIR}/plugins" /CLIProxyAPI/plugins
ln -sfn "${CONFIG_FILE}" /CLIProxyAPI/config.yaml

################
# PANEL SEED   #
################
# 管理面板种子文件（构建时固定版本；CPA 联网后会按 panel-github-repository 自动更新）
if [ ! -s "${DATA_DIR}/static/management.html" ]; then
    cp -f /opt/cliproxyapi-seed/management.html "${DATA_DIR}/static/management.html"
    bashio::log.info "已从镜像种子恢复 CPAMP 管理面板（联网后将自动检查更新）"
fi

bashio::log.info "Initialization completed; CPAMP Manager Server will start on :18317"