ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:stable
FROM ${BUILD_FROM}

# 其他配置保持不变...
# 下载并安装Lucky
ARG VERSION
ARG ARCH
RUN wget -q "https://github.com/gdy666/lucky/releases/download/${VERSION}/lucky_${VERSION}_Linux_${ARCH}.tar.gz" -O /tmp/lucky.tar.gz \
    && tar -xzf /tmp/lucky.tar.gz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/lucky

# 复制S6服务配置
COPY rootfs /
