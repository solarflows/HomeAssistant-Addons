#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Antigravity2API 初始化脚本 (cont-init.d)
# - app_config 直挂 /config，auth/ 存放账号 OAuth 与设备档案
# - /data/runtime 与 /data/logs 隔离非关键持久数据与日志
# - 存量 /legacy_ha/antigravity2api 自愈迁入
# - 启用远程登录预置：ADMIN_AUTH_ENABLED=true，默认 admin/admin（或自动生成）
# - 基于 /config/options_applied.json 的双向参数同步与差分状态机：
#     * HA 选项变更 -> 灾备覆盖更新至 .env
#     * 面板 UI 改密 -> 保留并自动反向回填至 HA 选项
#     * 非进程 ENV 导出 -> 解除 upstream 环境变量锁死，确保 Web 端可改
# ==============================================================================
set -e

bashio::log.info "Initializing Antigravity2API..."

CONFIG_DIR="/config"
AUTH_DIR="${CONFIG_DIR}/auth"
RUNTIME_DIR="/data/runtime"
LOG_DIR="/data/logs"
LEGACY_DIR="/legacy_ha/antigravity2api"
ENV_FILE="${CONFIG_DIR}/.env"
SIDECAR_FILE="${CONFIG_DIR}/options_applied.json"
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

# 4. 基础运行参数设置（写入 .env 但严禁 process export，以保持 Web 面板 editable）
set_env_val "LISTEN" "0.0.0.0:8017"
set_env_val "AUTH_DIR" "${AUTH_DIR}"
set_env_val "RUNTIME_DIR" "${RUNTIME_DIR}"
set_env_val "ADMIN_AUTH_ENABLED" "true"

# 5. 读取当前 HA 选项
OPT_API_KEYS="$(bashio::config 'API_KEYS' '')"
[ "${OPT_API_KEYS}" = "null" ] && OPT_API_KEYS=""
OPT_ADMIN_USERNAME="$(bashio::config 'ADMIN_USERNAME' '')"
[ "${OPT_ADMIN_USERNAME}" = "null" ] && OPT_ADMIN_USERNAME=""
OPT_ADMIN_PASSWORD="$(bashio::config 'ADMIN_PASSWORD' '')"
[ "${OPT_ADMIN_PASSWORD}" = "null" ] && OPT_ADMIN_PASSWORD=""
OPT_PROXY="$(bashio::config 'PROXY' '')"
[ "${OPT_PROXY}" = "null" ] && OPT_PROXY=""

# 6. 读取当前 .env 中已有值
CURRENT_ENV_KEY="$(get_env_val 'API_KEYS')"
CURRENT_ENV_USER="$(get_env_val 'ADMIN_USERNAME')"
CURRENT_ENV_PW="$(get_env_val 'ADMIN_PASSWORD')"
CURRENT_ENV_PROXY="$(get_env_val 'PROXY')"

# 7. 差分调谐与双向同步逻辑
NEED_BACKFILL=false
BACKFILL_KEY=""
BACKFILL_USER=""
BACKFILL_PW=""

if [ ! -f "${SIDECAR_FILE}" ]; then
    # ---- 首次启动 / 升级接入（建立基准快照） ----
    bashio::log.info "建立初始参数基线快照..."

    # API_KEYS 初始决策
    if [ -n "${OPT_API_KEYS}" ]; then
        APPLIED_API_KEYS="${OPT_API_KEYS}"
    elif [ -n "${CURRENT_ENV_KEY}" ]; then
        APPLIED_API_KEYS="${CURRENT_ENV_KEY}"
        BACKFILL_KEY="${CURRENT_ENV_KEY}"
        NEED_BACKFILL=true
    else
        APPLIED_API_KEYS="sk-agy-$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')"
        BACKFILL_KEY="${APPLIED_API_KEYS}"
        NEED_BACKFILL=true
        bashio::log.info "首次启动，已生成默认网关 API 密钥: ${APPLIED_API_KEYS}"
    fi

    # ADMIN_USERNAME 初始决策
    if [ -n "${OPT_ADMIN_USERNAME}" ]; then
        APPLIED_ADMIN_USER="${OPT_ADMIN_USERNAME}"
    elif [ -n "${CURRENT_ENV_USER}" ]; then
        APPLIED_ADMIN_USER="${CURRENT_ENV_USER}"
    else
        APPLIED_ADMIN_USER="admin"
        BACKFILL_USER="admin"
        NEED_BACKFILL=true
    fi

    # ADMIN_PASSWORD 初始决策
    if [ -n "${OPT_ADMIN_PASSWORD}" ]; then
        APPLIED_ADMIN_PW="${OPT_ADMIN_PASSWORD}"
    elif [ -n "${CURRENT_ENV_PW}" ]; then
        APPLIED_ADMIN_PW="${CURRENT_ENV_PW}"
        BACKFILL_PW="${CURRENT_ENV_PW}"
        NEED_BACKFILL=true
    else
        APPLIED_ADMIN_PW="admin"
        BACKFILL_PW="admin"
        NEED_BACKFILL=true
        bashio::log.warning "首次启动，已预置管理员初始密码: admin（可在管理界面随时修改）"
    fi

    # PROXY 初始决策
    APPLIED_PROXY="${OPT_PROXY:-${CURRENT_ENV_PROXY}}"

    # 写入 .env
    set_env_val "API_KEYS" "${APPLIED_API_KEYS}"
    set_env_val "ADMIN_USERNAME" "${APPLIED_ADMIN_USER}"
    set_env_val "ADMIN_PASSWORD" "${APPLIED_ADMIN_PW}"
    [ -n "${APPLIED_PROXY}" ] && set_env_val "PROXY" "${APPLIED_PROXY}"

    # 保存明文密码副本
    printf '%s' "${APPLIED_ADMIN_PW}" > "${PW_TXT_FILE}"
    chmod 600 "${PW_TXT_FILE}"

    # 写入初始 sidecar
    jq -n \
        --arg ak "${APPLIED_API_KEYS}" \
        --arg au "${APPLIED_ADMIN_USER}" \
        --arg ap "${APPLIED_ADMIN_PW}" \
        --arg px "${APPLIED_PROXY}" \
        '{API_KEYS: $ak, ADMIN_USERNAME: $au, ADMIN_PASSWORD: $ap, PROXY: $px}' > "${SIDECAR_FILE}"
else
    # ---- 二次及稳态启动（差分核验与双向同步） ----
    APPLIED_API_KEYS="$(jq -r '.API_KEYS // ""' "${SIDECAR_FILE}")"
    APPLIED_ADMIN_USER="$(jq -r '.ADMIN_USERNAME // ""' "${SIDECAR_FILE}")"
    APPLIED_ADMIN_PW="$(jq -r '.ADMIN_PASSWORD // ""' "${SIDECAR_FILE}")"
    APPLIED_PROXY="$(jq -r '.PROXY // ""' "${SIDECAR_FILE}")"

    FINAL_KEY="${CURRENT_ENV_KEY:-${APPLIED_API_KEYS}}"
    FINAL_USER="${CURRENT_ENV_USER:-${APPLIED_ADMIN_USER}}"
    FINAL_PW="${CURRENT_ENV_PW:-${APPLIED_ADMIN_PW}}"
    FINAL_PROXY="${CURRENT_ENV_PROXY:-${APPLIED_PROXY}}"

    # 1. 检查 HA 选项是否主动变更（灾备覆盖 / 显式重置优先级最高）
    if [ -n "${OPT_API_KEYS}" ] && [ "${OPT_API_KEYS}" != "${APPLIED_API_KEYS}" ]; then
        bashio::log.info "检测到 HA 选项 API_KEYS 变更，执行灾备同步写回 .env"
        FINAL_KEY="${OPT_API_KEYS}"
        set_env_val "API_KEYS" "${FINAL_KEY}"
    fi

    if [ -n "${OPT_ADMIN_USERNAME}" ] && [ "${OPT_ADMIN_USERNAME}" != "${APPLIED_ADMIN_USER}" ]; then
        bashio::log.info "检测到 HA 选项 ADMIN_USERNAME 变更，执行灾备同步写回 .env"
        FINAL_USER="${OPT_ADMIN_USERNAME}"
        set_env_val "ADMIN_USERNAME" "${FINAL_USER}"
    fi

    if [ -n "${OPT_ADMIN_PASSWORD}" ] && [ "${OPT_ADMIN_PASSWORD}" != "${APPLIED_ADMIN_PW}" ]; then
        bashio::log.info "检测到 HA 选项 ADMIN_PASSWORD 变更，执行灾备同步写回 .env"
        FINAL_PW="${OPT_ADMIN_PASSWORD}"
        set_env_val "ADMIN_PASSWORD" "${FINAL_PW}"
    fi

    if [ "${OPT_PROXY}" != "${APPLIED_PROXY}" ]; then
        bashio::log.info "检测到 HA 选项 PROXY 变更，同步写回 .env"
        FINAL_PROXY="${OPT_PROXY}"
        set_env_val "PROXY" "${FINAL_PROXY}"
    fi

    # 2. 检查 Web UI 是否修改了密码/配置（.env 变动反向回填至 HA Options）
    if [ -n "${CURRENT_ENV_PW}" ] && [ "${CURRENT_ENV_PW}" != "${APPLIED_ADMIN_PW}" ] && [ "${OPT_ADMIN_PASSWORD}" = "${APPLIED_ADMIN_PW}" ]; then
        bashio::log.info "检测到 Web 管理端已更新管理密码，保留面板改动并反向回填至 HA 选项..."
        FINAL_PW="${CURRENT_ENV_PW}"
        BACKFILL_PW="${CURRENT_ENV_PW}"
        NEED_BACKFILL=true
    fi

    if [ -n "${CURRENT_ENV_USER}" ] && [ "${CURRENT_ENV_USER}" != "${APPLIED_ADMIN_USER}" ] && [ "${OPT_ADMIN_USERNAME}" = "${APPLIED_ADMIN_USER}" ]; then
        bashio::log.info "检测到 Web 管理端已更新管理用户名，保留面板改动并反向回填至 HA 选项..."
        FINAL_USER="${CURRENT_ENV_USER}"
        BACKFILL_USER="${CURRENT_ENV_USER}"
        NEED_BACKFILL=true
    fi

    if [ -n "${CURRENT_ENV_KEY}" ] && [ "${CURRENT_ENV_KEY}" != "${APPLIED_API_KEYS}" ] && [ "${OPT_API_KEYS}" = "${APPLIED_API_KEYS}" ]; then
        bashio::log.info "检测到 Web 管理端已更新 API_KEYS，保留面板改动并反向回填至 HA 选项..."
        FINAL_KEY="${CURRENT_ENV_KEY}"
        BACKFILL_KEY="${CURRENT_ENV_KEY}"
        NEED_BACKFILL=true
    fi

    # 更新本地密码明文备忘
    printf '%s' "${FINAL_PW}" > "${PW_TXT_FILE}"
    chmod 600 "${PW_TXT_FILE}"

    # 更新 sidecar 镜像
    jq -n \
        --arg ak "${FINAL_KEY}" \
        --arg au "${FINAL_USER}" \
        --arg ap "${FINAL_PW}" \
        --arg px "${FINAL_PROXY}" \
        '{API_KEYS: $ak, ADMIN_USERNAME: $au, ADMIN_PASSWORD: $ap, PROXY: $px}' > "${SIDECAR_FILE}"
fi

# 8. 执行 Supervisor 选项回填
if [ "${NEED_BACKFILL}" = "true" ]; then
    BACKFILL_ARGS=()
    [ -n "${BACKFILL_KEY}" ] && BACKFILL_ARGS+=("API_KEYS" "${BACKFILL_KEY}")
    [ -n "${BACKFILL_USER}" ] && BACKFILL_ARGS+=("ADMIN_USERNAME" "${BACKFILL_USER}")
    [ -n "${BACKFILL_PW}" ] && BACKFILL_ARGS+=("ADMIN_PASSWORD" "${BACKFILL_PW}")
    if [ ${#BACKFILL_ARGS[@]} -gt 0 ]; then
        if ha_options_backfill "${BACKFILL_ARGS[@]}"; then
            bashio::log.info "已成功将凭据/配置状态同步回填至 Home Assistant 选项界面。"
        fi
    fi
fi

# 9. 确保 .env 中 ADMIN_AUTH_ENABLED 必须开启
set_env_val "ADMIN_AUTH_ENABLED" "true"

# 10. 写入就绪标记，放行 S6 longrun 服务
touch /run/antigravity2api-initialized
bashio::log.info "Antigravity2API initialized successfully (Remote Web Access Enabled)."
