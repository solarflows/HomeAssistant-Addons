# syntax=docker/dockerfile:1
# ==============================================================================
# Uptime Kuma HA Addon - debian-base + S6 overlay + 全套功能
# Stage 1: Node.js 源码构建与统一补丁
# Stage 2: HA debian-base:9.3.0 运行时 (完整 base2 等价) + S6 Overlay
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/2] Build & Dependencies Compilation (构建阶段)
# ==============================================================================
FROM node:22-bookworm-slim AS builder

ARG UPTIME_KUMA_VERSION
RUN test -n "${UPTIME_KUMA_VERSION}" || { echo "UPTIME_KUMA_VERSION is required"; exit 1; }

WORKDIR /src/uptime-kuma

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

# --- 1.1 Source Fetch ---
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates patch \
    && curl -fsSL "https://github.com/louislam/uptime-kuma/archive/refs/tags/${UPTIME_KUMA_VERSION}.tar.gz" \
        | tar xzf - --strip-components 1

# --- 1.2 Apply Hot Patches ---
RUN --mount=type=bind,from=common,source=apply-patches.sh,target=/tmp/apply-patches.sh \
    --mount=type=bind,source=patches,target=/patches \
    sh /tmp/apply-patches.sh

# --- 1.3 Compile & Prepare Frontend ---
RUN npm ci --no-audit --no-fund --no-update-notifier --omit=dev \
    && npm run download-dist \
    && mkdir ./data \
    && apt-get purge -y curl \
    && rm -rf /var/lib/apt/lists/* /root/.npm /root/.cache /tmp/*

# ==============================================================================
# [Stage 2/2] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# --- 2.1 Runtime Tools, Chromium & Database ---
# base2-slim 等价: dumb-init / nscd / sudo / sqlite3 / ping / python3
# base2 等价: chromium / 字体族 / mariadb-server
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends \
        nodejs \
        dumb-init \
        nscd \
        sudo \
        sqlite3 \
        iputils-ping \
        util-linux \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-paho-mqtt \
        chromium \
        fonts-indic \
        fonts-noto \
        fonts-noto-cjk \
        mariadb-server \
    && pip3 install --break-system-packages --no-cache-dir apprise \
    && apt-get purge -y gnupg \
    && rm -rf /var/lib/apt/lists/*

# --- 2.2 Cloudflared Tunnel & DNS Cache ---
RUN curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
        -o /usr/share/keyrings/cloudflare-main.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bookworm main' \
        | tee /etc/apt/sources.list.d/cloudflared.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends cloudflared \
    && cloudflared version \
    && rm -rf /var/lib/apt/lists/*

RUN printf '# Uptime Kuma nscd config (hosts cache only)\n\
enable-cache\tpasswd\tno\n\
enable-cache\tgroup\tno\n\
enable-cache\thosts\tyes\n\
positive-time-to-live\thosts\t3600\n\
negative-time-to-live\thosts\t20\n\
suggested-size\thosts\t211\n\
check-files\thosts\tyes\n\
persistent\thosts\tyes\n\
shared\thosts\tno\n\
max-db-size\thosts\t33554432\n\
enable-cache\tservices\tno\n\
enable-cache\tnetgroup\tno\n\
paranoia\tno\n\
debug-level\t0\n' > /etc/nscd.conf

# --- 2.3 Application Artifacts & Native Modules Rebuild ---
COPY --from=builder /src/uptime-kuma /opt/uptime-kuma
WORKDIR /opt/uptime-kuma

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && npm rebuild \
    && apt-get purge -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# --- 2.4 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish

# --- 2.5 Network & Healthcheck ---
EXPOSE 3001/tcp

ENV UPTIME_KUMA_IS_CONTAINER=1 \
    UPTIME_KUMA_PORT=3001 \
    UPTIME_KUMA_HOST=0.0.0.0 \
    UPTIME_KUMA_WS_ORIGIN_CHECK=bypass \
    UPTIME_KUMA_ENABLE_EMBEDDED_MARIADB=1 \
    NODE_ENV=production

HEALTHCHECK --interval=60s --timeout=15s --start-period=180s --retries=5 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 10 "http://127.0.0.1:3001/" || exit 1

# S6 overlay 接管启动（启动脚本: rootfs/etc/s6-overlay/s6-rc.d/uptime-kuma/run）
