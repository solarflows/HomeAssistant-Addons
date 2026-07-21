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

# 安装 HA 适配依赖（Alpine 包管理器）
RUN apk add --no-cache \
        curl \
        nginx \
        yq \
        bash

# 复制 HA rootfs
COPY rootfs /

# 确保脚本可执行
RUN find /rootfs -type f \( -name "*.sh" -o -name "run" -o -name "finish" \) -exec chmod +x {} \; 2>/dev/null || true

# 环境变量
ENV TZ=Asia/Shanghai

# 端口（上游默认 3001）
EXPOSE 3001/tcp

# 持久化目录
VOLUME ["/config", "/share"]

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:3001/health || exit 1