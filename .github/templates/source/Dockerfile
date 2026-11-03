#=============================================================================
# ADDON_SLUG HA Addon - 多阶段源码构建型
#=============================================================================
# 适用场景: 开源项目无预编译发布，需本地编译 (如 Baihu Panel, Qinglong, Uptime Kuma)
# 架构特性: Stage 1 专用编译工具链 -> Stage 2 纯净 debian-base 运行时 + S6 overlay
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: 编译构建阶段 (以 Go 静态编译为例) ----
FROM --platform=$BUILDPLATFORM golang:1.24 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG APP_VERSION
RUN test -n "${APP_VERSION}" || { echo "APP_VERSION is required"; exit 1; }

# 克隆上游源码
RUN git clone --depth 1 --branch "v${APP_VERSION}"        https://github.com/owner/repo.git /src     || { echo "Failed to clone repository @ v${APP_VERSION}"; exit 1; }

WORKDIR /src

# 配置多代理链路 (自动容灾降级)，拉取依赖并静态编译
ENV GOPROXY="https://proxy.golang.org,https://goproxy.io,direct"
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH}     go build -ldflags="-s -w" -o /app-bin .

# ---- Stage 2: HA 运行时阶段 ----
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# 安装最小运行时依赖:
#   - ca-certificates: HTTPS 证书
#   - curl: 健康检查探活
#   - procps: 进程管理 (pkill/ps)
RUN apt-get update     && apt-get install -y --no-install-recommends         ca-certificates         curl         procps     && rm -rf /var/lib/apt/lists/*

# 从 builder 复制纯净的已编译产物
COPY --from=builder /app-bin /usr/local/bin/app
RUN chmod +x /usr/local/bin/app

# 复制 HA rootfs (包含 S6 监督配置与 cont-init 脚本)
COPY rootfs /

# 修复执行权限
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

# 端口声明 (按需修改)
EXPOSE 8080/tcp

# Healthcheck 探活
HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3     CMD curl -sfo /dev/null http://127.0.0.1:8080/ || exit 1
