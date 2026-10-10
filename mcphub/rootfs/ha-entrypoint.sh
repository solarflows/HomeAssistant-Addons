#!/bin/bash
#=============================================================================
# MCPHub HA 适配入口
#=============================================================================
#   1) 数据目录接管: /app/data → /config/mcphub（设置/用户/凭据绑定，随 HA 备份）
#   2) 软件包缓存接管: /root/.npm、/root/.cache → /data/mcphub
#      （npx/uvx 拉取的 MCP server 包在 addon 更新后不丢失，冷启动更快）
#   3) CLI profile 接管: /root/.config/mcphub、/root/.local/share/mcphub → /data/mcphub
#   4) HA addon options → 环境变量（ADMIN_PASSWORD / NPM_REGISTRY）
#   5) 链到上游 entrypoint（保留其 npm registry / 代理配置逻辑）
#=============================================================================
set -e

echo "[mcphub] Preparing persistent directories..."
mkdir -p /config/mcphub /data/mcphub/npm /data/mcphub/cache

# ---- /app/data → /config/mcphub ----
if [ ! -L /app/data ]; then
    if [ -d /app/data ]; then
        # 迁移同容器内可能产生的数据（正常路径下为空目录）
        if ! cp -a /app/data/. /config/mcphub/; then
            echo "[mcphub] WARNING: failed to migrate /app/data into /config/mcphub (continuing)"
        fi
        rm -rf /app/data
    fi
    ln -s /config/mcphub /app/data
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

echo "[mcphub] Starting..."
exec dumb-init -- /usr/local/bin/entrypoint.sh "$@"