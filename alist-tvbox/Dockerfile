#=============================================================================
# alist-tvbox HA Addon - 带 AList 内核版
#=============================================================================
# 多阶段构建：
#   Stage 1: 从 release JAR 提取 Spring Boot 层
#   Stage 2: 从 haroldli/alist 提取干净的 alist 二进制
#   Stage 3: HA 底包运行时
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: 提取 Spring Boot 应用层 ----
FROM eclipse-temurin:21-jre AS app-builder

ARG ALIST_TVBOX_VERSION
RUN test -n "${ALIST_TVBOX_VERSION}" || { echo "ALIST_TVBOX_VERSION is required"; exit 1; }

ADD https://github.com/power721/alist-tvbox/releases/download/${ALIST_TVBOX_VERSION}/alist-tvbox-1.0.jar /tmp/app.jar
RUN java -Djarmode=layertools -jar /tmp/app.jar extract --destination /extracted

# ---- Stage 2: 提取 alist 二进制 ----
FROM haroldli/alist:latest AS alist-source

# ---- Stage 3: HA 运行时 ----
FROM ${BUILD_FROM}

ARG TARGETARCH

# 安装运行时依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openjdk-21-jre-headless \
        nginx \
        curl \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# 从 haroldli/alist 复制干净的 alist 二进制和配置
COPY --from=alist-source /opt/alist/alist /opt/alist/alist
COPY --from=alist-source /opt/alist/data/config.json /alist.json
RUN chmod +x /opt/alist/alist

# 复制 Spring Boot 应用层
COPY --from=app-builder /extracted/dependencies/ /opt/atv/dependencies/
COPY --from=app-builder /extracted/snapshot-dependencies/ /opt/atv/snapshot-dependencies/
COPY --from=app-builder /extracted/spring-boot-loader/ /opt/atv/spring-boot-loader/
COPY --from=app-builder /extracted/application/ /opt/atv/application/

# 复制脚本和资源
COPY docker/scripts/ /docker/scripts/
COPY data/tvbox.zip /data/
COPY data/115.index.zip /data/
COPY data/index.share.zip /data/
COPY data/cat.zip /data/
COPY data/pg.zip /data/
COPY data/zx.zip /data/
COPY data/data.zip /data/
COPY data/nginx.full.conf /etc/nginx/http.d/default.conf
COPY data/base_version /data/
COPY config/alist.json /alist.json

# 复制 HA rootfs
COPY rootfs /

# 环境变量
ENV MEM_OPT="-Xmx512M" \
    ALIST_PORT=5344 \
    INSTALL=xiaoya \
    JAVA_HOME=/usr/lib/jvm/java-21-openjdk-${TARGETARCH} \
    PATH="${JAVA_HOME}/bin:${PATH}" \
    TZ=Asia/Shanghai

# 端口
EXPOSE 4567/tcp 80/tcp

# 持久化目录
VOLUME ["/config", "/data", "/www/static"]

# Healthcheck
HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:4567/ || exit 1

# 启动入口
WORKDIR /opt/atv/
ENTRYPOINT ["/docker/scripts/entrypoint.sh"]
CMD ["81", "--spring.profiles.active=production,xiaoya"]
