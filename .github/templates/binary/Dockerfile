#=============================================================================
# ADDON_SLUG HA Addon - 预编译二进制下载型
#=============================================================================
# 适用场景: 上游提供 GitHub Release 预编译二进制 (如 Lucky, CLIProxyAPI, WorkBuddy2API)
# 架构特性: debian-base 底包 + S6 overlay 进程管理 + 多架构自动适配
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

ARG TARGETARCH
ARG APP_VERSION
RUN test -n "${APP_VERSION}" || { echo "APP_VERSION is required"; exit 1; }

# 安装基础运行时依赖:
#   - ca-certificates: HTTPS 证书
#   - curl: 健康检查与重试下载
#   - procps: 进程管理 (pkill/ps)
RUN apt-get update     && apt-get install -y --no-install-recommends         ca-certificates         curl         procps     && rm -rf /var/lib/apt/lists/*

# ---- 多架构二进制下载 ----
RUN ARCH=$(case "${TARGETARCH}" in         amd64) echo "amd64" ;;         arm64) echo "arm64" ;;         armhf) echo "armv7" ;;         *) echo "${TARGETARCH}" ;;     esac)     && DOWNLOAD_URL="https://github.com/owner/repo/releases/download/v${APP_VERSION}/app-v${APP_VERSION}-linux-${ARCH}.tar.gz"     && echo "Downloading from: ${DOWNLOAD_URL}"     && curl -fsSL --retry 3 --retry-delay 3 --retry-all-errors "${DOWNLOAD_URL}" -o /tmp/app.tar.gz     && tar -xzf /tmp/app.tar.gz -C /tmp/     && mv /tmp/app /usr/local/bin/app     && chmod +x /usr/local/bin/app     && rm -rf /tmp/*

# 复制 HA rootfs (包含 S6 监督配置与 cont-init 脚本)
COPY rootfs /

# 修复 Windows 检出时丢失的 Unix 执行权限
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

# 端口声明 (按需修改)
EXPOSE 8080/tcp

# Healthcheck 探活 (默认以 HTTP 为例，按需调整端口和路径)
HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3     CMD curl -sfo /dev/null http://127.0.0.1:8080/ || exit 1
