#!/bin/bash
#=============================================================================
# FlareSolverr HA 入口脚本
# 参考: alexbelgium/hassio-addons/flaresolverr
#=============================================================================
set -e

# ---- Chromium /dev/shm 修复（避免大量共享内存导致算术溢出） ----
FIX_FILE="/etc/chromium.d/dev-shm"
if [ -f "$FIX_FILE" ]; then
    echo "[FlareSolverr] Patching Chromium shared memory helper"
    cat > "$FIX_FILE" << 'PATCH'
# Patched for HA addon: avoid arithmetic errors with large /dev/shm values
shm_avail=$(findmnt -bnr -o avail -T /dev/shm 2>/dev/null)
if python3 - "${shm_avail}" <<'PY'
import re, sys
raw = sys.argv[1] if len(sys.argv) > 1 else ''
match = re.search(r'\d+', raw)
value = int(match.group(0)) if match else 0
sys.exit(0 if value < 4080218931 else 1)
PY
then
    exec python3 -c "
import os
shm_size = os.statvfs('/dev/shm').f_frsize * os.statvfs('/dev/shm').f_blocks
os.environ['CHROMIUM_SHM_SIZE_PERCENT'] = str(int((os.environ.get('CHROMIUM_SHM_SIZE_PERCENT', 50))))
" 2>/dev/null
fi
PATCH
fi

# ---- Chromium wrapper bash 兼容（Chromium 140+ 需要 bash） ----
CHROMIUM_WRAPPER="/usr/bin/chromium"
if [ -f "$CHROMIUM_WRAPPER" ] && grep -q '^#!/bin/sh' "$CHROMIUM_WRAPPER" 2>/dev/null; then
    if grep -q '==' "$CHROMIUM_WRAPPER" 2>/dev/null; then
        echo "[FlareSolverr] Switching Chromium wrapper to bash for compatibility"
        sed -i '1s|/bin/sh|/bin/bash|' "$CHROMIUM_WRAPPER"
    fi
fi

echo "Warning - minimum configuration recommended: 2 CPU cores and 4 GB memory"
echo "[FlareSolverr] Starting..."

exec dumb-init -- python -u /app/flaresolverr.py