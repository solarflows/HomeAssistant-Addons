#=============================================================================
# alist-tvbox-standalone HA Addon - 无 AList 内核版
#=============================================================================
# 多阶段构建：
#   Stage 1: 克隆上游源码获取资源文件
#   Stage 2: 从 release JAR 提取 Spring Boot 层
#   Stage 3: HA 底包运行时（不含 alist 二进制）
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: 克隆上游源码获取资源文件 ----
FROM alpine/git:latest AS source

ARG ALIST_TVBOX_VERSION
RUN test -n "${ALIST_TVBOX_VERSION}" || { echo "ALIST_TVBOX_VERSION is required"; exit 1; }

RUN git clone --depth 1 --branch "${ALIST_TVBOX_VERSION}" \
       https://github.com/power721/alist-tvbox.git /src \
    || git clone --depth 1 https://github.com/power721/alist-tvbox.git /src

# ---- Stage 2: 提取 Spring Boot 应用层 ----
FROM eclipse-temurin:21-jre AS app-builder

ARG ALIST_TVBOX_VERSION

ADD https://github.com/power721/alist-tvbox/releases/download/${ALIST_TVBOX_VERSION}/alist-tvbox-1.0.jar /tmp/app.jar
RUN java -Djarmode=layertools -jar /tmp/app.jar extract --destination /extracted

# ---- Stage 3: HA 底包运行时 ----
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

# 复制 Spring Boot 应用层
COPY --from=app-builder /extracted/dependencies/ /opt/atv/dependencies/
COPY --from=app-builder /extracted/snapshot-dependencies/ /opt/atv/snapshot-dependencies/
COPY --from=app-builder /extracted/spring-boot-loader/ /opt/atv/spring-boot-loader/
COPY --from=app-builder /extracted/application/ /opt/atv/application/

# 从上游源码复制脚本和资源
COPY --from=source /src/docker/scripts/ /docker/scripts/
COPY --from=source /src/data/tvbox.zip /data/
COPY --from=source /src/data/115.index.zip /data/
COPY --from=source /src/data/cat.zip /data/
COPY --from=source /src/data/pg.zip /data/
COPY --from=source /src/data/zx.zip /data/
COPY --from=source /src/data/nginx.conf /etc/nginx/http.d/default.conf
COPY --from=source /src/data/base_version /data/
COPY --from=source /src/config/alist.json /alist.json

# 复制 HA rootfs
COPY rootfs /

# 确保脚本可执行
RUN find /rootfs -type f \( -name "*.sh" -o -name "run" -o -name "finish" \) -exec chmod +x {} \; 2>/dev/null || true \
    && chmod +x /docker/scripts/*.sh 2>/dev/null || true

# 环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-${TARGETARCH} \
    MEM_OPT="-Xmx512M" \
    ALIST_PORT=5344 \
    INSTALL=new \
    TZ=Asia/Shanghai
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# 端口
EXPOSE 4567/tcp 5244/tcp

# 持久化目录
VOLUME ["/config", "/data", "/www/static"]

# Healthcheck
HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:4567/ || exit 1

# 启动入口
WORKDIR /opt/atv/
ENTRYPOINT ["/docker/scripts/entrypoint.sh"]
CMD ["81", "--spring.profiles.active=production,docker"]