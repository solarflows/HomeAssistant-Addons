#=============================================================================
# MCPHub HA Addon - 上游镜像 + HA 适配层
#=============================================================================
# 上游: https://github.com/samanhappy/mcphub (Apache-2.0)
# 镜像: samanhappy/mcphub (Docker Hub, amd64/arm64)
# 说明: 使用标准版镜像（含 Node/Python/uv/Git，覆盖大多数 MCP server）；
#       不使用 latest-full 变体（Rust/DinD/Playwright，体积 1.3GB+，本 addon 不需要）
#=============================================================================

ARG MCPHUB_VERSION=latest
FROM samanhappy/mcphub:${MCPHUB_VERSION}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

USER root

# dumb-init: 回收 stdio MCP server（npx/uvx 拉起）的子进程
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        dumb-init \
    && rm -rf /var/lib/apt/lists/*

# 复制 HA 适配层（options → env、数据/缓存目录接管）
COPY rootfs /
RUN chmod +x /ha-entrypoint.sh

# 覆盖 entrypoint（Docker 规则：设置 ENTRYPOINT 会清空继承的 CMD，必须重新声明）
ENTRYPOINT ["/ha-entrypoint.sh"]
CMD ["node", "dist/index.js"]

EXPOSE 3000/tcp

# Healthcheck（面板首页；MCP/API 端点默认需 Bearer，不用作探活）
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null http://127.0.0.1:3000/ || exit 1