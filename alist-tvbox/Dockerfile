# syntax=docker/dockerfile:1
# ==============================================================================
# alist-tvbox HA Addon - 带 AList 内核版 (多阶段源码构建)
# Stage 1: 克隆上游源码并应用统一补丁
# Stage 2: 从 release JAR 提取 Spring Boot 依赖层
# Stage 3: 从 haroldli/alist 提取纯净 alist 内核与数据包
# Stage 4: 编译 atv-cli Go 工具
# Stage 5: HA debian-base:9.3.0 运行时 + S6 Overlay v3 守护与双轨探活
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/5] Upstream Source Fetch & Hot Patching (源码检出与补丁)
# ==============================================================================
FROM alpine/git:latest AS source

ARG ALIST_TVBOX_VERSION
RUN test -n "${ALIST_TVBOX_VERSION}" || { echo "ALIST_TVBOX_VERSION is required"; exit 1; }

RUN git clone --depth 1 --branch "${ALIST_TVBOX_VERSION}" \
       https://github.com/power721/alist-tvbox.git /src/alist-tvbox \
    || { echo "Failed to clone alist-tvbox @ ${ALIST_TVBOX_VERSION}"; exit 1; }

WORKDIR /src/alist-tvbox

# --- Apply Hot Patches ---
RUN --mount=type=bind,from=common,source=apply-patches.sh,target=/tmp/apply-patches.sh \
    --mount=type=bind,source=patches,target=/patches \
    sh /tmp/apply-patches.sh

# ==============================================================================
# [Stage 2/5] Extract Spring Boot Application Layers & Build Custom Micro-JRE
# ==============================================================================
FROM eclipse-temurin:21-jdk AS app-builder

ARG ALIST_TVBOX_VERSION

ADD https://github.com/power721/alist-tvbox/releases/download/${ALIST_TVBOX_VERSION}/alist-tvbox-1.0.jar /tmp/app.jar
RUN java -Djarmode=tools -jar /tmp/app.jar extract --layers --launcher --destination /extracted 2>/dev/null \
 || java -Djarmode=layertools -jar /tmp/app.jar extract --destination /extracted

# 自动化依赖分析与轻量定制 JRE 构建 (jdeps 静态扫描 + 核心安全/网络协议基石兜底)
RUN set -e; \
    echo "=== Running jdeps automatic dependency analysis ==="; \
    DETECTED_MODULES=$(jdeps \
        --multi-release 21 \
        --ignore-missing-deps \
        --print-module-deps \
        --class-path '/extracted/dependencies/BOOT-INF/lib/*:/extracted/snapshot-dependencies/BOOT-INF/lib/*' \
        --recursive \
        /extracted/application/BOOT-INF/classes 2>/dev/null || true); \
    echo "--- jdeps detected modules: ${DETECTED_MODULES} ---"; \
    SAFE_EXTRAS="jdk.crypto.ec,jdk.crypto.cryptoki,jdk.localedata,jdk.management,jdk.naming.dns,jdk.unsupported"; \
    if [ -n "${DETECTED_MODULES}" ]; then \
        MODULES="${DETECTED_MODULES},${SAFE_EXTRAS}"; \
    else \
        MODULES="java.base,java.compiler,java.desktop,java.instrument,java.management,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.security.jgss,java.sql,java.transaction.xa,java.xml,${SAFE_EXTRAS}"; \
    fi; \
    echo "--- Building custom JRE via jlink with modules: ${MODULES} ---"; \
    jlink \
        --add-modules "${MODULES}" \
        --strip-debug \
        --no-man-pages \
        --no-header-files \
        --compress=2 \
        --output /opt/jre

# ==============================================================================
# [Stage 3/5] Extract AList Binary & Base Data (AList 内核提取)
# ==============================================================================
# haroldli/alist 基于 PowerList，上游用 latest，CI 每次重建拉取最新
FROM haroldli/alist:latest AS alist-source

# ==============================================================================
# [Stage 4/5] Build atv-cli Go Tool (编译 CLI 管理工具)
# ==============================================================================
FROM golang:1.24 AS cli-builder
WORKDIR /app/
COPY --from=source /src/alist-tvbox/atv-cli/ ./
RUN go build -o /atv-cli

# ==============================================================================
# [Stage 5/5] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

ARG TARGETARCH

# --- 5.1 System Packages & Custom JRE ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nginx \
        curl \
        wget \
        unzip \
        busybox \
        sqlite3 \
        procps \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /bin/busybox /bin/busybox-extras \
    && rm -f /etc/nginx/sites-enabled/default \
    && (nginx -t && nginx -s stop 2>/dev/null || true)

# 复制 Stage 2 自动裁剪的 Micro-JRE 并桥接路径（兼容上游硬编码 /jre/bin/java）
COPY --from=app-builder /opt/jre /opt/jre
RUN mkdir -p /jre/bin \
    && ln -sf /opt/jre/bin/java /jre/bin/java \
    && ln -sf /opt/jre/bin/java /usr/local/bin/java \
    && curl -fsSL "https://repo1.maven.org/maven2/com/h2database/h2/2.1.214/h2-2.1.214.jar" -o /h2-2.1.214.jar

# --- 5.2 Application Artifacts & Binaries ---
COPY --from=alist-source /opt/alist/alist /opt/alist/alist
COPY --from=alist-source /var/lib/data.zip /var/lib/data.zip
COPY --from=cli-builder /atv-cli /atv-cli
RUN chmod +x /opt/alist/alist /atv-cli && mkdir -p /opt/alist/data

# Spring Boot 分层文件
COPY --from=app-builder /extracted/dependencies/ /opt/atv/dependencies/
COPY --from=app-builder /extracted/snapshot-dependencies/ /opt/atv/snapshot-dependencies/
COPY --from=app-builder /extracted/spring-boot-loader/ /opt/atv/spring-boot-loader/
COPY --from=app-builder /extracted/application/ /opt/atv/application/

RUN mkdir -p /opt/atv/BOOT-INF/lib \
    && find /opt/atv/snapshot-dependencies /opt/atv/dependencies \
           -name 'h2-*.jar' -exec ln -sf {} /opt/atv/BOOT-INF/lib/ \;

# 上游脚本与静态资源
COPY --from=source /src/alist-tvbox/docker/scripts/ /docker/scripts/
COPY --from=source /src/alist-tvbox/scripts/index.sh /index.sh
RUN chmod +x /index.sh && mkdir -p /data/index && ln -sf /data/index /index
COPY --from=source /src/alist-tvbox/data/update.sql /update.sql
COPY --from=source /src/alist-tvbox/data/tvbox.zip /
COPY --from=source /src/alist-tvbox/data/115.index.zip /
COPY --from=source /src/alist-tvbox/data/index.share.zip /
COPY --from=source /src/alist-tvbox/data/cat.zip /
COPY --from=source /src/alist-tvbox/data/pg.zip /
COPY --from=source /src/alist-tvbox/data/zx.zip /
COPY --from=source /src/alist-tvbox/data/data.zip /
COPY --from=source /src/alist-tvbox/data/nginx.full.conf /etc/nginx/sites-enabled/alist-tvbox.conf
COPY --from=source /src/alist-tvbox/data/base_version /
COPY --from=source /src/alist-tvbox/config/alist.json /alist.json

# 创建版本标记文件
ARG ALIST_TVBOX_VERSION
RUN echo "${ALIST_TVBOX_VERSION}" > /app_version \
    && echo "${ALIST_TVBOX_VERSION}" > /docker.version

# --- 5.3 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish \
    && chmod +x /docker/scripts/*.sh

# --- 5.4 Network & Healthcheck ---
ENV JAVA_HOME=/opt/jre \
    MEM_OPT="-Xmx512M" \
    ALIST_PORT=5344 \
    INSTALL=xiaoya
ENV PATH="${JAVA_HOME}/bin:${PATH}"

EXPOSE 4567/tcp 80/tcp
VOLUME ["/www/static"]

HEALTHCHECK --interval=30s --start-period=300s --timeout=10s --retries=5 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:4567/" \
     && curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:80/" || exit 1

# S6 overlay 接管启动（启动脚本: rootfs/etc/s6-overlay/s6-rc.d/alist-tvbox/run）
