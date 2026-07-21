#=============================================================================
# FlareSolverr HA Addon - 引用上游镜像 + HA 适配层
#=============================================================================
# 参考: https://github.com/alexbelgium/hassio-addons/tree/master/flaresolverr
#=============================================================================

ARG UPSTREAM_TAG=latest
FROM flaresolverr/flaresolverr:${UPSTREAM_TAG}

USER root

# 复制 HA rootfs
COPY rootfs /

# 环境变量
ENV TZ=UTC \
    LOG_LEVEL=info

# 端口
EXPOSE 8191/tcp 8192/tcp

# 持久化目录
VOLUME ["/config"]

# Healthcheck (参考 alexbelgium)
HEALTHCHECK --interval=30s --start-period=30s --timeout=25s --retries=5 \
    CMD curl -A "HealthCheck: Docker/1.0" -s -f "http://127.0.0.1:8191/" || exit 1
