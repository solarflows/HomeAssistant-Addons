#=============================================================================
# QD-Today HA Addon - 多阶段源码构建
#=============================================================================
# 多阶段构建：
#   Stage 1: Python builder 安装依赖
#   Stage 2: HA 底包运行时
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Python builder ----
FROM python:3.11-slim-bookworm AS builder

WORKDIR /build

# 安装编译依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libcurl4-openssl-dev \
        libssl-dev \
        git \
    && rm -rf /var/lib/apt/lists/*

# 克隆源码
ARG QD_VERSION
RUN test -n "${QD_VERSION}" || { echo "QD_VERSION is required"; exit 1; }
RUN git clone --depth 1 --branch "${QD_VERSION}" https://github.com/qd-today/qd.git /src \
    || { echo "Failed to clone qd-today @ ${QD_VERSION}"; exit 1; }

# 安装 Python 依赖
WORKDIR /src
RUN pip install --no-cache-dir --prefix=/install \
    pycurl \
    && pip install --no-cache-dir --prefix=/install \
    -r requirements.txt \
    || pip install --no-cache-dir --prefix=/install \
    tornado requests pycryptodome pillow

# ---- Stage 2: HA 运行时 ----
FROM ${BUILD_FROM}

# 安装运行时依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        libcurl4 \
        libssl3 \
        curl \
        git \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

# 复制 Python 依赖
COPY --from=builder /install /usr/local

# 复制源码
COPY --from=builder /src /usr/src/app
WORKDIR /usr/src/app

# 复制 HA rootfs
COPY rootfs /

# 修复 Windows 平台丢失的执行权限 (Git 不保留 Unix 权限位)
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run

# 环境变量
ENV PORT=8923

# 端口
EXPOSE 8923/tcp

# 持久化目录（/config 由 HAOS Supervisor 自动挂载，/usr/src/app/config 经 init 脚本 symlink）

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:8923/ || exit 1

# S6 overlay 接管启动，不再依赖 Docker CMD
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/qdtoday/run
