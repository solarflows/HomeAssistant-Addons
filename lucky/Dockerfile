#=============================================================================
# Lucky HA Addon - 闭源二进制
#=============================================================================
# 优先从 release.66666.host 下载完整版本，回退到 GitHub release
# 使用 -c 指定配置文件，需要 host 网络模式
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0
FROM ${BUILD_FROM}

ARG TARGETARCH
ARG LUCKY_VERSION
RUN test -n "${LUCKY_VERSION}" || { echo "LUCKY_VERSION is required"; exit 1; }

# 安装依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        wget \
    && rm -rf /var/lib/apt/lists/*

# 下载 Lucky 二进制
# 优先从 release.66666.host 下载完整版本（wanji_docker）
# 回退到 GitHub release
RUN ARCH_PRIMARY=$(case "${TARGETARCH}" in \
        amd64) echo "amd64" ;; \
        arm64) echo "arm64" ;; \
        armhf) echo "armv7" ;; \
        *) echo "${TARGETARCH}" ;; \
    esac) \
    && ARCH_GITHUB=$(case "${TARGETARCH}" in \
        amd64) echo "x86_64" ;; \
        arm64) echo "arm64" ;; \
        armhf) echo "armv7" ;; \
        *) echo "${TARGETARCH}" ;; \
    esac) \
    && DOWNLOAD_URL="https://release.66666.host/v${LUCKY_VERSION}/${LUCKY_VERSION}_wanji_docker/lucky_${LUCKY_VERSION}_Linux_${ARCH_PRIMARY}_wanji_docker.tar.gz" \
    && echo "Trying download from: $DOWNLOAD_URL" \
    && wget -q "$DOWNLOAD_URL" -O /tmp/lucky.tar.gz \
    || { \
        echo "Primary download failed, falling back to GitHub release"; \
        GITHUB_URL="https://github.com/gdy666/lucky/releases/download/v${LUCKY_VERSION}/lucky_${LUCKY_VERSION}_Linux_${ARCH_GITHUB}.tar.gz"; \
        wget -q "$GITHUB_URL" -O /tmp/lucky.tar.gz; \
    } \
    && tar -xzf /tmp/lucky.tar.gz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/lucky \
    && rm -rf /tmp/*

# 创建配置目录
RUN mkdir -p /etc/lucky

# 复制 HA rootfs
COPY rootfs /

# 环境变量
ENV TZ=Asia/Shanghai

# 端口（host 模式下这些端口会直接映射到宿主机）
EXPOSE 16601/tcp

# 持久化目录
VOLUME ["/config"]

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:16601/ || exit 1

# S6 overlay 接管启动，不再硬编码 ENTRYPOINT
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/lucky/run
