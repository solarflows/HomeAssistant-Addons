#=============================================================================
# Baihu Panel HA Addon - Go 多阶段编译
#=============================================================================
# 多阶段构建：
#   Stage 1: Go builder 编译二进制
#   Stage 2: HA 底包运行时
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Go builder ----
FROM --platform=$BUILDPLATFORM golang:1.26 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG BAIHU_VERSION
RUN test -n "${BAIHU_VERSION}" || { echo "BAIHU_VERSION is required"; exit 1; }

# 克隆源码
RUN git clone --depth 1 --branch "v${BAIHU_VERSION}" \
       https://github.com/engigu/baihu-panel.git /src \
    || { echo "Failed to clone baihu-panel @ v${BAIHU_VERSION}"; exit 1; }

WORKDIR /src

# 安装 Node.js 22（golang:1.22 内置 Node 18，Vite 需要 ≥20）
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# 构建前端（如果存在），确保产出目录不为空
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

# 构建后端
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags="-s -w" -o /baihu .

# ---- Stage 2: HA 运行时 ----
FROM ${BUILD_FROM}

# 安装运行时依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        wget \
        git \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 复制 Go 二进制
COPY --from=builder /baihu /usr/local/bin/baihu
RUN chmod +x /usr/local/bin/baihu

# 复制前端静态文件和配置（Stage 1 已确保目录非空）
COPY --from=builder /www/baihu /www/baihu
COPY --from=builder /app/configs /app/configs

# 创建数据目录
RUN mkdir -p /app/data /app/configs /app/envs

# 复制 HA rootfs
COPY rootfs /

# 修复 Windows 平台丢失的执行权限 (Git 不保留 Unix 权限位)
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run

# 环境变量
ENV BH_SERVER_PORT=8052 \
    BH_SERVER_HOST=0.0.0.0 \
    BH_DB_PATH=/config/baihu/data/baihu.db

# 端口
EXPOSE 8052/tcp

# 持久化目录（/config 由 HAOS Supervisor 自动挂载，子目录经 init 脚本 symlink）

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:8052/ || exit 1

# S6 overlay 接管启动，不再硬编码 ENTRYPOINT
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/baihu/run
