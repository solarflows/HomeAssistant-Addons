#=============================================================================
# Uptime Kuma HA Addon - debian-base + S6 overlay + Node.js 源码构建
#=============================================================================
# 上游: https://github.com/louislam/uptime-kuma
# 参考: https://github.com/hassio-addons/app-uptime-kuma
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Node.js builder ----
FROM node:22-bookworm-slim AS builder

ARG UPTIME_KUMA_VERSION
RUN test -n "${UPTIME_KUMA_VERSION}" || { echo "UPTIME_KUMA_VERSION is required"; exit 1; }

WORKDIR /app

# 下载源码并构建
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && curl -fsSL "https://github.com/louislam/uptime-kuma/archive/refs/tags/${UPTIME_KUMA_VERSION}.tar.gz" \
        | tar xzf - --strip-components 1 \
    && npm ci --no-audit --no-fund --no-update-notifier --omit=dev \
    && npm run download-dist \
    && apt-get purge -y curl \
    && rm -rf /var/lib/apt/lists/* /root/.npm /root/.cache /tmp/*

# ---- Stage 2: HA 运行时 ----
FROM ${BUILD_FROM}

# 安装 Node.js 22 + Python3/Apprise (通知支持)
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends \
        nodejs \
        python3 \
        python3-pip \
        python3-setuptools \
    && pip3 install --break-system-packages apprise \
    && apt-get purge -y curl \
    && rm -rf /var/lib/apt/lists/*

# 复制构建产物
COPY --from=builder /app /opt/uptime-kuma
WORKDIR /opt/uptime-kuma

# 复制 HA rootfs (S6 overlay)
COPY rootfs /

# 端口
EXPOSE 3001/tcp

# 环境变量
ENV UPTIME_KUMA_IS_CONTAINER=1 \
    UPTIME_KUMA_PORT=3001 \
    UPTIME_KUMA_HOST=0.0.0.0 \
    UPTIME_KUMA_WS_ORIGIN_CHECK=bypass \
    NODE_ENV=production

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:3001/ || exit 1
