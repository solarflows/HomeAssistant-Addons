#!/bin/bash
#=============================================================================
# MCPHub HA 适配入口
#=============================================================================
#   1) 数据目录接管: /app/data → /config（设置/用户/凭据绑定，随 HA 备份）
#   2) 软件包缓存接管: /root/.npm、/root/.cache → /data/mcphub
#      （npx/uvx 拉取的 MCP server 包在 addon 更新后不丢失，冷启动更快）
#   3) CLI profile 接管: /root/.config/mcphub、/root/.local/share/mcphub → /data/mcphub
#   4) HA addon options → 环境变量（ADMIN_PASSWORD / NPM_REGISTRY）
#   5) 链到上游 entrypoint（保留其 npm registry / 代理配置逻辑）
#=============================================================================
set -e

echo "[mcphub] Checking persistent directories..."
mkdir -p /app/data /data/mcphub/npm /data/mcphub/cache

# ---- 双轨存量自愈平滑迁移（一次性探测老 Core /legacy_ha 目录） ----
if [ ! -f /app/data/.migrated_from_legacy ]; then
    MIGRATION_SRC=""
    if [ -d /legacy_ha/mcphub ] && [ -z "$(ls -A /app/data 2>/dev/null)" ]; then
        MIGRATION_SRC="/legacy_ha/mcphub"
    fi

    if [ -n "${MIGRATION_SRC}" ]; then
        echo "[mcphub] Migrating legacy Core data from ${MIGRATION_SRC}..."
        cp -an "${MIGRATION_SRC}/." /app/data/ 2>/dev/null || true
        touch /app/data/.migrated_from_legacy
        echo "${MIGRATION_SRC}" > /run/migration_cleanup_pending
        echo "[mcphub] Legacy data migrated successfully."
    else
        touch /app/data/.migrated_from_legacy
    fi
fi

# ---- npm / uv 缓存 → /data ----
if [ ! -L /root/.npm ]; then
    rm -rf /root/.npm
    ln -s /data/mcphub/npm /root/.npm
fi
if [ ! -L /root/.cache ]; then
    rm -rf /root/.cache
    ln -s /data/mcphub/cache /root/.cache
fi

# ---- mcphub CLI profile（XDG）→ /data ----
# 上游 src/cli/profile.ts: config=$XDG_CONFIG_HOME/mcphub, credentials=$XDG_DATA_HOME/mcphub
mkdir -p /root/.config /root/.local/share /data/mcphub/cli-config /data/mcphub/cli-data

if [ -d /root/.config/mcphub ] && [ ! -L /root/.config/mcphub ]; then
    if ! cp -a /root/.config/mcphub/. /data/mcphub/cli-config/; then
        echo "[mcphub] WARNING: failed to migrate /root/.config/mcphub (continuing)"
    fi
    rm -rf /root/.config/mcphub
fi
ln -sfn /data/mcphub/cli-config /root/.config/mcphub

if [ -d /root/.local/share/mcphub ] && [ ! -L /root/.local/share/mcphub ]; then
    if ! cp -a /root/.local/share/mcphub/. /data/mcphub/cli-data/; then
        echo "[mcphub] WARNING: failed to migrate /root/.local/share/mcphub (continuing)"
    fi
    rm -rf /root/.local/share/mcphub
fi
ln -sfn /data/mcphub/cli-data /root/.local/share/mcphub

# ---- HA addon options → 环境变量 ----
if [ -f /data/options.json ]; then
    echo "[mcphub] Reading HA addon options..."
    python3 -c "
import json, shlex
with open('/data/options.json') as f:
    opts = json.load(f)
with open('/tmp/ha_options.env', 'w') as out:
    for k, v in opts.items():
        if v is None or v == '':
            continue
        if isinstance(v, bool):
            v = str(v).lower()
        out.write(f'{k}={shlex.quote(str(v))}\n')
"
    set -a; . /tmp/ha_options.env; set +a
    rm -f /tmp/ha_options.env
fi

# 确认服务启动成功后，清空旧迁移数据并固化一次性迁移标记
if [ -f /run/migration_cleanup_pending ]; then
    (
        echo "[mcphub] Waiting for MCPHub to start before cleaning up legacy directory..."
        for _ in $(seq 1 60); do
            if curl -s -m 2 -o /dev/null http://127.0.0.1:3000/health 2>/dev/null || (exec 3<>/dev/tcp/127.0.0.1/3000 && exec 3>&-) 2>/dev/null; then
                echo "[mcphub] MCPHub started successfully, cleaning up legacy directory..."
                CLEANUP_PATHS=$(cat /run/migration_cleanup_pending)
                for p in ${CLEANUP_PATHS}; do
                    rm -rf "${p}" 2>/dev/null || true
                done
                rm -f /run/migration_cleanup_pending
                touch /app/data/.migrated_from_legacy
                echo "[mcphub] Legacy migration completed."
                break
            fi
            sleep 2
        done
    ) >/dev/null 2>&1 &
fi

echo "[mcphub] Starting..."
exec dumb-init -- /usr/local/bin/entrypoint.sh "$@"