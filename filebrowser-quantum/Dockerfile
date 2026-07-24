#=============================================================================
# FileBrowser Quantum HA Addon - debian-base + S6 overlay
#=============================================================================
# 上游: https://github.com/gtsteffaniak/filebrowser
# 参考: alexbelgium/hassio-addons/filebrowser_quantum
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

ARG TARGETARCH
ARG FILEBROWSER_VERSION
RUN test -n "${FILEBROWSER_VERSION}" || { echo "FILEBROWSER_VERSION is required"; exit 1; }

# 安装依赖 (curl=健康检查, yq=配置读写)
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# 架构映射
RUN ARCH=$(case "${TARGETARCH}" in \
        amd64) echo "amd64" ;; \
        arm64) echo "arm64" ;; \
        *) echo "${TARGETARCH}" ;; \
    esac) \
    && echo "Target arch: ${ARCH}" \
    \
    # 下载 filebrowser 二进制
    && FB_URL="https://github.com/gtsteffaniak/filebrowser/releases/download/v${FILEBROWSER_VERSION}/linux-${ARCH}-filebrowser" \
    && echo "Downloading filebrowser from: ${FB_URL}" \
    && curl -fsSL "${FB_URL}" -o /usr/local/bin/filebrowser \
    && chmod +x /usr/local/bin/filebrowser \
    \
    # 下载 yq (用于配置读写)
    && YQ_URL="https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_${ARCH}" \
    && echo "Downloading yq from: ${YQ_URL}" \
    && curl -fsSL "${YQ_URL}" -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# 复制 HA rootfs (S6 overlay)
COPY rootfs /

# 修复 Windows 平台丢失的执行权限 (Git 不保留 Unix 权限位)
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

# 端口
EXPOSE 8080/tcp

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:8080/health || exit 1