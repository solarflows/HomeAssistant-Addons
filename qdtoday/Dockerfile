#=============================================================================
# QD-Today HA Addon - 多阶段源码构建
#=============================================================================
# 多阶段构建（编译与运行严格分离）：
#   Stage 1 (builder): 全量编译工具链 → pip 安装所有依赖，失败即终止
#   Stage 2 (runtime): 仅运行时库 → 拷贝预编译产物，零编译
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: 编译阶段 (python:3.13-slim-bookworm, 全量构建工具链) ----
# 与运行时 debian-base:9.3.0 (Python 3.13) 版本对齐，避免 site-packages 路径差异
FROM python:3.13-slim-bookworm AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libcurl4-openssl-dev \
        libssl-dev \
        libffi-dev \
        cargo \
        rustc \
        git \
    && rm -rf /var/lib/apt/lists/*

# 克隆源码（构建参数由 CI 注入）
ARG QD_VERSION
RUN test -n "${QD_VERSION}" || { echo "QD_VERSION is required"; exit 1; }
RUN git clone --depth 1 --branch "${QD_VERSION}" https://github.com/qd-today/qd.git /src \
    || { echo "Failed to clone qd-today @ ${QD_VERSION}"; exit 1; }

# Patch: Python 3.12+ 将 and/or/not 条件跳转合并为 TO_BOOL opcode
# 上游 _SAFE_OPCODES 未收录 → 条件表达式触发 forbidden opcode
RUN python3 <<'PYEOF'
import sys
src = '/src/libs/safe_eval.py'
with open(src) as f:
    c = f.read()
old = "'FORMAT_VALUE', 'BUILD_STRING'"
new = "'FORMAT_VALUE', 'BUILD_STRING', 'TO_BOOL'"
if old not in c:
    print(f"ERROR: target string not found in {src}", file=sys.stderr)
    sys.exit(1)
c = c.replace(old, new)
with open(src, 'w') as f:
    f.write(c)
print('patched:', src)
PYEOF

# 全量安装 Python 依赖（编译失败即终止，不做降级）
WORKDIR /src
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# 上游注释掉的完整版依赖：ddddocr (OCR 验证码) + pycurl (SOCKS5 代理)
# pycurl 在运行时阶段单独编译，避免跨阶段 libcurl 版本不匹配
RUN pip install --no-cache-dir --prefix=/install --compile ddddocr

# ---- Stage 2: 运行时阶段 (HA debian-base, 零编译) ----
FROM ${BUILD_FROM}

# 拷贝预编译包 + 桥接 Debian dist-packages ← python 官方 site-packages
# Debian Python 只扫 /usr/local/lib/python3.X/dist-packages/，忽略 site-packages/
COPY --from=builder /install /usr/local

# 全部运行时依赖 + pycurl 编译在同一 RUN：确保 libcurl4 和 libcurl4-openssl-dev 版本一致
RUN SRC=$(ls -d /usr/local/lib/python3.*/site-packages 2>/dev/null | head -1) && \
    DST_DIR=$(dirname "$SRC") && DST="$DST_DIR/dist-packages" && \
    if [ -n "$SRC" ] && [ ! -L "$DST" ]; then \
        rm -rf "$DST" && ln -s site-packages "$DST"; \
        echo "Bridge: $SRC → $DST"; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 python3-pip python-is-python3 \
        libcurl4 libcurl4-openssl-dev libssl3 \
        curl git openssh-client \
        build-essential \
    && pip install --no-cache-dir --break-system-packages --compile pycurl \
    && apt-get remove -y libcurl4-openssl-dev build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# 拷贝源码
COPY --from=builder /src /usr/src/app
WORKDIR /usr/src/app

# 复制 HA rootfs
COPY rootfs /

# 修复 Windows 平台丢失的执行权限 (Git 不保留 Unix 权限位)
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh
ENV PORT=8923
EXPOSE 8923/tcp

HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:8923/ || exit 1

# S6 overlay 接管启动，不再依赖 Docker CMD
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/qdtoday/run
