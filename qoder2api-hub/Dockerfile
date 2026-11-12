# syntax=docker/dockerfile:1
#=============================================================================
# Qoder2API Hub HA Addon - debian-base 多阶段源码构建 (S6 overlay)
#=============================================================================
# Stage 1: 拉取上游源码并按 TARGETARCH 提取官方 glibc UMID runtime-info
# Stage 2: ghcr.io/hassio-addons/debian-base:9.3.0 原生运行时（免除 Alpine gcompat）+ S6
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Clone source & extract native glibc UMID component ----
FROM ${BUILD_FROM} AS builder

ARG TARGETARCH
ARG QODER_VERSION
RUN test -n "${QODER_VERSION}" || { echo "QODER_VERSION is required"; exit 1; }

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        git \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "v${QODER_VERSION}" \
        https://github.com/shuishuipingan/qoder2api-hub.git /src \
    || { echo "Failed to clone qoder2api-hub @ v${QODER_VERSION}"; exit 1; }

RUN UMID_ARCH="x64"; [ "${TARGETARCH}" = "arm64" ] && UMID_ARCH="arm64"; \
    python3 /src/_install_umid.py --platform linux --arch "${UMID_ARCH}" --dest /src/umid \
    || echo "WARN: UMID extraction failed (gateway will fall back to derived identity)"; \
    mkdir -p /src/umid \
    && rm -rf /src/.git /src/docs/img

# ---- Stage 2: HA debian-base runtime + S6 overlay ----
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# Debian Trixie 原生 glibc：直接运行 UMID ELF 无需 Alpine gcompat；python3-pil 提供图像编解码
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pil \
        jq \
        curl \
        tzdata \
        ca-certificates \
        procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src /app

RUN mkdir -p /app/accounts /app/logs/usage /app/usage \
    && chmod +x /app/*.sh \
    && { [ ! -f /app/umid/runtime-info ] || chmod +x /app/umid/runtime-info; }

COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh \
    PYTHONUNBUFFERED=1 \
    HOST=0.0.0.0 \
    PORT=8790 \
    TZ=Asia/Shanghai

WORKDIR /app
EXPOSE 8790/tcp

HEALTHCHECK --interval=30s --start-period=20s --timeout=5s --retries=3 \
    CMD curl -fsS --noproxy '*' "http://127.0.0.1:${PORT}/ping" >/dev/null || exit 1
