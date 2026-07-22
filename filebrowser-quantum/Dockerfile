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

# 入口包装脚本（处理时区 + 配置 + 启动）
RUN printf '#!/bin/bash\nset -e\n\n# Timezone\nif [ -n "$TZ" ] && [ -f "/usr/share/zoneinfo/$TZ" ]; then\n    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime\n    echo "$TZ" > /etc/timezone\nfi\n\n# Ensure config dirs\nmkdir -p /config/filebrowser-quantum /cache\n\n# Locate filebrowser binary\nFB=$(command -v filebrowser 2>/dev/null || find / -name filebrowser -type f -executable 2>/dev/null | head -1)\nif [ -z "$FB" ]; then\n    echo "ERROR: filebrowser binary not found" >&2\n    exit 1\nfi\n\nexec "$FB" --config /config/filebrowser-quantum/config.yaml\n' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

# 环境变量
ENV TZ=Asia/Shanghai

# 端口（上游默认 8080）
EXPOSE 8080/tcp

# 持久化目录
# 持久化目录（/config、/share 由 HAOS Supervisor 自动挂载，/data 用于上游容器标准卷）
VOLUME ["/data"]

# Healthcheck
HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:8080/health || exit 1

# 使用入口包装脚本
ENTRYPOINT ["/entrypoint.sh"]