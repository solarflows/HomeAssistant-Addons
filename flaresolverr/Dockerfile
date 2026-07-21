#=============================================================================
# FlareSolverr HA Addon - 引用上游镜像 + HA 适配层
#=============================================================================
# 参考: https://github.com/alexbelgium/hassio-addons/tree/master/flaresolverr
#=============================================================================

FROM flaresolverr/flaresolverr:latest

USER root

# 复制 HA rootfs
COPY rootfs /

# 确保脚本可执行
RUN find /rootfs -type f \( -name "*.sh" -o -name "run" -o -name "finish" \) -exec chmod +x {} \; 2>/dev/null || true

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
