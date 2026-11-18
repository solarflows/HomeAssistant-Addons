# syntax=docker/dockerfile:1
# ==============================================================================
# Qoder2API Hub HA Addon - debian-base 多阶段源码构建 (S6 overlay)
# Stage 1: 拉取上游源码并应用统一补丁，提取官方 glibc UMID runtime-info
# Stage 2: ghcr.io/hassio-addons/debian-base:9.3.0 原生运行时 + S6 进程监督
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/2] Source Fetch, Hot Patching & UMID Extraction (构建阶段)
# ==============================================================================
FROM ${BUILD_FROM} AS builder

ARG TARGETARCH
ARG QODER_VERSION
RUN test -n "${QODER_VERSION}" || { echo "QODER_VERSION is required"; exit 1; }

# --- 1.1 Toolchain & Package Manager ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        git \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# --- 1.2 Source Fetch ---
RUN git clone --depth 1 --branch "v${QODER_VERSION}" \
        https://github.com/shuishuipingan/qoder2api-hub.git /src/qoder2api-hub \
    || { echo "Failed to clone qoder2api-hub @ v${QODER_VERSION}"; exit 1; }

WORKDIR /src/qoder2api-hub

# --- 1.3 Apply Hot Patches ---
RUN --mount=type=bind,from=common,source=apply-patches.sh,target=/tmp/apply-patches.sh \
    --mount=type=bind,source=patches,target=/patches \
    sh /tmp/apply-patches.sh

# --- 1.4 Native UMID Component Extraction ---
RUN UMID_ARCH="x64"; [ "${TARGETARCH}" = "arm64" ] && UMID_ARCH="arm64"; \
    python3 /src/qoder2api-hub/_install_umid.py --platform linux --arch "${UMID_ARCH}" --dest /src/qoder2api-hub/umid \
    || echo "WARN: UMID extraction failed (gateway will fall back to derived identity)"; \
    mkdir -p /src/qoder2api-hub/umid \
    && rm -rf /src/qoder2api-hub/.git /src/qoder2api-hub/docs/img

# ==============================================================================
# [Stage 2/2] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# --- 2.1 Runtime Dependencies ---
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

# --- 2.2 Application Artifacts ---
COPY --from=builder /src/qoder2api-hub /app
RUN mkdir -p /app/accounts /app/logs/usage /app/usage \
    && chmod +x /app/*.sh \
    && { [ ! -f /app/umid/runtime-info ] || chmod +x /app/umid/runtime-info; }

# --- 2.3 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish

# --- 2.4 Network & Healthcheck ---
ENV PYTHONUNBUFFERED=1 \
    HOST=0.0.0.0 \
    PORT=8790

WORKDIR /app
EXPOSE 8790/tcp

HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:${PORT}/ping" || exit 1
