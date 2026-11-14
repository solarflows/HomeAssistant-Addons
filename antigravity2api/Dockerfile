# syntax=docker/dockerfile:1
#=============================================================================
# Antigravity2API HA Addon - 多阶段源码构建 (BoringCrypto / CGO 原生支持)
#=============================================================================
# Stage 1: 克隆指定版本的上游源码
# Stage 2: 编译前端 WebUI (Node 22 + pnpm)
# Stage 3: 交叉编译 Go 后端并开启 CGO_ENABLED=1 GOEXPERIMENT=boringcrypto
# Stage 4: HA debian-base:9.3.0 运行时 + S6 Overlay v3 守护与原生熔断
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Clone source ----
FROM alpine/git:latest AS source

ARG VERSION
RUN test -n "${VERSION}" || { echo "VERSION is required"; exit 1; }

RUN git clone --depth 1 --branch "v${VERSION}" https://github.com/Mag1cFall/Antigravity2API.git /src \
    || git clone --depth 1 --branch "${VERSION}" https://github.com/Mag1cFall/Antigravity2API.git /src \
    || { echo "Failed to clone Antigravity2API @ ${VERSION}"; exit 1; }

# ---- Stage 2: Build WebUI ----
FROM --platform=$BUILDPLATFORM node:22-bookworm-slim AS web-builder

WORKDIR /src/web
RUN corepack enable
COPY --from=source /src/web/package.json /src/web/pnpm-lock.yaml /src/web/pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile
COPY --from=source /src/web/ ./
COPY --from=source /src/internal/i18n/messages/ /src/internal/i18n/messages/
RUN pnpm run build

# ---- Stage 3: Cross-compile Go with BoringCrypto (CGO_ENABLED=1) ----
FROM --platform=$BUILDPLATFORM golang:1.27-bookworm AS app-builder

ARG TARGETOS
ARG TARGETARCH
ARG VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        libc6-dev \
        gcc-aarch64-linux-gnu \
        libc6-dev-arm64-cross \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY --from=source /src/go.mod /src/go.sum ./
RUN go mod download
COPY --from=source /src/ ./
COPY --from=web-builder /src/internal/webui/dist ./internal/webui/dist

RUN set -e; \
    if [ "${TARGETARCH}" = "arm64" ]; then \
        export CC=aarch64-linux-gnu-gcc; \
    else \
        export CC=gcc; \
    fi; \
    echo "=== Compiling Antigravity2API (${TARGETOS}/${TARGETARCH}) with CC=${CC} and BoringCrypto ==="; \
    CGO_ENABLED=1 GOOS=${TARGETOS} GOARCH=${TARGETARCH} GOEXPERIMENT=boringcrypto \
    go build -trimpath -ldflags="-s -w" -o /out/antigravity2api ./cmd/antigravity2api

# ---- Stage 4: HA debian-base runtime + S6 overlay ----
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        tzdata \
        curl \
        jq \
        procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=app-builder /out/antigravity2api /usr/local/bin/antigravity2api

RUN mkdir -p /config /data/runtime /data/logs \
    && chmod +x /usr/local/bin/antigravity2api

COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh \
    LISTEN=0.0.0.0:8017 \
    TZ=Asia/Shanghai

WORKDIR /config
EXPOSE 8017/tcp

HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -fsS --noproxy '*' "http://127.0.0.1:8017/api/status" >/dev/null || exit 1
