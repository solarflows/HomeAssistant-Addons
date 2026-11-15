#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Antigravity2API 初始化脚本 (cont-init.d)
# - app_config 直挂 /config，auth/ 存放账号 OAuth 与设备档案
# - /data/runtime 与 /data/logs 隔离非关键持久数据与日志
# - 存量 /legacy_ha/antigravity2api 自愈迁入
# - 极简解耦：出厂预置远程访问 (ADMIN_AUTH_ENABLED=true) 与默认凭据 (admin/admin)
# - 凭据交由 Web 控制台自治，解除进程级 ENV 锁定
# - 使用 SUPERVISOR_SOCKET 原生本地套接字回填 API_KEYS
# ==============================================================================
set -e

bashio::log.info "Initializing Antigravity2API..."

CONFIG_DIR="/config"
AUTH_DIR="${CONFIG_DIR}/auth"
RUNTIME_DIR="/data/runtime"
LOG_DIR="/data/logs"
LEGACY_DIR="/legacy_ha/antigravity2api"
ENV_FILE="${CONFIG_DIR}/.env"
PW_TXT_FILE="${CONFIG_DIR}/admin_password.txt"

mkdir -p "${CONFIG_DIR}" "${AUTH_DIR}" "${RUNTIME_DIR}" "${LOG_DIR}"

# 1. 存量数据自愈迁入（若目标为空且历史存量存在）
if [ -d "${LEGACY_DIR}" ] && [ ! -f "${CONFIG_DIR}/.migrated_from_legacy" ]; then
    if [ -z "$(ls -A "${AUTH_DIR}" 2>/dev/null)" ]; then
        bashio::log.info "检测到历史存量目录 ${LEGACY_DIR}，正在一次性迁移至 ${CONFIG_DIR}..."
        cp -a "${LEGACY_DIR}/." "${CONFIG_DIR}/" || bashio::log.warning "存量迁移复制出现异常"
        touch "${CONFIG_DIR}/.migrated_from_legacy"
        bashio::log.info "存量迁移完成，原目录文件保留未删。"
    fi
fi

# 2. 基于 SUPERVISOR_SOCKET 的原生增量回填函数
ha_options_backfill() {
    local key="$1"
    local val="$2"
    local sock="${SUPERVISOR_SOCKET:-/run/supervisor/supervisor.sock}"

    if [ -S "${sock}" ]; then
        local payload
        payload=$(jq -nc --arg k "${key}" --arg v "${val}" '{options: {($k): $v}}')
        curl -fsS -m 5 --unix-socket "${sock}" \
            -X POST \
            -H "Content-Type: application/json" \
            --data "${payload}" \
            "http://localhost/addons/self/options" >/dev/null 2>&1 || true
    elif [ -n "${SUPERVISOR_TOKEN:-}" ]; then
        local payload
        payload=$(jq -nc --arg k "${key}" --arg v "${val}" '{options: {($k): $v}}')
        curl -fsS -m 5 -X POST \
            -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
            -H "Content-Type: application/json" \
            --data "${payload}" \
            "http://supervisor/addons/self/options" >/dev/null 2>&1 || true
    fi
}

# 3. .env 键值安全读写函数（使用 awk ENVIRON 避免转义字符碰撞）
touch "${ENV_FILE}"

get_env_val() {
    local k="$1"
    if [ -f "${ENV_FILE}" ]; then
        awk -v k="${k}" '
            BEGIN { found = 0 }
            {
                if (index($0, k "=") == 1 && found == 0) {
                    val = substr($0, length(k) + 2)
                    gsub(/^[ \t]+|[ \t]+$/, "", val)
                    if ((substr(val, 1, 1) == "\"" && substr(val, length(val), 1) == "\"") || \
                        (substr(val, 1, 1) == "\x27" && substr(val, length(val), 1) == "\x27")) {
                        val = substr(val, 2, length(val) - 2)
                    }
                    print val
                    found = 1
                }
            }
        ' "${ENV_FILE}"
    fi
}

set_env_val() {
    local k="$1"
    local raw_v="$2"
    local formatted="${raw_v}"
    if [[ "${raw_v}" =~ [[:space:]\#\"\'] ]]; then
        local escaped="${raw_v//\\/\\\\}"
        escaped="${escaped//\"/\\\"}"
        formatted="\"${escaped}\""
    fi
    local tmp="${ENV_FILE}.tmp"
    if ENV_VAL="${formatted}" awk -v k="${k}" '
        BEGIN { done = 0 }
        {
            if (index($0, k "=") == 1 && done == 0) {
                print k "=" ENVIRON["ENV_VAL"]
                done = 1
            } else {
                print $0
            }
        }
        END {
            if (done == 0) {
                print k "=" ENVIRON["ENV_VAL"]
            }
        }
    ' "${ENV_FILE}" > "${tmp}"; then
        mv -f "${tmp}" "${ENV_FILE}"
    else
        rm -f "${tmp}"
        bashio::log.error "写入 .env 失败: ${k}"
        return 1
    fi
}

# 4. 基础运行参数固化（写入 .env 但严禁 process export，以保持 Web 面板 editable）
set_env_val "LISTEN" "0.0.0.0:8017"
set_env_val "AUTH_DIR" "${AUTH_DIR}"
set_env_val "RUNTIME_DIR" "${RUNTIME_DIR}"
set_env_val "ADMIN_AUTH_ENABLED" "true"

# 5. 管理员账号与密码（出厂播种 + 控制台全权自治）
CURRENT_ENV_PW="$(get_env_val 'ADMIN_PASSWORD')"
if [ -z "${CURRENT_ENV_PW}" ]; then
    set_env_val "ADMIN_USERNAME" "admin"
    set_env_val "ADMIN_PASSWORD" "admin"
    printf '%s' "admin" > "${PW_TXT_FILE}"
    chmod 600 "${PW_TXT_FILE}"
    bashio::log.warning "首次启动，已预置管理员初始账号 admin 与密码 admin（可在 Web 管理控制台随时修改）"
else
    # 存量/已改密配置：刷新本地明文副本供用户在文件系统查阅
    printf '%s' "${CURRENT_ENV_PW}" > "${PW_TXT_FILE}"
    chmod 600 "${PW_TXT_FILE}"
fi

# 6. API_KEYS 处理（选项优先，留空首启自动生成并回填）
OPT_API_KEYS="$(bashio::config 'API_KEYS' '')"
[ "${OPT_API_KEYS}" = "null" ] && OPT_API_KEYS=""
CURRENT_ENV_KEY="$(get_env_val 'API_KEYS')"

if [ -n "${OPT_API_KEYS}" ]; then
    set_env_val "API_KEYS" "${OPT_API_KEYS}"
elif [ -z "${CURRENT_ENV_KEY}" ]; then
    GEN_KEY="sk-agy-$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')"
    set_env_val "API_KEYS" "${GEN_KEY}"
    bashio::log.info "首次启动，已生成默认网关 API 密钥: ${GEN_KEY}"
    ha_options_backfill "API_KEYS" "${GEN_KEY}"
fi

# 7. PROXY 上游代理设置（若 HA 选项配置则应用）
OPT_PROXY="$(bashio::config 'PROXY' '')"
[ "${OPT_PROXY}" = "null" ] && OPT_PROXY=""
if [ -n "${OPT_PROXY}" ]; then
    set_env_val "PROXY" "${OPT_PROXY}"
fi

# 8. 写入就绪标记，放行 S6 longrun 服务
touch /run/antigravity2api-initialized
bashio::log.info "Antigravity2API initialized successfully (Remote Web Access Enabled)."
