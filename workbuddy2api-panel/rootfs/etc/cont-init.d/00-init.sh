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
# HA OPTIONS   #
################
# ha_options_backfill <key> <value> [<key> <value> ...]
#   把首启生成的密钥回填到 HA 加载项选项（POST /addons/self/options）。
#   读取 /data/options.json 合并键值后整体提交（该接口为整体替换语义）。
#   依据: supervisor/api/middleware/security.py 的 api_bypass 放行
#   /addons/self/*（无需 hassio_api）；失败仅告警不阻断启动。
ha_options_backfill() {
    if [ -z "${SUPERVISOR_TOKEN:-}" ]; then
        bashio::log.warning "缺少 SUPERVISOR_TOKEN，无法回填加载项选项（密钥见日志与 txt 文件）"
        return 1
    fi
    if [ ! -f /data/options.json ]; then
        bashio::log.warning "/data/options.json 不存在，跳过选项回填"
        return 1
    fi
    local payload
    payload=$(jq -c '{options: .}' /data/options.json) || return 1
    while [ $# -ge 2 ]; do
        payload=$(jq -c --arg k "$1" --arg v "$2" '.options[$k] = $v' <<<"${payload}") || return 1
        shift 2
    done
    local auth_header
    auth_header="Authorization: Bearer ${SUPERVISOR_TOKEN}"
    if curl -fsS --max-time 10 -X POST \
        -H "${auth_header}" \
        -H "Content-Type: application/json" \
        --data "${payload}" \
        http://supervisor/addons/self/options; then
        return 0
    fi
    bashio::log.warning "回填加载项选项失败（不影响启动；密钥见日志与 txt 文件）"
    return 1
}

################
# DIRS         #
################
mkdir -p "${CONFIG_DIR}" "${AUTH_DIR}" "${APP_DATA_DIR}" /app

################
# CONFIG FILE  #
################
# 仅首次启动生成；之后配置由用户/管理面板与选项同步共同接管（seed-once + 选项回写）。
# 注意: 不使用软链（面板保存为"原子替换"，软链会被替换成普通文件）。
FIRST_START=0
if [ ! -f "${CONFIG_FILE}" ]; then
    FIRST_START=1
    API_KEY=$(bashio::config 'API_KEY' '')
    GENERATED_KEY=0
    if [ -z "${API_KEY}" ]; then
        API_KEY="sk-$(head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')"
        GENERATED_KEY=1
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

    # 首启生成的密钥：打印一次 + 回填 HA 选项 UI（双向同步的"生成值 → 选项"方向）
    if [ "${GENERATED_KEY}" = "1" ]; then
        bashio::log.warning "网关密钥: ${API_KEY}（客户端调用 API 使用，请妥善保存）"
        if ha_options_backfill API_KEY "${API_KEY}"; then
            bashio::log.info "网关密钥已回填到加载项选项（配置界面可见）"
        fi
    fi

    # 记录本次实际写入配置的选项值（下次启动据此判断选项是否变更）
    jq -n --arg ak "${API_KEY}" '{API_KEY: $ak}' > "${CONFIG_DIR}/options_applied.json"
fi

################
# OPTION SYNC  #
################
# 选项 → 配置回写（双向同步的"选项 → 配置"方向）：
#   - API_KEY 选项非空且与上次已应用值（sidecar）不同 → 回写 config.json 的 api_key；
#   - 选项为空 = 交由面板管理，不写也不删；
#   - 面板在两次启动间改掉的值不会被相同选项值覆盖（仅选项"变更"才回写）。
SIDECAR="${CONFIG_DIR}/options_applied.json"
OPT_KEY=$(bashio::config 'API_KEY' '')

# 首启已写入正确的 sidecar（生成密钥场景下选项尚未回填），跳过同步避免误判
if [ "${FIRST_START}" != "1" ]; then
    if [ ! -f "${SIDECAR}" ]; then
        # 旧版本升级：无同步状态。旧语义为"选项仅首启写入"，视当前选项为已应用，
        # 不改动现有配置；之后的选项变更才会回写。
        jq -n --arg ak "${OPT_KEY}" '{API_KEY: $ak}' > "${SIDECAR}"
        bashio::log.info "已初始化选项同步状态（不改动现有配置）"
    else
        APPLIED_KEY=""
        if [ -s "${SIDECAR}" ] && jq -e 'type == "object"' "${SIDECAR}" >/dev/null 2>&1; then
            APPLIED_KEY=$(jq -r '.API_KEY // ""' "${SIDECAR}")
        elif [ -s "${SIDECAR}" ]; then
            bashio::log.warning "options_applied.json 不是有效 JSON，视为未同步（非空选项将重新写入配置）"
        fi

        if [ -n "${OPT_KEY}" ] && [ "${OPT_KEY}" != "${APPLIED_KEY}" ]; then
            if jq --arg k "${OPT_KEY}" '.api_key = $k' "${CONFIG_FILE}" > "${CONFIG_FILE}.tmp"; then
                mv "${CONFIG_FILE}.tmp" "${CONFIG_FILE}"
                printf '%s' "${OPT_KEY}" > "${CONFIG_DIR}/api_key.txt"
                chmod 600 "${CONFIG_DIR}/api_key.txt"
                bashio::log.info "API_KEY 选项已变更，已回写 config.json"
            else
                rm -f "${CONFIG_FILE}.tmp"
                bashio::log.error "回写 api_key 到 config.json 失败"
                exit 1
            fi
        fi

        # sidecar 镜像当前选项值（空 = 未由选项管理）
        jq -n --arg ak "${OPT_KEY}" '{API_KEY: $ak}' > "${SIDECAR}"
    fi
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