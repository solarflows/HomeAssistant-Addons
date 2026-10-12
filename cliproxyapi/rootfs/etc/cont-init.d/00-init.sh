#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# CLIProxyAPI 初始化脚本
# ==============================================================================
# 数据布局:
#   /config/cliproxyapi/config.yaml        主配置（首次启动生成，之后由面板接管）
#   /config/cliproxyapi/auths/             OAuth 凭据（随 HA 备份一起保存）
#   /config/cliproxyapi/management_key.txt 管理密钥明文副本（面板登录用）
#   /data/cliproxyapi/{logs,plugins,static} 日志/插件/面板缓存（不参与 HA 备份）
# ==============================================================================
set -e

bashio::log.info "Initializing CLIProxyAPI..."

CONFIG_DIR="/config/cliproxyapi"
DATA_DIR="/data/cliproxyapi"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"
AUTH_DIR="${CONFIG_DIR}/auths"

################
# YAML HELPERS #
################
# set_yaml_scalar <file> <section> <key> <yaml-value>
#   设置 <section>.<key> 标量：键存在则原行替换；段存在则段尾插入；否则追加整段。
#   值需预先渲染（yaml_quote 转义或裸值）。用 index()/substr() 而非正则，兼容 mawk。
set_yaml_scalar() {
    local file="$1" section="$2" key="$3" value="$4"
    local tmp="${file}.tmp"
    if YAML_VALUE="${value}" awk -v section="${section}" -v key="${key}" '
        BEGIN { state = 0 }
        {
            if (state == 0) {
                if (index($0, section ":") == 1) { print; state = 1; next }
                print; next
            }
            if (state == 1) {
                if (index($0, "  " key ":") == 1) {
                    print "  " key ": " ENVIRON["YAML_VALUE"]
                    state = 2; next
                }
                if ($0 != "" && substr($0, 1, 1) != " " && substr($0, 1, 1) != "#") {
                    print "  " key ": " ENVIRON["YAML_VALUE"]
                    state = 2
                    print; next
                }
                print; next
            }
            print
        }
        END {
            if (state == 1) {
                print "  " key ": " ENVIRON["YAML_VALUE"]
            } else if (state == 0) {
                print ""
                print section ":"
                print "  " key ": " ENVIRON["YAML_VALUE"]
            }
        }
    ' "${file}" > "${tmp}"; then
        mv "${tmp}" "${file}"
    else
        rm -f "${tmp}"
        bashio::log.error "set_yaml_scalar: 写入 ${section}.${key} 失败"
        return 1
    fi
}

# yaml_quote <string> → YAML 双引号标量（转义反斜杠与双引号）
yaml_quote() {
    local s=${1//\\/\\\\}
    s=${s//\"/\\\"}
    printf '"%s"' "${s}"
}

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
    if curl -fsS --max-time 10 -X POST \
        -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
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
mkdir -p "${CONFIG_DIR}" "${AUTH_DIR}" \
         "${DATA_DIR}/logs" "${DATA_DIR}/plugins" "${DATA_DIR}/static" "${DATA_DIR}/discovery"

################
# CONFIG FILE  #
################
# 仅首次启动生成；之后配置由用户/管理面板与选项同步共同接管（seed-once + 选项回写）
FIRST_START=0
if [ ! -f "${CONFIG_FILE}" ]; then
    FIRST_START=1
    MANAGEMENT_KEY=$(bashio::config 'MANAGEMENT_KEY' '')
    GENERATED_KEY=0
    if [ -z "${MANAGEMENT_KEY}" ]; then
        MANAGEMENT_KEY="$(head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')"
        GENERATED_KEY=1
        bashio::log.warning "MANAGEMENT_KEY 未配置，已生成随机管理密钥（面板登录 / API 管理均使用）"
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

# 监听设置（host 留空绑定所有接口；port 必须显式设置，否则上游绑定 :0 随机端口）
server:
  host: ""
  port: 8317

# 管理 API / 管理面板
management:
  # 允许非本机（局域网浏览器）访问管理 API；管理面板本身仍需密钥
  allow-remote: true
  disable-control-panel: false
  # 管理面板 GitHub 仓库（CPAMP 轻量版，CPA 会按此自动更新面板）
  panel-github-repository: "https://github.com/seakee/CPA-Manager-Plus"
  # 远程管理 API base-url（TUI 客户端用，可留空）
YAML
        printf '  secret-key: "%s"\n' "${MANAGEMENT_KEY_ESC}"
        cat << 'YAML'

# 客户端访问密钥（占位符会触发 CPA 安全模式，请在管理面板中替换为真实密钥）
access:
  api-keys:
    - "your-api-key-1"

# OAuth/文件凭据目录（持久化，随 HA 备份）
oauth:
  auth-dir: "/config/cliproxyapi/auths"
YAML
        if [ -n "${PROXY_URL}" ]; then
            PROXY_URL_ESC=${PROXY_URL//\\/\\\\}
            PROXY_URL_ESC=${PROXY_URL_ESC//\"/\\\"}
            printf '\n# 上游请求代理（也可在管理面板中修改）\nrequests:\n  proxy-url: "%s"\n' "${PROXY_URL_ESC}"
        fi
    } > "${CONFIG_FILE}"

    bashio::log.info "已生成默认配置: ${CONFIG_FILE}"
    bashio::log.info "管理密钥同时保存在: ${CONFIG_DIR}/management_key.txt"

    # 首启生成的密钥：打印一次 + 回填 HA 选项 UI（双向同步的"生成值 → 选项"方向）
    if [ "${GENERATED_KEY}" = "1" ]; then
        bashio::log.warning "管理密钥: ${MANAGEMENT_KEY}（登录管理面板使用，请妥善保存）"
        if ha_options_backfill MANAGEMENT_KEY "${MANAGEMENT_KEY}"; then
            bashio::log.info "管理密钥已回填到加载项选项（配置界面可见）"
        fi
    fi

    # 记录本次实际写入配置的选项值（下次启动据此判断选项是否变更）
    jq -n --arg mk "${MANAGEMENT_KEY}" --arg pu "${PROXY_URL}" \
        '{MANAGEMENT_KEY: $mk, PROXY_URL: $pu}' > "${CONFIG_DIR}/options_applied.json"
fi

################
# PORT MIGRATION #
################
# 上游 v8 布局中 server.port 无默认值：缺失时绑定 :0（随机端口），
# HA 端口映射随之失效。旧版 addon 生成的配置缺少该字段，此处补齐
#（同时识别 legacy 顶层 port，避免重复注入）。
HAS_PORT=$(awk '
    /^server:/ { in_server = 1; next }
    /^[^ #]/ { in_server = 0 }
    in_server && /^  port:/ { found = 1 }
    /^port:/ { found = 1 }
    END { print (found ? "1" : "") }
' "${CONFIG_FILE}")
if [ -z "${HAS_PORT}" ]; then
    set_yaml_scalar "${CONFIG_FILE}" server port 8317
    bashio::log.info "已补写 server.port: 8317（修复 :0 随机端口绑定）"
fi

################
# OPTION SYNC  #
################
# 选项 → 配置回写（双向同步的"选项 → 配置"方向）：
#   - 选项值非空且与上次已应用值（sidecar）不同 → 回写 config.yaml 对应字段；
#   - 选项为空 = 交由管理面板管理，不写也不删；
#   - 面板在两次启动间改掉的值不会被相同选项值覆盖（仅选项"变更"才回写）。
# CPA 启动时会把 management.secret-key 明文哈希化并写回，回写明文即可生效。
SIDECAR="${CONFIG_DIR}/options_applied.json"
OPT_KEY=$(bashio::config 'MANAGEMENT_KEY' '')
OPT_PROXY=$(bashio::config 'PROXY_URL' '')

# 首启已写入正确的 sidecar（生成密钥场景下选项尚未回填），跳过同步避免误判
if [ "${FIRST_START}" != "1" ]; then
    if [ ! -f "${SIDECAR}" ]; then
        # 旧版本升级：无同步状态。旧语义为"选项仅首启写入"，视当前选项为已应用，
        # 不改动现有配置；之后的选项变更才会回写。
        jq -n --arg mk "${OPT_KEY}" --arg pu "${OPT_PROXY}" \
            '{MANAGEMENT_KEY: $mk, PROXY_URL: $pu}' > "${SIDECAR}"
        bashio::log.info "已初始化选项同步状态（不改动现有配置）"
    else
        APPLIED_KEY=""
        APPLIED_PROXY=""
        if [ -s "${SIDECAR}" ] && jq -e 'type == "object"' "${SIDECAR}" >/dev/null 2>&1; then
            APPLIED_KEY=$(jq -r '.MANAGEMENT_KEY // ""' "${SIDECAR}")
            APPLIED_PROXY=$(jq -r '.PROXY_URL // ""' "${SIDECAR}")
        elif [ -s "${SIDECAR}" ]; then
            bashio::log.warning "options_applied.json 不是有效 JSON，视为未同步（非空选项将重新写入配置）"
        fi

        if [ -n "${OPT_KEY}" ] && [ "${OPT_KEY}" != "${APPLIED_KEY}" ]; then
            set_yaml_scalar "${CONFIG_FILE}" management secret-key "$(yaml_quote "${OPT_KEY}")"
            printf '%s' "${OPT_KEY}" > "${CONFIG_DIR}/management_key.txt"
            chmod 600 "${CONFIG_DIR}/management_key.txt"
            bashio::log.info "MANAGEMENT_KEY 选项已变更，已回写 management.secret-key"
        fi
        if [ -n "${OPT_PROXY}" ] && [ "${OPT_PROXY}" != "${APPLIED_PROXY}" ]; then
            set_yaml_scalar "${CONFIG_FILE}" requests proxy-url "$(yaml_quote "${OPT_PROXY}")"
            bashio::log.info "PROXY_URL 选项已变更，已回写 requests.proxy-url"
        fi

        # sidecar 镜像当前选项值（空 = 未由选项管理）
        jq -n --arg mk "${OPT_KEY}" --arg pu "${OPT_PROXY}" \
            '{MANAGEMENT_KEY: $mk, PROXY_URL: $pu}' > "${SIDECAR}"
    fi
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

bashio::log.info "CLIProxyAPI initialization completed"