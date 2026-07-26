#=============================================================================
# alist-tvbox HA Addon - 带 AList 内核版
#=============================================================================
# 多阶段构建：
#   Stage 1: 克隆上游源码获取资源文件
#   Stage 2: 从 release JAR 提取 Spring Boot 层
#   Stage 3: 从 haroldli/alist 提取干净的 alist 二进制
#   Stage 4: HA 底包运行时
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: 克隆上游源码获取资源文件 ----
FROM alpine/git:latest AS source

ARG ALIST_TVBOX_VERSION
RUN test -n "${ALIST_TVBOX_VERSION}" || { echo "ALIST_TVBOX_VERSION is required"; exit 1; }

RUN git clone --depth 1 --branch "${ALIST_TVBOX_VERSION}" \
       https://github.com/power721/alist-tvbox.git /src \
    || { echo "Failed to clone alist-tvbox @ ${ALIST_TVBOX_VERSION}"; exit 1; }

# ---- Stage 2: 提取 Spring Boot 应用层 ----
FROM eclipse-temurin:21-jre AS app-builder

ARG ALIST_TVBOX_VERSION

ADD https://github.com/power721/alist-tvbox/releases/download/${ALIST_TVBOX_VERSION}/alist-tvbox-1.0.jar /tmp/app.jar
RUN java -Djarmode=layertools -jar /tmp/app.jar extract --destination /extracted

# ---- Stage 3: 提取 alist 二进制 ----
# haroldli/alist 基于 PowerList，上游用 latest，CI 每次重建拉取最新
FROM haroldli/alist:latest AS alist-source

# ---- Stage 3.5: 构建 atv-cli Go 工具 ----
FROM golang:1.24 AS cli-builder
WORKDIR /app/
COPY --from=source /src/atv-cli/ ./
RUN go build -o /atv-cli

# ---- Stage 4: HA 底包运行时 ----
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

ARG TARGETARCH

# 安装运行时依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openjdk-21-jre-headless \
        nginx \
        curl \
        wget \
        unzip \
        busybox \
        sqlite3 \
    && rm -rf /var/lib/apt/lists/* \
    # busybox-extras → busybox（上游 haroldli/alist-base 提供 busybox-extras，Debian 用 busybox 包）
    && ln -sf /bin/busybox /bin/busybox-extras \
    # 移除 nginx 默认配置，防止 postinst 自动绑定 80 端口
    # Debian nginx 读 /etc/nginx/sites-enabled/，不是 Alpine 的 /etc/nginx/http.d/
    && rm -f /etc/nginx/sites-enabled/default \
    && (nginx -t && nginx -s stop 2>/dev/null || true)

# 上游 init-xiaoya.sh 硬编码 /jre/bin/java 和 /h2-2.1.214.jar
# Debian 的 java 在 /usr/lib/jvm/ 下，创建兼容 symlink + 下载 H2 旧版 jar
RUN mkdir -p /jre/bin \
    && ln -sf /usr/lib/jvm/java-21-openjdk-${TARGETARCH}/bin/java /jre/bin/java \
    && curl -fsSL "https://repo1.maven.org/maven2/com/h2database/h2/2.1.214/h2-2.1.214.jar" -o /h2-2.1.214.jar

# 从 haroldli/alist 复制干净的 alist 二进制 + xiaoya 数据包
# config.json 是运行时生成的(VOLUME)，不预置于镜像中
COPY --from=alist-source /opt/alist/alist /opt/alist/alist
COPY --from=alist-source /var/lib/data.zip /var/lib/data.zip
COPY --from=cli-builder /atv-cli /atv-cli
RUN chmod +x /opt/alist/alist /atv-cli && mkdir -p /opt/alist/data

# 复制 Spring Boot 应用层（layertools 提取结构）
COPY --from=app-builder /extracted/dependencies/ /opt/atv/dependencies/
COPY --from=app-builder /extracted/snapshot-dependencies/ /opt/atv/snapshot-dependencies/
COPY --from=app-builder /extracted/spring-boot-loader/ /opt/atv/spring-boot-loader/
COPY --from=app-builder /extracted/application/ /opt/atv/application/

# 兼容上游 BOOT-INF 路径（database.sh restore_database 需要 /opt/atv/BOOT-INF/lib/h2-*.jar）
RUN mkdir -p /opt/atv/BOOT-INF/lib \
    && find /opt/atv/snapshot-dependencies /opt/atv/dependencies \
           -name 'h2-*.jar' -exec ln -sf {} /opt/atv/BOOT-INF/lib/ \;

# 从上游源码复制脚本和资源
# 上游 VOLUME 只有 /www/static，/data/ 不是卷，资源文件放在 /
# HAOS 把 /data/ 挂为持久卷，所以资源文件放 /（镜像内），不会被用户清空
COPY --from=source /src/docker/scripts/ /docker/scripts/
COPY --from=source /src/scripts/index.sh /index.sh
RUN chmod +x /index.sh
COPY --from=source /src/data/update.sql /update.sql
COPY --from=source /src/data/tvbox.zip /
COPY --from=source /src/data/115.index.zip /
COPY --from=source /src/data/index.share.zip /
COPY --from=source /src/data/cat.zip /
COPY --from=source /src/data/pg.zip /
COPY --from=source /src/data/zx.zip /
COPY --from=source /src/data/data.zip /
COPY --from=source /src/data/nginx.full.conf /etc/nginx/sites-enabled/alist-tvbox.conf
COPY --from=source /src/data/base_version /
COPY --from=source /src/config/alist.json /alist.json

# 创建版本文件（上游 init-xiaoya.sh 用 set -e，缺少会直接退出）
# /app_version: 上游 data/version（不在 git 中，用构建参数生成）
# /docker.version: 上游 haroldli/alist-base 提供（我们没有，同样用构建参数）
ARG ALIST_TVBOX_VERSION
RUN echo "${ALIST_TVBOX_VERSION}" > /app_version \
    && echo "${ALIST_TVBOX_VERSION}" > /docker.version

# 复制 HA rootfs
COPY rootfs /

# 确保脚本可执行
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh \
    && chmod +x /docker/scripts/*.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

# 环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-${TARGETARCH} \
    MEM_OPT="-Xmx512M" \
    ALIST_PORT=5344 \
    INSTALL=xiaoya
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# 端口
EXPOSE 4567/tcp 80/tcp

# 持久化目录（/config、/data 由 HAOS Supervisor 自动挂载）
VOLUME ["/www/static"]

# Healthcheck
HEALTHCHECK --interval=30s --start-period=60s --timeout=5s --retries=3 \
    CMD curl -sfo /dev/null http://127.0.0.1:4567/ || exit 1

# S6 overlay 接管启动，不再硬编码 ENTRYPOINT
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/alist-tvbox/run