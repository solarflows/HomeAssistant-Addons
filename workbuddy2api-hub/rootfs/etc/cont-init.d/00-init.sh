#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# workbuddy2api-hub 初始化脚本 (cont-init.d)
# - app_config 直挂 /app/accounts + /legacy_ha 一次性迁移
# - 仅当用户显式配置 API_KEY 时同步写入 settings.json；非必要不填充默认值
# - 严禁虚假凭据生成与反向回填，应用权鉴完全由 Web 界面与用户选项自治
# ==============================================================================
set -e

bashio::log.info "Initializing workbuddy2api-hub..."

DATA_DIR="/app/accounts"
LEGACY_DIR="/legacy_ha/workbuddy2api-hub"
UPDATER_DIR="/run/workbuddy2api-hub-updater"

mkdir -p "${DATA_DIR}" /data/usage /data/catalog /data/subbridge-data /data/updates "${UPDATER_DIR}"

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

# 选项读取与 settings.json 同步（仅当用户显式配置 API_KEY 时应用，留空不填充默认值）
OPT_KEY="$(bashio::config 'API_KEY' '')"
[ "${OPT_KEY}" = "null" ] && OPT_KEY=""

python3 - "${DATA_DIR}" "${OPT_KEY}" <<'PYEOF'
import json
import os
import sys
import time
from pathlib import Path

data_dir = Path(sys.argv[1])
opt_key = sys.argv[2].strip()

settings_path = data_dir / "settings.json"
sidecar_path = data_dir / "options_applied.json"

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

settings_dirty = False

if first_init:
    if opt_key:
        apply_opt_key(settings, opt_key)
        settings_dirty = True
    new_sidecar = {"API_KEY": opt_key}
else:
    prev_key = str(sidecar.get("API_KEY") or "").strip()
    if opt_key and (opt_key != prev_key or not settings_existed):
        apply_opt_key(settings, opt_key)
        settings_dirty = True
    new_sidecar = {"API_KEY": opt_key}

if settings_dirty:
    atomic_write_json(settings_path, settings, 0o600)
atomic_write_json(sidecar_path, new_sidecar, 0o600)
PYEOF

touch /run/workbuddy2api-hub-initialized
bashio::log.info "workbuddy2api-hub initialization completed."
