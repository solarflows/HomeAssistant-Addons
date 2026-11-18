# syntax=docker/dockerfile:1
# ==============================================================================
# QD-Today HA Addon - debian-base 同源多阶段构建 (全量版: 包含 OCR 套件)
# 两个阶段共享 debian-base (Trixie)，libc/libcurl/Python ABI 天然一致
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/2] Build & Dependencies Compilation (同源构建阶段)
# ==============================================================================
FROM ${BUILD_FROM} AS builder

# --- 1.1 Toolchain & Package Manager ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 python3-pip python-is-python3 python3-dev \
        python3-setuptools python3-wheel \
        build-essential pkg-config \
        libcurl4-openssl-dev libssl-dev libffi-dev \
        git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --break-system-packages uv

# --- 1.2 Upstream Source Fetch ---
ARG QD_VERSION
RUN test -n "${QD_VERSION}" || { echo "QD_VERSION is required"; exit 1; }
RUN git clone --depth 1 --branch "${QD_VERSION}" https://github.com/qd-today/qd.git /src/qd \
    || { echo "Failed to clone qd-today @ ${QD_VERSION}"; exit 1; }

WORKDIR /src/qd

# --- 1.3 Apply Hot Patches ---
RUN --mount=type=bind,from=common,source=apply-patches.sh,target=/tmp/apply-patches.sh \
    --mount=type=bind,source=patches,target=/patches \
    sh /tmp/apply-patches.sh

# --- 1.4 Dependencies Compilation ---
# 使用 uv 严格从官方 uv.lock 导出包含全量 OCR 栈的依赖清单，全量安装到 /opt/qd-deps
# pycurl 强制以源码编译（--no-binary pycurl），确保与系统 libcurl4 严格同源对齐，杜绝 ABI 漂移
RUN uv export --frozen --no-hashes --no-emit-project --extra ocr -o /tmp/requirements.txt \
    && PYCURL_SSL_LIBRARY=openssl pip install --no-cache-dir --target /opt/qd-deps --no-binary pycurl -r /tmp/requirements.txt

# ==============================================================================
# [Stage 2/2] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# --- 2.1 Artifacts & Runtime Libraries ---
COPY --from=builder /opt/qd-deps /opt/qd-deps
COPY --from=builder /src/qd /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 libcurl4 libssl3 \
        curl git openssh-client \
    && rm -rf /var/lib/apt/lists/*

# --- 2.2 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish

# --- 2.3 Network & Healthcheck ---
ENV PYTHONPATH=/opt/qd-deps
ENV PORT=8923
EXPOSE 8923/tcp

HEALTHCHECK --interval=30s --start-period=45s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:8923/" || exit 1

# S6 overlay 接管启动（启动脚本: rootfs/etc/s6-overlay/s6-rc.d/qdtoday/run）
