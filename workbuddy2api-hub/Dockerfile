# syntax=docker/dockerfile:1
# ==============================================================================
# WorkBuddy2API Hub HA Addon - debian-base 多阶段源码构建 (S6 overlay)
# Stage 1: 拉取上游源码并应用统一补丁，静态编译 Go uTLS ClientHello 桥
# Stage 2: ghcr.io/hassio-addons/debian-base:9.3.0 运行时 + S6 进程监督与热更新协同
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/2] Source Fetch, Hot Patching & Cross-compile (构建阶段)
# ==============================================================================
FROM --platform=$BUILDPLATFORM golang:1.24 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG WB2API_VERSION
RUN test -n "${WB2API_VERSION}" || { echo "WB2API_VERSION is required"; exit 1; }

# --- 1.1 Source Fetch ---
RUN git clone --depth 1 --branch "v${WB2API_VERSION}" \
        https://github.com/ardeyouxipianyi/workbuddy2api-hub.git /src \
    || { echo "Failed to clone workbuddy2api-hub @ v${WB2API_VERSION}"; exit 1; }

WORKDIR /src

# --- 1.2 Apply Hot Patches ---
COPY patches/ /patches/
RUN chmod +x /patches/apply-patches.sh && /patches/apply-patches.sh "workbuddy2api-hub" /src

# --- 1.3 Compile Go uTLS ClientHello Bridge ---
WORKDIR /src/tools/wb-tls-bridge
ENV GOPROXY="https://proxy.golang.org,https://goproxy.io,direct"
RUN mkdir -p /src/bin /src/licenses/wb-tls-bridge \
    && CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
       go build -trimpath -ldflags="-s -w" -o /src/bin/wb-tls-bridge . \
    && cp /src/tools/wb-tls-bridge/README.md /src/licenses/wb-tls-bridge/README.md \
    && cp -r /src/tools/wb-tls-bridge/licenses/. /src/licenses/wb-tls-bridge/ \
    && rm -rf /src/.git /src/tests

# ==============================================================================
# [Stage 2/2] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# --- 2.1 Runtime Dependencies ---
# python3 / python3-yaml: 网关主程序及可选 Mihomo 订阅桥依赖
# jq / curl / tzdata / ca-certificates / procps: 选项回填、探针、时区与进程管理
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-yaml \
        jq \
        curl \
        tzdata \
        ca-certificates \
        procps \
    && rm -rf /var/lib/apt/lists/*

# --- 2.2 Application Artifacts ---
COPY --from=builder /src /app
RUN mkdir -p /app/accounts /app/usage /app/subbridge-data \
    && chmod +x /app/*.sh /app/bin/wb-tls-bridge

# --- 2.3 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish

# --- 2.4 Network & Healthcheck ---
ENV PYTHONUNBUFFERED=1 \
    HOST=0.0.0.0 \
    PORT=8788

WORKDIR /app
EXPOSE 8788/tcp

HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:${PORT}/health" || exit 1
