#=============================================================================
# workbuddy2api-panel HA Addon - debian-base + 上游 release 二进制
#=============================================================================
# 上游: https://github.com/linguo2625469/workbuddy2api-panel (MIT)
# ⚠️ 非官方网关（腾讯 CodeBuddy/WorkBuddy 逆向协议）。请仅用于本人授权账号，
#    自行评估账号封禁与服务条款风险；仓库已删除过一次上游，维护状态见上游 README。
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

ARG TARGETARCH
ARG WB2API_VERSION
RUN test -n "${WB2API_VERSION}" || { echo "WB2API_VERSION is required"; exit 1; }

# 运行时依赖: curl(健康检查/下载) + tzdata(定时任务本地时区)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        tzdata \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 下载上游 release 二进制包（含 wb2api + config.example.json + README）
RUN ARCH=$(case "${TARGETARCH}" in \
        amd64) echo "amd64" ;; \
        arm64) echo "arm64" ;; \
        *) echo "${TARGETARCH}" ;; \
    esac) \
    && mkdir -p /opt/wb2api \
    && URL="https://github.com/linguo2625469/workbuddy2api-panel/releases/download/v${WB2API_VERSION}/wb2api-panel-v${WB2API_VERSION}-linux-${ARCH}.tar.gz" \
    && echo "Downloading wb2api from: ${URL}" \
    && curl -fsSL --retry 3 --retry-delay 3 --retry-all-errors "${URL}" -o /tmp/wb2api.tar.gz \
    && tar -xzf /tmp/wb2api.tar.gz -C /opt/wb2api \
    && mv /opt/wb2api/wb2api /usr/local/bin/wb2api \
    && chmod +x /usr/local/bin/wb2api \
    && rm -rf /tmp/*

# 复制 HA rootfs (S6 overlay)
COPY rootfs /

# 修复 Windows 平台丢失的执行权限 (Git 不保留 Unix 权限位)
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

EXPOSE 7863/tcp

# Healthcheck（面板页面；/healthz 在无可用账号时返回 503，不适合直接探活）
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null http://127.0.0.1:7863/panel/ || exit 1

# S6 overlay 接管启动
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/workbuddy2api-panel/run