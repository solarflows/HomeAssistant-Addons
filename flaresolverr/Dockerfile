#=============================================================================
# FlareSolverr HA Addon - 引用上游镜像 + HA 适配层
#=============================================================================
# 参考: https://github.com/alexbelgium/hassio-addons/tree/master/flaresolverr
#=============================================================================

ARG UPSTREAM_TAG=latest
FROM flaresolverr/flaresolverr:${UPSTREAM_TAG}

USER root

# 安装运行时依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        dumb-init \
    && rm -rf /var/lib/apt/lists/*

# 复制 HA rootfs
COPY rootfs /
RUN chmod +x /entrypoint.sh

# 环境变量
ENV TZ=UTC \
    LOG_LEVEL=info

# 端口
EXPOSE 8191/tcp 8192/tcp

# 持久化目录（/config 由 HAOS Supervisor 自动挂载，/data 用于上游容器标准卷）
VOLUME ["/data"]

# 使用定制入口脚本（Chromium 兼容修复 + dumb-init）
ENTRYPOINT ["/entrypoint.sh"]

# Healthcheck (参考 alexbelgium)
HEALTHCHECK --interval=30s --start-period=30s --timeout=25s --retries=5 \
    CMD curl -A "HealthCheck: Docker/1.0" -s -f "http://127.0.0.1:8191/" || exit 1
