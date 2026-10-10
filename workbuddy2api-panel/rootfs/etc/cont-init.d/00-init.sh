#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# WorkBuddy2API Panel 初始化脚本
# ==============================================================================
# 数据布局:
#   /config/workbuddy2api-panel/config.json    主配置（首次启动生成，面板接管）
#   /config/workbuddy2api-panel/auths/         账号凭据（随 HA 备份）
#   /config/workbuddy2api-panel/api_key.txt    API Key 明文副本
#   /config/workbuddy2api-panel/config.example.json  上游示例配置（参考）
#   /data/workbuddy2api-panel/data/            运行状态 / 请求归档（不备份）
# ==============================================================================
set -e

bashio::log.info "Initializing WorkBuddy2API Panel..."

CONFIG_DIR="/config/workbuddy2api-panel"
DATA_DIR="/data/workbuddy2api-panel"
CONFIG_FILE="${CONFIG_DIR}/config.json"
AUTH_DIR="${CONFIG_DIR}/auths"
APP_DATA_DIR="${DATA_DIR}/data"

################
# DIRS         #
################
mkdir -p "${CONFIG_DIR}" "${AUTH_DIR}" "${APP_DATA_DIR}" /app

################
# CONFIG FILE  #
################
# 仅首次启动生成；之后配置完全由用户/管理面板接管（seed-once 语义）。
# 注意: 不使用软链（面板保存为“原子替换”，软链会被替换成普通文件）。
if [ ! -f "${CONFIG_FILE}" ]; then
    API_KEY=$(bashio::config 'API_KEY' '')
    if [ -z "${API_KEY}" ]; then
        API_KEY="sk-$(head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')"
        bashio::log.warning "API_KEY 未配置，已生成随机网关密钥（客户端访问 API 使用）"
    fi
    printf '%s' "${API_KEY}" > "${CONFIG_DIR}/api_key.txt"
    chmod 600 "${CONFIG_DIR}/api_key.txt"

    # JSON 字符串转义（防注入/解析失败）
    API_KEY_ESC=${API_KEY//\\/\\\\}
    API_KEY_ESC=${API_KEY_ESC//\"/\\\"}

    cat > "${CONFIG_FILE}" << JSON
{
  "listen": ":7863",
  "api_key": "${API_KEY_ESC}",
  "auth_dir": "${AUTH_DIR}",
  "state_file": "${APP_DATA_DIR}/state.json"
}
JSON
    chmod 600 "${CONFIG_FILE}"

    bashio::log.info "已生成默认配置: ${CONFIG_FILE}"
    bashio::log.info "网关密钥同时保存在: ${CONFIG_DIR}/api_key.txt"
fi

################
# EXAMPLE      #
################
if [ -f /opt/wb2api/config.example.json ]; then
    cp -f /opt/wb2api/config.example.json "${CONFIG_DIR}/config.example.json"
fi

################
# SYMLINKS     #
################
# 上游以 CWD=/app 运行、使用相对路径 ./auths、./data
ln -sfn "${AUTH_DIR}" /app/auths
ln -sfn "${APP_DATA_DIR}" /app/data

bashio::log.info "WorkBuddy2API Panel initialization completed"