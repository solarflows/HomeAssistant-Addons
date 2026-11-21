# syntax=docker/dockerfile:1
# ==============================================================================
# alist-tvbox-standalone HA Addon - 无 AList 内核版 (多阶段源码构建)
# Stage 1: 克隆上游源码并应用统一补丁
# Stage 2: 从 release JAR 提取 Spring Boot 依赖层
# Stage 3: HA debian-base:9.3.0 运行时 + S6 Overlay v3 守护
# ==============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ==============================================================================
# [Stage 1/3] Upstream Source Fetch & Hot Patching (源码检出与补丁)
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
# [Stage 2/3] Extract Spring Boot Application Layers (JAR 依赖分层提取)
# ==============================================================================
FROM eclipse-temurin:21-jre AS app-builder

ARG ALIST_TVBOX_VERSION

ADD https://github.com/power721/alist-tvbox/releases/download/${ALIST_TVBOX_VERSION}/alist-tvbox-1.0.jar /tmp/app.jar
RUN java -Djarmode=tools -jar /tmp/app.jar extract --layers --launcher --destination /extracted 2>/dev/null \
 || java -Djarmode=layertools -jar /tmp/app.jar extract --destination /extracted

# ==============================================================================
# [Stage 3/3] Runtime Environment (生产运行环境)
# ==============================================================================
FROM ${BUILD_FROM}

LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

ARG TARGETARCH

# --- 3.1 System Packages & JRE ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openjdk-21-jre-headless \
        curl \
        wget \
        unzip \
        procps \
    && rm -rf /var/lib/apt/lists/*

# --- 3.2 Application Artifacts ---
COPY --from=app-builder /extracted/dependencies/ /opt/atv/dependencies/
COPY --from=app-builder /extracted/snapshot-dependencies/ /opt/atv/snapshot-dependencies/
COPY --from=app-builder /extracted/spring-boot-loader/ /opt/atv/spring-boot-loader/
COPY --from=app-builder /extracted/application/ /opt/atv/application/

# 上游脚本与静态资源
COPY --from=source /src/alist-tvbox/docker/scripts/ /docker/scripts/
COPY --from=source /src/alist-tvbox/data/tvbox.zip /tvbox.zip
COPY --from=source /src/alist-tvbox/data/115.index.zip /115.index.zip
COPY --from=source /src/alist-tvbox/data/cat.zip /cat.zip
COPY --from=source /src/alist-tvbox/data/pg.zip /pg.zip
COPY --from=source /src/alist-tvbox/data/zx.zip /zx.zip
COPY --from=source /src/alist-tvbox/data/data.zip /data.zip
COPY --from=source /src/alist-tvbox/data/base_version /base_version
COPY --from=source /src/alist-tvbox/config/alist.json /alist.json

# --- 3.3 HA Rootfs & Permissions ---
COPY rootfs /
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/s6-rc.d/*/finish \
    && chmod +x /docker/scripts/*.sh

# --- 3.4 Network & Healthcheck ---
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-${TARGETARCH} \
    MEM_OPT="-Xmx512M" \
    ALIST_PORT=5244 \
    INSTALL=new
ENV PATH="${JAVA_HOME}/bin:${PATH}"

EXPOSE 4567/tcp

HEALTHCHECK --interval=30s --start-period=300s --timeout=10s --retries=5 \
    CMD curl -sfo /dev/null --noproxy '*' --max-time 5 "http://127.0.0.1:4567/" || exit 1

# S6 overlay 接管启动（启动脚本: rootfs/etc/s6-overlay/s6-rc.d/atv-standalone/run）
