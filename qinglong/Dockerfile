# syntax=docker/dockerfile:1
# ==============================================================================
# Qinglong HA Addon - 多阶段源码构建
# Stage 1: Node.js builder 克隆源码并应用统一补丁，编译前端和后端
# Stage 2: HA debian-base:9.3.0 运行时 + 生产依赖与 S6 守护
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/2] Build Frontend & Backend (源码与构建阶段)
# ==============================================================================
FROM node:18-alpine AS builder

ARG QINGLONG_VERSION
RUN test -n "${QINGLONG_VERSION}" || { echo "QINGLONG_VERSION is required"; exit 1; }

# --- 1.1 Toolchain & Package Manager ---
RUN npm i -g pnpm@8.3.1 \
    && apk add --no-cache git patch

# --- 1.2 Source Fetch ---
RUN git clone --depth 1 --branch "v${QINGLONG_VERSION}" \
       https://github.com/whyour/qinglong.git /src \
    || { echo "Failed to clone qinglong @ v${QINGLONG_VERSION}"; exit 1; }

WORKDIR /src

# --- 1.3 Apply Hot Patches ---
COPY patches/ /patches/
RUN chmod +x /patches/apply-patches.sh && /patches/apply-patches.sh "qinglong" /src

# --- 1.4 Dependencies & Compile ---
RUN pnpm install --frozen-lockfile \
    && pnpm run build:front \
    && pnpm run build:back

# ==============================================================================
# [Stage 2/2] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# --- 2.1 Runtime Tools & Node Environment ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        npm \
        python3 \
        python3-pip \
        curl \
        wget \
        git \
        jq \
        openssl \
        procps \
    && npm i -g pnpm@8.3.1 \
    && rm -rf /var/lib/apt/lists/*

# --- 2.2 Production Artifacts & Dependencies ---
COPY --from=builder /src /ql
RUN rm -rf /ql/node_modules
WORKDIR /ql

RUN pnpm install --prod --frozen-lockfile
RUN mkdir -p /ql/data

# --- 2.3 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish

# --- 2.4 Network & Healthcheck ---
ENV QL_DIR=/ql \
    NODE_ENV=production

EXPOSE 5700/tcp

HEALTHCHECK --interval=30s --start-period=90s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:5700/api/health" || exit 1

# S6 overlay 接管启动（启动脚本: rootfs/etc/s6-overlay/s6-rc.d/qinglong/run）
