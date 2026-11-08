# syntax=docker/dockerfile:1
#=============================================================================
# QD-Today HA Addon - debian-base 同源多阶段构建 (全量版: 包含 OCR 套件)
#=============================================================================
# 两个阶段共享 debian-base (Trixie)，libc/libcurl/Python ABI 天然一致
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: 编译/依赖构建阶段 ----
FROM ${BUILD_FROM} AS builder

# 安装构建工具链与 uv（移除冗余的 cargo/rustc，大幅加速构建并缩减层体积）
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 python3-pip python-is-python3 python3-dev \
        build-essential \
        libcurl4-openssl-dev libssl-dev libffi-dev \
        git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --break-system-packages uv

# 克隆源码（构建版本参数由 CI 矩阵自动注入）
ARG QD_VERSION
RUN test -n "${QD_VERSION}" || { echo "QD_VERSION is required"; exit 1; }
RUN git clone --depth 1 --branch "${QD_VERSION}" https://github.com/qd-today/qd.git /src \
    || { echo "Failed to clone qd-today @ ${QD_VERSION}"; exit 1; }

WORKDIR /src

# 使用 uv 严格从官方 uv.lock 导出包含全量 OCR 栈的依赖清单，并全量安装到 /opt/qd-deps
RUN uv export --frozen --no-hashes --no-emit-project --extra ocr -o /tmp/requirements.txt \
    && pip install --no-cache-dir --target /opt/qd-deps -r /tmp/requirements.txt

# ---- Stage 2: 运行时阶段 (纯净同源 debian-base) ----
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# 拷贝预编译产物与源码（彻底避开 Debian dist-packages 污染与 PEP 668 限制）
COPY --from=builder /opt/qd-deps /opt/qd-deps
COPY --from=builder /src /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 libcurl4 libssl3 \
        curl git openssh-client \
    && rm -rf /var/lib/apt/lists/*

# 复制 HA rootfs
COPY rootfs /

# 修复执行权限
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh
ENV PYTHONPATH=/opt/qd-deps
ENV PORT=8923
EXPOSE 8923/tcp

HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null http://127.0.0.1:8923/ || exit 1

# S6 overlay 接管启动（启动脚本: rootfs/etc/s6-overlay/s6-rc.d/qdtoday/run）
