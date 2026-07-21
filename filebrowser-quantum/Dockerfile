#=============================================================================
# FileBrowser Quantum HA Addon - 引用上游镜像 + HA 适配层
#=============================================================================
# 参考: https://github.com/alexbelgium/hassio-addons/tree/master/filebrowser_quantum
# 上游: https://github.com/gtsteffaniak/filebrowser
# Docker: https://hub.docker.com/r/gtstef/filebrowser
#=============================================================================

ARG UPSTREAM_TAG=stable
FROM gtstef/filebrowser:${UPSTREAM_TAG}

USER root

# 安装 HA 适配依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        nginx \
        yq \
    && rm -rf /var/lib/apt/lists/*

# 复制 HA rootfs
COPY rootfs /

# 确保脚本可执行
RUN find /rootfs -type f \( -name "*.sh" -o -name "run" -o -name "finish" \) -exec chmod +x {} \; 2>/dev/null || true

# 环境变量
ENV TZ=Asia/Shanghai

# 端口
EXPOSE 8080/tcp

# 持久化目录
VOLUME ["/config", "/share"]

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:8080/health || exit 1

# 启动入口
ENTRYPOINT ["/ha_entrypoint.sh"]
