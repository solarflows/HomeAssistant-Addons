# syntax=docker/dockerfile:1
# ==============================================================================
# Baihu Panel HA Addon - Go 多阶段编译
# Stage 1: Go builder 编译前端 Web 与后端二进制
# Stage 2: HA debian-base:9.3.0 运行时 + mise 多环境管理
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/2] Build & Dependencies Compilation (构建阶段)
# ==============================================================================
FROM --platform=$BUILDPLATFORM golang:1.26 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG BAIHU_VERSION
RUN test -n "${BAIHU_VERSION}" || { echo "BAIHU_VERSION is required"; exit 1; }

# --- 1.1 Source Fetch ---
RUN git clone --depth 1 --branch "v${BAIHU_VERSION}" \
       https://github.com/engigu/baihu-panel.git /src/baihu-panel \
    || { echo "Failed to clone baihu-panel @ v${BAIHU_VERSION}"; exit 1; }

WORKDIR /src/baihu-panel

# --- 1.2 Apply Hot Patches ---
RUN --mount=type=bind,from=common,source=apply-patches.sh,target=/tmp/apply-patches.sh \
    --mount=type=bind,source=patches,target=/patches \
    sh /tmp/apply-patches.sh

# --- 1.3 Node.js Toolchain (Vite WebUI requires >= 20) ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# --- 1.4 Frontend Build ---
RUN if [ -d "web" ] && [ -f "web/package.json" ]; then \
        cd web && npm ci && npm run build && cd ..; \
    fi \
    && mkdir -p /www/baihu \
    && if [ -d "web/dist" ]; then \
        cp -r web/dist/* /www/baihu/; \
    else \
        touch /www/baihu/.gitkeep; \
    fi \
    && mkdir -p /app/configs \
    && if [ -d "configs" ] && ls configs/* >/dev/null 2>&1; then \
        cp -r configs/* /app/configs/; \
    else \
        touch /app/configs/.gitkeep; \
    fi

# --- 1.5 Backend Build ---
ENV GOPROXY="https://proxy.golang.org,https://goproxy.io,direct"
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags="-s -w" -o /baihu .

# ==============================================================================
# [Stage 2/2] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# --- 2.1 Runtime Tools & mise Manager ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        wget \
        git \
        ca-certificates \
        rsync \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://mise.run | sh \
    && mv /root/.local/bin/mise /usr/local/bin/mise

# 预装 Python 和 Node 到 /opt/mise-base（构建期提前缓存）
ENV MISE_DATA_DIR=/opt/mise-base MISE_CONFIG_DIR=/opt/mise-base
RUN mise install python@3 node@22 \
    && mise use -g python@3 \
    && mise use -g node@22

# --- 2.2 Application Artifacts ---
COPY --from=builder /baihu /usr/local/bin/baihu
RUN chmod +x /usr/local/bin/baihu

COPY --from=builder /www/baihu /www/baihu
COPY --from=builder /app/configs /app/configs
RUN mkdir -p /app/data /app/configs /app/envs

# --- 2.3 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish

# --- 2.4 Network & Healthcheck ---
ENV BH_SERVER_PORT=8052 \
    BH_SERVER_HOST=0.0.0.0 \
    BH_DB_PATH=/app/data/baihu.db \
    MISE_TRUSTED_CONFIG_PATHS=/app/data/scripts \
    NODE_OPTIONS="--max-old-space-size=256" \
    PYTHONPATH=/app/data/scripts

EXPOSE 8052/tcp

HEALTHCHECK --interval=30s --start-period=45s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:8052/api/v1/ping" || exit 1

# S6 overlay 接管启动（启动脚本: rootfs/etc/s6-overlay/s6-rc.d/baihu/run）
