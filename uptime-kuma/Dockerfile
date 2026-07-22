#=============================================================================
# Uptime Kuma HA Addon - debian-base + S6 overlay + 全套功能
#=============================================================================
# 上游 Dockerfile 参考:
#   docker/dockerfile           (多阶段构建)
#   docker/debian-base.dockerfile (base2-slim / base2)
#   docker/builder-go.dockerfile  (Go healthcheck)
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Apprise .deb 下载 (上游最新) ----
FROM node:22-bookworm-slim AS download-apprise
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl jq \
    && APPRISE_URL=$(curl -sS https://api.github.com/repos/caronc/apprise/releases/latest \
        | jq -r '.assets[] | select(.name | test("_all\\\\.deb$")) | .browser_download_url' \
        | head -1) \
    && echo "Downloading Apprise from: $APPRISE_URL" \
    && curl -fsSL "$APPRISE_URL" -o /apprise.deb \
    && ls -lh /apprise.deb \
    && apt-get purge -y curl jq \
    && rm -rf /var/lib/apt/lists/*

# ---- Stage 2: Node.js 源码构建 ----
FROM node:22-bookworm-slim AS builder

ARG UPTIME_KUMA_VERSION
RUN test -n "${UPTIME_KUMA_VERSION}" || { echo "UPTIME_KUMA_VERSION is required"; exit 1; }

WORKDIR /app

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && curl -fsSL "https://github.com/louislam/uptime-kuma/archive/refs/tags/${UPTIME_KUMA_VERSION}.tar.gz" \
        | tar xzf - --strip-components 1 \
    && npm ci --no-audit --no-fund --no-update-notifier --omit=dev \
    && npm run download-dist \
    && mkdir ./data \
    && apt-get purge -y curl \
    && rm -rf /var/lib/apt/lists/* /root/.npm /root/.cache /tmp/*

# ---- Stage 3: HA 运行时 (完整 base2 等价) ----
FROM ${BUILD_FROM}

#===========================================================================
# 依赖对照上游 debian-base.dockerfile (base2-slim + base2):
#   base2-slim: dumb-init / nscd / cloudflared / apprise / python3-paho-mqtt
#   base2:      chromium / fonts-indic / fonts-noto / fonts-noto-cjk / mariadb
#===========================================================================

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg \
    \
    # ---- Node.js 22 ----
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    \
    # ---- base2-slim 等价 ----
    && apt-get install -y --no-install-recommends \
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
    \
    # ---- base2 等价 (Chromium + 字体 + MariaDB) ----
    && apt-get install -y --no-install-recommends \
        chromium \
        fonts-indic \
        fonts-noto \
        fonts-noto-cjk \
        mariadb-server \
    \
    # ---- cloudflared (Cloudflare Tunnel) ----
    && curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
        -o /usr/share/keyrings/cloudflare-main.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bookworm main' \
        | tee /etc/apt/sources.list.d/cloudflared.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends cloudflared \
    && cloudflared version

# ---- Apprise (从 Stage 1 复制的 .deb 最新版) ----
COPY --from=download-apprise /apprise.deb /tmp/apprise.deb
RUN apt-get install -y --no-install-recommends /tmp/apprise.deb \
    && rm -f /tmp/apprise.deb \
    \
    # ---- 清理 (保留 curl 给 HEALTHCHECK 用) ----
    && apt-get purge -y gnupg \
    && rm -rf /var/lib/apt/lists/*

# ---- nscd 配置 (上游 docker/etc/nscd.conf) ----
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

# 复制构建产物
COPY --from=builder /app /opt/uptime-kuma
WORKDIR /opt/uptime-kuma

# 复制 HA rootfs (S6 overlay)
COPY rootfs /

# 端口
EXPOSE 3001/tcp

# 环境变量 (参照上游 docker/dockerfile + debian-base.dockerfile)
ENV UPTIME_KUMA_IS_CONTAINER=1 \
    UPTIME_KUMA_PORT=3001 \
    UPTIME_KUMA_HOST=0.0.0.0 \
    UPTIME_KUMA_WS_ORIGIN_CHECK=bypass \
    UPTIME_KUMA_ENABLE_EMBEDDED_MARIADB=1 \
    NODE_ENV=production

# Healthcheck (curl 替代上游 Go 二进制)
HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 \
    CMD curl -sf http://127.0.0.1:3001/ || exit 1
