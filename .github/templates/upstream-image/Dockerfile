#=============================================================================
# ADDON_SLUG HA Addon - 官方镜像包装型
#=============================================================================
# 适用场景: 上游提供高度优化的官方 Docker 镜像 (如 FlareSolverr, MCPHub, Trawl)
# 架构特性: 直接继承上游父镜像 + 注入 HA 适配层 (无需 S6 overlay)
#=============================================================================

ARG UPSTREAM_VERSION=latest
FROM owner/repo:${UPSTREAM_VERSION}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

USER root

# 安装基础适配工具:
#   - dumb-init: 规范接管 PID 1，优雅回收孤儿进程与转发信号
#   - curl: 容器探活健康检查
#   - jq: 解析 /data/options.json 动态注入环境变量 (如需要)
RUN if command -v apt-get >/dev/null 2>&1; then         apt-get update && apt-get install -y --no-install-recommends dumb-init curl jq         && rm -rf /var/lib/apt/lists/*;     elif command -v apk >/dev/null 2>&1; then         apk add --no-cache dumb-init curl jq;     fi

# 复制 HA 适配层
COPY rootfs /
RUN chmod +x /ha-entrypoint.sh

# 覆盖 ENTRYPOINT 接管初始化 (Docker 规则: 设置 ENTRYPOINT 会清空继承的 CMD，必须显式补全 CMD)
ENTRYPOINT ["/ha-entrypoint.sh"]
CMD ["app", "--config", "/config/ADDON_SLUG/config.yaml"]

# 端口声明 (按需修改)
EXPOSE 8080/tcp

# Healthcheck 探活
HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3     CMD curl -sfo /dev/null http://127.0.0.1:8080/ || exit 1
