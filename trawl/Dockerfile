#=============================================================================
# TRAWL HA Addon - 上游镜像 + HA 适配层
#=============================================================================
# 上游: https://github.com/germondai/trawl (AGPL-3.0，仅以未修改上游镜像方式运行)
# 镜像: ghcr.io/germondai/trawl（amd64/arm64；老 CPU 无 AVX2 时可改用 :baseline 变体）
# 说明: 单容器模式（无 Redis，内存会话缓存），对应上游 docker-compose.minimal.yml
#=============================================================================

ARG TRAWL_VERSION=latest
FROM ghcr.io/germondai/trawl:${TRAWL_VERSION}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# jq: 读取 /data/options.json 生成环境变量
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /
RUN chmod +x /ha-entrypoint.sh

# 单容器默认值（无 Redis）：
#   - SESSION_CACHE_DRIVER=memory（对应上游 minimal compose）
#   - 数据路径落在 HA /data（addon 隔离目录）
ENV SESSION_CACHE_DRIVER=memory \
    REDIS_URL="" \
    PORT=8191 \
    METRICS_DB_PATH=/data/trawl/metrics/trawl.sqlite \
    MITM_CA_DIR=/data/trawl/proxy-ca

# 覆盖 entrypoint（Docker 规则：设置 ENTRYPOINT 会清空继承的 CMD，必须重新声明）
ENTRYPOINT ["/ha-entrypoint.sh"]
CMD ["bun", "run", "apps/api/src/index.ts"]

EXPOSE 8191/tcp 8192/tcp

# Healthcheck（上游原生 /health；浏览器池预热较慢，放宽 start-period）
HEALTHCHECK --interval=30s --start-period=90s --timeout=10s --retries=5 \
    CMD curl -sfo /dev/null http://127.0.0.1:8191/health || exit 1