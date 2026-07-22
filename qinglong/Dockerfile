#=============================================================================
# Qinglong HA Addon - 多阶段源码构建
#=============================================================================
# 多阶段构建：
#   Stage 1: Node.js builder 编译前端和后端
#   Stage 2: HA 底包运行时
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Node.js builder ----
FROM node:18-alpine AS builder

ARG QINGLONG_VERSION
RUN test -n "${QINGLONG_VERSION}" || { echo "QINGLONG_VERSION is required"; exit 1; }

# 安装 pnpm
RUN npm i -g pnpm@8.3.1

# 克隆源码
RUN apk add --no-cache git \
    && git clone --depth 1 --branch "v${QINGLONG_VERSION}" \
       https://github.com/whyour/qinglong.git /src \
    || git clone --depth 1 --branch "develop" \
       https://github.com/whyour/qinglong.git /src

WORKDIR /src

# 安装依赖并构建
RUN pnpm install --frozen-lockfile \
    && npm run build \
    || true

# ---- Stage 2: HA 运行时 ----
FROM ${BUILD_FROM}

# 安装运行时依赖
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
        tzdata \
    && npm i -g pnpm@8.3.1 \
    && rm -rf /var/lib/apt/lists/*

# 复制构建产物
COPY --from=builder /src /ql
WORKDIR /ql

# 安装生产依赖
RUN pnpm install --prod --frozen-lockfile 2>/dev/null || true

# 创建数据目录
RUN mkdir -p /ql/data

# 复制 HA rootfs
COPY rootfs /

# 环境变量
ENV QL_DIR=/ql \
    TZ=Asia/Shanghai \
    NODE_ENV=production

# 端口
EXPOSE 5700/tcp

# 持久化目录（/config、/ql/data 由 HAOS Supervisor + QL_DATA_DIR 接管）

# Healthcheck
HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:5700/api/health || exit 1

# S6 overlay 接管启动，不再硬编码 ENTRYPOINT
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/qinglong/run
