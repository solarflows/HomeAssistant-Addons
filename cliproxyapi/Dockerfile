#=============================================================================
# CLIProxyAPI HA Addon - debian-base + 上游 release 二进制
#=============================================================================
# 上游: https://github.com/router-for-me/CLIProxyAPI (MIT)
# 管理面板: CPAMP 轻量版 single-file management.html
#   - 构建时下载固定版本种子文件（离线首启可用）
#   - 运行时由 CPA 的 panel-github-repository 机制自动更新
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

ARG TARGETARCH
ARG CPA_VERSION
ARG PANEL_VERSION
RUN test -n "${CPA_VERSION}" || { echo "CPA_VERSION is required"; exit 1; }
RUN test -n "${PANEL_VERSION}" || { echo "PANEL_VERSION is required"; exit 1; }

# 运行时依赖: curl(健康检查/下载)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 下载 CPA 二进制（默认 Linux 构建：支持动态插件，GLIBC 2.17 基线）
# + CPAMP 管理面板种子文件（断网首启可用）
RUN ARCH=$(case "${TARGETARCH}" in \
        amd64) echo "amd64" ;; \
        arm64) echo "aarch64" ;; \
        *) echo "${TARGETARCH}" ;; \
    esac) \
    && mkdir -p /CLIProxyAPI /opt/cliproxyapi-seed \
    && CPA_URL="https://github.com/router-for-me/CLIProxyAPI/releases/download/v${CPA_VERSION}/CLIProxyAPI_${CPA_VERSION}_linux_${ARCH}.tar.gz" \
    && echo "Downloading CLIProxyAPI from: ${CPA_URL}" \
    && curl -fsSL --retry 3 --retry-delay 3 --retry-all-errors "${CPA_URL}" -o /tmp/cpa.tar.gz \
    && tar -xzf /tmp/cpa.tar.gz -C /CLIProxyAPI \
    && chmod +x /CLIProxyAPI/cli-proxy-api \
    && PANEL_URL="https://github.com/seakee/CPA-Manager-Plus/releases/download/v${PANEL_VERSION}/management.html" \
    && echo "Downloading CPAMP panel from: ${PANEL_URL}" \
    && curl -fsSL --retry 3 --retry-delay 3 --retry-all-errors "${PANEL_URL}" -o /opt/cliproxyapi-seed/management.html \
    && rm -rf /tmp/*

# 复制 HA rootfs (S6 overlay)
COPY rootfs /

# 修复 Windows 平台丢失的执行权限 (Git 不保留 Unix 权限位)
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh
# WRITABLE_PATH: CPA 运行时可写目录统一基准（上游 util.WritablePath()）
#   → logs（启用 logging-to-file 时）、static 面板缓存、discovery 状态均落到 /data
ENV WRITABLE_PATH=/data/cliproxyapi
# 管理面板缓存目录（持久化到 /data，跨 addon 更新保留）
ENV MANAGEMENT_STATIC_PATH=/data/cliproxyapi/static

# 端口
EXPOSE 8317/tcp

# Healthcheck（上游原生 /healthz 端点）
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null http://127.0.0.1:8317/healthz || exit 1

# S6 overlay 接管启动
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/cliproxyapi/run