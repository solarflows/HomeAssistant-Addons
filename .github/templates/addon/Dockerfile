#=============================================================================
# ADDON_SLUG HA Addon
#=============================================================================
# TODO: Choose build strategy (see SKILL.md → Build strategy selection)
# and replace this Dockerfile accordingly.
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: Build / Fetch sources ----
# TODO: Add build stages based on strategy

# ---- Stage 2: HA base runtime ----
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

ARG TARGETARCH

# 安装最小运行时依赖:
#   - ca-certificates: HTTPS 证书（访问外部 API 或下载必备）
#   - curl: 健康检查与轻量请求必备
#   - procps: 进程管理必备（pkill/ps），避免应用停机或子进程回收时崩溃
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        procps \
    && rm -rf /var/lib/apt/lists/*

# ---- 多架构二进制下载模板参考 (若使用 binary download 策略可参考解开) ----
# RUN ARCH=$(case "${TARGETARCH}" in \
#         amd64) echo "amd64" ;; \
#         arm64) echo "arm64" ;; \
#         armhf) echo "armv7" ;; \
#         *) echo "${TARGETARCH}" ;; \
#     esac) \
#     && DOWNLOAD_URL="https://github.com/owner/repo/releases/download/v${APP_VERSION}/app_linux_${ARCH}.tar.gz" \
#     && curl -fsSL --retry 3 --retry-delay 3 --retry-all-errors "${DOWNLOAD_URL}" -o /tmp/app.tar.gz \
#     && tar -xzf /tmp/app.tar.gz -C /usr/local/bin/ \
#     && chmod +x /usr/local/bin/app \
#     && rm -rf /tmp/*

# 复制 HA rootfs
COPY rootfs /

# 修复执行权限 (包括 stage2_hook.sh 与 Windows 检出权限丢失)
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

# S6 Stage 2 Hook 必需声明
ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

# Healthcheck 规范 (start-period 建议至少 60s 以上，重型应用如 Java/Node 建议 180s~300s)
# 模式 A (HTTP Web 服务):
HEALTHCHECK --interval=30s --start-period=60s --timeout=10s --retries=5 \
    CMD curl -sfo /dev/null http://127.0.0.1:<PORT>/ || exit 1
# 模式 B (TCP 纯代理/后端服务，无 HTTP):
#   CMD bash -c '</dev/tcp/127.0.0.1/<PORT>' || exit 1
# 模式 C (纯守护进程，无开放端口):
#   CMD pgrep -x <process_name> >/dev/null || exit 1
