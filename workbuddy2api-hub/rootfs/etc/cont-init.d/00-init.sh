#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# workbuddy2api-hub 初始化脚本 (cont-init.d)
# - app_config 直挂 /app/accounts + /legacy_ha 一次性迁移
# - API_KEY 首启随机生成 -> 写入 settings.json + api_key.txt -> 回填 HA 选项 UI
# - 基于 /app/accounts/options_applied.json 的双向同步（选项变更覆盖；面板改动保留）
# ==============================================================================
set -e

bashio::log.info "Initializing workbuddy2api-hub..."

DATA_DIR="/app/accounts"
LEGACY_DIR="/legacy_ha/workbuddy2api-hub"
UPDATER_DIR="/run/workbuddy2api-hub-updater"
PW_FLAG_FILE="/run/workbuddy2api-hub-panel-pw"

mkdir -p "${DATA_DIR}" /data/usage /data/catalog /data/subbridge-data /data/updates "${UPDATER_DIR}"
rm -f "${PW_FLAG_FILE}"

# ha_options_backfill <key> <value> [<key> <value> ...]
# 读取 /data/options.json 合并后单次提交（POST /addons/self/options 为整体覆盖语义）
ha_options_backfill() {
    if [ -z "${SUPERVISOR_TOKEN:-}" ]; then
        bashio::log.warning "缺少 SUPERVISOR_TOKEN，无法回填加载项选项（密钥见日志与 api_key.txt）"
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
    if curl -fsS -o /dev/null --max-time 10 -X POST \
        -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
        -H "Content-Type: application/json" \
        --data "${payload}" \
        http://supervisor/addons/self/options; then
        return 0
    fi
    bashio::log.warning "回填加载项选项失败（不影响启动；密钥见日志与 api_key.txt）"
    return 1
}

# 将面板热更新备份目录 /app/updates 指向 /data/updates（不污染容器可写层及 /app/accounts 备份）
if [ ! -L /app/updates ]; then
    rm -rf /app/updates 2>/dev/null || true
    ln -sfn /data/updates /app/updates
fi

# 注册上游外部更新器通道（wb_update_external.py）
cat > "${UPDATER_DIR}/executor.json" <<'EOF'
{"mode":"external"}
EOF

# 自愈上次未完成的外部更新（若存在残留中断状态）
if [ -f /app/wb_update_external.py ]; then
    python3 /app/wb_update_external.py --root /app --request-dir "${UPDATER_DIR}" --profile app || true
fi

# 存量数据双轨自愈迁入（仅当 /app/accounts 为空且存在 /legacy_ha/workbuddy2api-hub 时）
if [ -d "${LEGACY_DIR}" ] && [ ! -f "${DATA_DIR}/.migrated_from_legacy" ]; then
    if [ -z "$(ls -A "${DATA_DIR}" 2>/dev/null)" ]; then
        bashio::log.info "检测到历史存量目录 ${LEGACY_DIR}，正在一次性迁移至 ${DATA_DIR}..."
        cp -a "${LEGACY_DIR}/." "${DATA_DIR}/" || bashio::log.warning "存量迁移复制出现异常"
        touch "${DATA_DIR}/.migrated_from_legacy"
        bashio::log.info "存量迁移完成，原目录文件保留未删。"
    fi
fi

# 选项读取与 settings.json / HA 选项双向同步
OPT_KEY="$(bashio::config 'API_KEY' '')"
[ "${OPT_KEY}" = "null" ] && OPT_KEY=""
OPT_PANEL_PW="$(bashio::config 'PANEL_PASSWORD' '')"
[ "${OPT_PANEL_PW}" = "null" ] && OPT_PANEL_PW=""

BACKFILL_KEY="$(python3 - "${DATA_DIR}" "${OPT_KEY}" "${OPT_PANEL_PW}" "${PW_FLAG_FILE}" <<'PYEOF'
import json
import os
import secrets
import sys
import time
from pathlib import Path

data_dir = Path(sys.argv[1])
opt_key = sys.argv[2].strip()
opt_pw = sys.argv[3]
pw_flag = Path(sys.argv[4])

settings_path = data_dir / "settings.json"
sidecar_path = data_dir / "options_applied.json"
key_txt_path = data_dir / "api_key.txt"

def load_json(p):
    try:
        d = json.loads(p.read_text(encoding="utf-8"))
        return d if isinstance(d, dict) else {}
    except Exception:
        return {}

def atomic_write_json(p, obj, mode=0o600):
    tmp = p.with_suffix(p.suffix + ".tmp")
    tmp.write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding="utf-8")
    os.chmod(tmp, mode)
    os.replace(tmp, p)

def write_key_txt(val):
    tmp = key_txt_path.with_suffix(".txt.tmp")
    tmp.write_text(val, encoding="utf-8")
    os.chmod(tmp, 0o600)
    os.replace(tmp, key_txt_path)

def extract_existing_key(s):
    stored = s.get("api_keys")
    if isinstance(stored, list):
        live = [
            e for e in stored
            if isinstance(e, dict)
            and str(e.get("key") or "").strip()
            and not str(e.get("deleted_at") or "").strip()
            and e.get("enabled", True) is not False
        ]
        for e in live:
            if str(e.get("id") or "") == "ha-option":
                return str(e["key"]).strip()
        if live:
            return str(live[0]["key"]).strip()
        return str(s.get("launcher_key") or "").strip()
    if s.get("api_key_set"):
        legacy = str(s.get("api_key") or "").strip()
        if legacy:
            return legacy
    return str(s.get("launcher_key") or "").strip()

def apply_opt_key(s, key):
    stored = s.get("api_keys")
    if isinstance(stored, list):
        for e in stored:
            if not isinstance(e, dict) or str(e.get("deleted_at") or "").strip():
                continue
            if str(e.get("key") or "").strip() == key:
                e["enabled"] = True
                return
        for e in stored:
            if not isinstance(e, dict) or str(e.get("deleted_at") or "").strip():
                continue
            if str(e.get("id") or "") == "ha-option":
                e["key"] = key
                e["enabled"] = True
                return
        stored.append({
            "id": "ha-option",
            "name": "HA 加载项配置",
            "key": key,
            "realm": "",
            "models": [],
            "accounts": [],
            "concurrency_limit": 0,
            "enabled": True,
            "created_at": time.strftime("%Y/%m/%d %H:%M"),
            "deleted_at": "",
        })
    else:
        s["api_key"] = key
        s["api_key_set"] = True

settings = load_json(settings_path)
settings_existed = settings_path.is_file()
first_init = not sidecar_path.is_file()
sidecar = load_json(sidecar_path) if not first_init else {}

backfill = ""
settings_dirty = False

if first_init:
    existing = extract_existing_key(settings)
    if opt_key:
        apply_opt_key(settings, opt_key)
        settings_dirty = True
        write_key_txt(opt_key)
        applied_key = opt_key
    elif existing:
        write_key_txt(existing)
        backfill = existing
        applied_key = existing
    else:
        gen = "wb-" + secrets.token_urlsafe(24)
        settings["launcher_key"] = gen
        settings_dirty = True
        write_key_txt(gen)
        backfill = gen
        applied_key = gen
    if opt_pw:
        pw_flag.write_text(opt_pw, encoding="utf-8")
        os.chmod(pw_flag, 0o600)
    new_sidecar = {"API_KEY": applied_key, "PANEL_PASSWORD": opt_pw}
else:
    prev_key = str(sidecar.get("API_KEY") or "").strip()
    prev_pw = str(sidecar.get("PANEL_PASSWORD") or "")
    if opt_key and (opt_key != prev_key or not settings_existed):
        apply_opt_key(settings, opt_key)
        settings_dirty = True
        write_key_txt(opt_key)
    if opt_pw and (opt_pw != prev_pw or not settings_existed):
        pw_flag.write_text(opt_pw, encoding="utf-8")
        os.chmod(pw_flag, 0o600)
    new_sidecar = {"API_KEY": opt_key, "PANEL_PASSWORD": opt_pw}

if settings_dirty:
    atomic_write_json(settings_path, settings, 0o600)
atomic_write_json(sidecar_path, new_sidecar, 0o600)

if backfill:
    print(backfill)
PYEOF
)"

if [ -n "${BACKFILL_KEY}" ]; then
    bashio::log.warning "API_KEY 未配置，已自动生成/沿用网关密钥: ${BACKFILL_KEY}（同时保存于 ${DATA_DIR}/api_key.txt）"
    if ha_options_backfill API_KEY "${BACKFILL_KEY}"; then
        bashio::log.info "API_KEY 已自动回填到加载项配置界面。"
    fi
fi

# 应用时区配置
TZ_CFG="$(bashio::config 'TZ' 'Asia/Shanghai')"
if [ -n "${TZ_CFG}" ] && [ -f "/usr/share/zoneinfo/${TZ_CFG}" ]; then
    ln -snf "/usr/share/zoneinfo/${TZ_CFG}" /etc/localtime
    echo "${TZ_CFG}" > /etc/timezone
fi

touch /run/workbuddy2api-hub-initialized
bashio::log.info "workbuddy2api-hub initialization completed."
