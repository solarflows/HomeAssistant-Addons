#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Antigravity2API 初始化脚本 (cont-init.d)
# - app_config 直挂 /config，auth/ 存放账号 OAuth 与设备档案
# - /data/runtime 与 /data/logs 隔离非关键持久数据与日志
# - 存量 /legacy_ha/antigravity2api 自愈迁入
# - 仅固化拉起服务所需的基础运行参数（LISTEN / 路径），非必要不填充默认值
# - 权鉴与业务配置由 Web 控制台或直接在 .env 中自治管理
# ==============================================================================
set -e

bashio::log.info "Initializing Antigravity2API..."

CONFIG_DIR="/config"
AUTH_DIR="${CONFIG_DIR}/auth"
RUNTIME_DIR="/data/runtime"
LOG_DIR="/data/logs"
LEGACY_DIR="/legacy_ha/antigravity2api"
ENV_FILE="${CONFIG_DIR}/.env"

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

# 2. .env 键值安全读写函数（使用 awk ENVIRON 避免转义字符碰撞）
touch "${ENV_FILE}"

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

# 3. 基础运行参数设置（仅固化拉起服务所必须的容器网络与数据路径）
set_env_val "LISTEN" "0.0.0.0:8017"
set_env_val "AUTH_DIR" "${AUTH_DIR}"
set_env_val "RUNTIME_DIR" "${RUNTIME_DIR}"

# 4. 可选配置项同步（仅当用户在 HA 选项显式配置时写入，留空保持 unset，不填充默认值）
OPT_API_KEYS="$(bashio::config 'API_KEYS' '')"
[ "${OPT_API_KEYS}" = "null" ] && OPT_API_KEYS=""
if [ -n "${OPT_API_KEYS}" ]; then
    set_env_val "API_KEYS" "${OPT_API_KEYS}"
fi

OPT_PROXY="$(bashio::config 'PROXY' '')"
[ "${OPT_PROXY}" = "null" ] && OPT_PROXY=""
if [ -n "${OPT_PROXY}" ]; then
    set_env_val "PROXY" "${OPT_PROXY}"
fi

# 5. 写入就绪标记，放行 S6 longrun 服务
touch /run/antigravity2api-initialized
bashio::log.info "Antigravity2API initialized successfully."
