# syntax=docker/dockerfile:1
# ==============================================================================
# ADDON_SLUG HA Addon - 多阶段源码构建型
# 适用场景: 开源项目需源码编译 (如 Baihu Panel, Qinglong, WorkBuddy2API, QD-Today)
# 架构特性: Stage 1 编译工具链与统一补丁 -> Stage 2 纯净 debian-base 运行时 + S6 Overlay v3
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/2] Build & Dependencies Compilation (构建阶段)
# ==============================================================================
FROM --platform=$BUILDPLATFORM golang:1.24 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG APP_VERSION
RUN test -n "${APP_VERSION}" || { echo "APP_VERSION is required"; exit 1; }

# --- 1.1 Source Fetch ---
RUN git clone --depth 1 --branch "v${APP_VERSION}" \
       https://github.com/owner/repo.git /src/ADDON_SLUG \
    || { echo "Failed to clone repository @ v${APP_VERSION}"; exit 1; }

WORKDIR /src/ADDON_SLUG

# --- 1.2 Apply Hot Patches ---
# 统一多仓库自动映射: patches/<repo_name>/*.patch -> /src/<repo_name> (全仓共用 .github/scripts/apply-patches.sh)
RUN --mount=type=bind,from=common,source=apply-patches.sh,target=/tmp/apply-patches.sh \
    --mount=type=bind,source=patches,target=/patches \
    sh /tmp/apply-patches.sh

# --- 1.3 Compile Backend ---
ENV GOPROXY="https://proxy.golang.org,https://goproxy.io,direct"
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags="-s -w" -o /app-bin .

# ==============================================================================
# [Stage 2/2] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# --- 2.1 Runtime Dependencies ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        procps \
    && rm -rf /var/lib/apt/lists/*

# --- 2.2 Application Artifacts ---
COPY --from=builder /app-bin /usr/local/bin/app
RUN chmod +x /usr/local/bin/app

# --- 2.3 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish

# --- 2.4 Network & Healthcheck ---
EXPOSE 8080/tcp

HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:8080/" || exit 1

# S6 overlay 接管启动（启动脚本: rootfs/etc/s6-overlay/s6-rc.d/ADDON_SLUG/run）
