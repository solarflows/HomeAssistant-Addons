#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# qoder2api-hub 初始化脚本 (cont-init.d)
# - app_config 直挂 /app/accounts + /legacy_ha 一次性迁移
# - 仅当用户显式配置 API_KEY 时同步写入 settings.json；非必要不填充默认值
# - 严禁虚假凭据生成与反向回填，应用权鉴完全由 Web 界面与用户选项自治
# ==============================================================================
set -e

bashio::log.info "Initializing qoder2api-hub..."

DATA_DIR="/app/accounts"
LEGACY_DIR="/legacy_ha/qoder2api-hub"

mkdir -p "${DATA_DIR}" /data/logs /data/usage

# 防止上游 _LogTee 追加文件无限膨胀占满 HAOS /data（Docker stdout/stderr 仍完整直出）
for _lf in /data/logs/gateway.log /data/logs/gateway.err.log; do
    if [ -f "${_lf}" ]; then
        _sz=$(wc -c < "${_lf}" 2>/dev/null || echo 0)
        if [ "${_sz}" -gt 20971520 ] 2>/dev/null; then
            tail -c 2097152 "${_lf}" > "${_lf}.tmp" && mv -f "${_lf}.tmp" "${_lf}" || true
            bashio::log.info "已裁剪超大日志文件 ${_lf}（保留末尾 2MB）"
        fi
    fi
done

# 存量数据双轨自愈迁入（仅当 /app/accounts 为空且存在 /legacy_ha/qoder2api-hub 时）
if [ -d "${LEGACY_DIR}" ] && [ ! -f "${DATA_DIR}/.migrated_from_legacy" ]; then
    if [ -z "$(ls -A "${DATA_DIR}" 2>/dev/null)" ]; then
        bashio::log.info "检测到历史存量目录 ${LEGACY_DIR}，正在一次性迁移至 ${DATA_DIR}..."
        cp -a "${LEGACY_DIR}/." "${DATA_DIR}/" || bashio::log.warning "存量迁移复制出现异常"
        touch "${DATA_DIR}/.migrated_from_legacy"
        bashio::log.info "存量迁移完成，原目录文件保留未删。"
    fi
fi

# 选项读取与 settings.json / HA 选项同步（仅当用户显式配置 API_KEY 时应用，留空不填充默认值）
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
            if not isinstance(e, dict):
                continue
            if str(e.get("key") or "").strip() == key:
                e["enabled"] = True
                return
        for e in stored:
            if not isinstance(e, dict):
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
            "enabled": True,
            "created_at": time.strftime("%Y/%m/%d %H:%M"),
            "models": [],
            "account_ids": [],
            "account_groups": [],
            "note": "Synced from HA add-on option",
            "anthropic_thinking": "",
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

bashio::log.info "qoder2api-hub initialization completed."
