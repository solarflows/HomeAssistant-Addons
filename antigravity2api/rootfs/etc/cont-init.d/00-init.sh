#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Antigravity2API 初始化脚本 (cont-init.d)
# - app_config 直挂 /config，auth/ 存放账号 OAuth 与设备档案
# - /data/runtime 与 /data/logs 隔离非关键持久数据与日志
# - 存量 /legacy_ha/antigravity2api 自愈迁入
# - API_KEYS 与 ADMIN_PASSWORD 与 .env / HA 选项双向同步及 Supervisor 回填
# ==============================================================================
set -e

bashio::log.info "Initializing Antigravity2API..."

CONFIG_DIR="/config"
AUTH_DIR="${CONFIG_DIR}/auth"
RUNTIME_DIR="/data/runtime"
LOG_DIR="/data/logs"
LEGACY_DIR="/legacy_ha/antigravity2api"
ENV_FILE="${CONFIG_DIR}/.env"

mkdir -p "${AUTH_DIR}" "${RUNTIME_DIR}" "${LOG_DIR}"

# 1. 存量数据自愈迁入（若目标为空且历史存量存在）
if [ -d "${LEGACY_DIR}" ] && [ ! -f "${CONFIG_DIR}/.migrated_from_legacy" ]; then
    if [ -z "$(ls -A "${AUTH_DIR}" 2>/dev/null)" ]; then
        bashio::log.info "检测到历史存量目录 ${LEGACY_DIR}，正在一次性迁移至 ${CONFIG_DIR}..."
        cp -a "${LEGACY_DIR}/." "${CONFIG_DIR}/" || bashio::log.warning "存量迁移复制出现异常"
        touch "${CONFIG_DIR}/.migrated_from_legacy"
        bashio::log.info "存量迁移完成，原目录文件保留未删。"
    fi
fi

# 2. 回填加载项选项助手函数
ha_options_backfill() {
    if [ -z "${SUPERVISOR_TOKEN:-}" ]; then
        bashio::log.warning "缺少 SUPERVISOR_TOKEN，无法回填加载项选项"
        return 1
    fi
    if [ ! -f /data/options.json ]; then
        return 1
    fi
    local payload
    payload=$(jq -c '{options: .}' /data/options.json) || return 1
    while [ $# -ge 2 ]; do
        payload=$(jq -c --arg k "$1" --arg v "$2" '.options[$k] = $v' <<<"${payload}") || return 1
        shift 2
    done
    curl -fsS -o /dev/null --max-time 10 -X POST \
        -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
        -H "Content-Type: application/json" \
        --data "${payload}" \
        http://supervisor/addons/self/options || true
}

# 3. 读取用户在 HA 界面配置的选项
OPT_API_KEYS="$(bashio::config 'API_KEYS' '')"
[ "${OPT_API_KEYS}" = "null" ] && OPT_API_KEYS=""
OPT_ADMIN_PASSWORD="$(bashio::config 'ADMIN_PASSWORD' '')"
[ "${OPT_ADMIN_PASSWORD}" = "null" ] && OPT_ADMIN_PASSWORD=""
OPT_PROXY="$(bashio::config 'PROXY' '')"
[ "${OPT_PROXY}" = "null" ] && OPT_PROXY=""

# 4. 生成或同步 API_KEYS
NEED_BACKFILL=false
if [ -z "${OPT_API_KEYS}" ]; then
    # 若 .env 中已存在 API_KEYS，优先提取
    if [ -f "${ENV_FILE}" ] && grep -q '^API_KEYS=' "${ENV_FILE}"; then
        OPT_API_KEYS=$(grep '^API_KEYS=' "${ENV_FILE}" | head -1 | cut -d'=' -f2- | tr -d '"'\'' ')
    fi
    # 仍为空时，首启自动生成一个安全随机密钥
    if [ -z "${OPT_API_KEYS}" ]; then
        OPT_API_KEYS="sk-agy-$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')"
        bashio::log.info "首次启动，已生成默认网关 API 密钥: ${OPT_API_KEYS}"
        NEED_BACKFILL=true
    fi
fi

# 5. 安全回填 HA 选项界面
if [ "${NEED_BACKFILL}" = "true" ]; then
    ha_options_backfill "API_KEYS" "${OPT_API_KEYS}" || true
fi

# 6. 生成并更新 /config/.env
touch "${ENV_FILE}"
update_env_key() {
    local k="$1"
    local v="$2"
    if grep -q "^${k}=" "${ENV_FILE}"; then
        sed -i "s|^${k}=.*|${k}=${v}|" "${ENV_FILE}"
    else
        echo "${k}=${v}" >> "${ENV_FILE}"
    fi
}

update_env_key "LISTEN" "0.0.0.0:8017"
update_env_key "AUTH_DIR" "${AUTH_DIR}"
update_env_key "RUNTIME_DIR" "${RUNTIME_DIR}"
update_env_key "API_KEYS" "${OPT_API_KEYS}"

if [ -n "${OPT_ADMIN_PASSWORD}" ]; then
    update_env_key "ADMIN_AUTH_ENABLED" "true"
    update_env_key "ADMIN_USERNAME" "admin"
    update_env_key "ADMIN_PASSWORD" "${OPT_ADMIN_PASSWORD}"
else
    if ! grep -q "^ADMIN_AUTH_ENABLED=" "${ENV_FILE}"; then
        update_env_key "ADMIN_AUTH_ENABLED" "false"
    fi
fi

if [ -n "${OPT_PROXY}" ]; then
    update_env_key "PROXY" "${OPT_PROXY}"
fi

# 7. 写入就绪标记，放行 S6 longrun 服务
touch /run/antigravity2api-initialized
bashio::log.info "Antigravity2API initialized successfully."
