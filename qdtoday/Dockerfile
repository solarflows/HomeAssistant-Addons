#=============================================================================
# QD-Today HA Addon - debian-base 同源多阶段构建
#=============================================================================
# 两个阶段共享同一基础镜像，消除 libc / libcurl / Python 版本漂移
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: 编译阶段 (debian-base + 构建工具链) ----
FROM ${BUILD_FROM} AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 python3-pip python-is-python3 python3-dev \
        build-essential \
        libcurl4-openssl-dev libssl-dev libffi-dev \
        cargo rustc \
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

# 全量安装 Python 依赖
# 注意：pycurl 和 ddddocr 包含 C 扩展，留在运行时编译以链接到实际系统库
WORKDIR /src
RUN sed -i '/^pycurl/d;/^ddddocr/d' requirements.txt \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---- Stage 2: 运行时阶段 (debian-base，同源) ----
FROM ${BUILD_FROM}

# 签名
LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# 拷贝预编译纯 Python 包
COPY --from=builder /install /usr/local

# 编译带 C 扩展的包（链接到运行时系统库，ABI 天然一致）
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 python3-pip python-is-python3 python3-dev \
        libcurl4 libcurl4-openssl-dev libssl3 \
        curl git openssh-client \
        build-essential \
    && pip install --no-cache-dir --break-system-packages --no-binary pycurl --compile "pycurl==7.45.6" \
    && pip install --no-cache-dir --break-system-packages --compile ddddocr \
    && apt-get remove -y python3-dev libcurl4-openssl-dev build-essential \
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
    CMD curl -sfo /dev/null http://127.0.0.1:8923/ || exit 1

# S6 overlay 接管启动，不再依赖 Docker CMD
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/qdtoday/run
