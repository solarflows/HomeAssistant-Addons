#=============================================================================
# Baihu Panel HA Addon - Go 多阶段编译
#=============================================================================
# 多阶段构建：
#   Stage 1: Go builder 编译二进制
#   Stage 2: HA 底包运行时
#=============================================================================

# ---- Stage 1: Go builder ----
FROM --platform=$BUILDPLATFORM golang:1.22 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG BAIHU_VERSION
RUN test -n "${BAIHU_VERSION}" || { echo "BAIHU_VERSION is required"; exit 1; }

# 克隆源码
RUN git clone --depth 1 --branch "v${BAIHU_VERSION}" \
       https://github.com/engigu/baihu-panel.git /src \
    || git clone --depth 1 https://github.com/engigu/baihu-panel.git /src

WORKDIR /src

# 构建前端（如果存在）
RUN if [ -d "web" ] && [ -f "web/package.json" ]; then \
        cd web && npm ci && npm run build && cd ..; \
    fi

# 构建后端
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags="-s -w" -o /baihu .

# ---- Stage 2: HA 运行时 ----
ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0
FROM ${BUILD_FROM}

# 安装运行时依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        wget \
        git \
        ca-certificates \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

# 复制 Go 二进制
COPY --from=builder /baihu /usr/local/bin/baihu
RUN chmod +x /usr/local/bin/baihu

# 复制前端静态文件（如果存在）
COPY --from=builder /src/web/dist /www/baihu 2>/dev/null || true
COPY --from=builder /src/configs /app/configs 2>/dev/null || true

# 创建数据目录
RUN mkdir -p /app/data /app/configs /app/envs

# 复制 HA rootfs
COPY rootfs /

# 环境变量
ENV BH_SERVER_PORT=8052 \
    BH_SERVER_HOST=0.0.0.0 \
    BH_DB_PATH=/app/data/baihu.db \
    TZ=Asia/Shanghai

# 端口
EXPOSE 8052/tcp

# 持久化目录
VOLUME ["/config", "/app/data", "/app/configs", "/app/envs"]

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:8052/ || exit 1

# 启动入口
ENTRYPOINT ["/usr/local/bin/baihu"]
