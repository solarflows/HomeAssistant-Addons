#=============================================================================
# QD-Today HA Addon - 多阶段源码构建
#=============================================================================
# 多阶段构建（编译与运行严格分离）：
#   Stage 1 (builder): 全量编译工具链 → pip 安装所有依赖，失败即终止
#   Stage 2 (runtime): 仅运行时库 → 拷贝预编译产物，零编译
#=============================================================================

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.3.0

# ---- Stage 1: 编译阶段 (python:3.13-slim-bookworm, 全量构建工具链) ----
# 与运行时 debian-base:9.3.0 (Python 3.13) 版本对齐，避免 site-packages 路径差异
FROM python:3.13-slim-bookworm AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libcurl4-openssl-dev \
        libssl-dev \
        libffi-dev \
        cargo \
        rustc \
        git \
    && rm -rf /var/lib/apt/lists/*

# 克隆源码（构建参数由 CI 注入）
ARG QD_VERSION
RUN test -n "${QD_VERSION}" || { echo "QD_VERSION is required"; exit 1; }
RUN git clone --depth 1 --branch "${QD_VERSION}" https://github.com/qd-today/qd.git /src \
    || { echo "Failed to clone qd-today @ ${QD_VERSION}"; exit 1; }

# Patch: Python 3.12+ 将 and/or/not 条件跳转合并为 TO_BOOL opcode
# 上游 _SAFE_OPCODES 未收录 → 条件表达式触发 forbidden opcode
RUN python3 <<'PYEOF'
import sys
src = '/src/libs/safe_eval.py'
with open(src) as f:
    c = f.read()
old = "'FORMAT_VALUE', 'BUILD_STRING'"
new = "'FORMAT_VALUE', 'BUILD_STRING', 'TO_BOOL'"
if old not in c:
    print(f"ERROR: target string not found in {src}", file=sys.stderr)
    sys.exit(1)
c = c.replace(old, new)
with open(src, 'w') as f:
    f.write(c)
print('patched:', src)
PYEOF

# 全量安装 Python 依赖（编译失败即终止，不做降级）
WORKDIR /src
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# 上游注释掉的完整版依赖：ddddocr (OCR 验证码)
RUN pip install --no-cache-dir --prefix=/install --compile ddddocr

# ---- Stage 2: 运行时阶段 (HA debian-base, ja3 自编译) ----
# 参考: https://github.com/qd-today/pycurl-docker/blob/main/Dockerfile.ja3
FROM ${BUILD_FROM}

# 签名
LABEL org.opencontainers.image.authors="solarflows"
LABEL org.opencontainers.image.source="https://github.com/solarflows/HomeAssistant-Addons"

# 拷贝预编译包 + 桥接 Debian dist-packages ← python 官方 site-packages
COPY --from=builder /install /usr/local

ENV PYCURL_SSL_LIBRARY=openssl
ENV CURL_VERSION=8.1.1
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true
RUN SRC=$(ls -d /usr/local/lib/python3.*/site-packages 2>/dev/null | head -1) && \
    DST_DIR=$(dirname "$SRC") && DST="$DST_DIR/dist-packages" && \
    if [ -n "$SRC" ] && [ ! -L "$DST" ]; then \
        rm -rf "$DST" && ln -s site-packages "$DST"; \
        echo "Bridge: $SRC → $DST"; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 python3-pip python-is-python3 python3-dev \
        curl git openssh-client wget file patch ca-certificates \
        build-essential cmake perl autoconf g++ automake \
        linux-libc-dev libtool util-linux \
        libidn2-0 libidn2-dev libgsasl18 libgsasl-dev \
        zlib1g zlib1g-dev zstd libzstd-dev \
        libnghttp2-14 libnghttp2-dev libbrotli1 libbrotli-dev \
        libpsl5 libpsl-dev libc-ares2 libc-ares-dev libkrb5-dev \
        python3-setuptools python3-wheel golang-go \
    && echo "=== Installing Rust ===" \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup.sh \
    && sh /tmp/rustup.sh -y --default-toolchain stable --profile minimal \
    && . "$HOME/.cargo/env" \
    && echo "=== Downloading curl ${CURL_VERSION} ===" \
    && cd /tmp \
    && wget -q "https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.bz2" \
    && tar xjf "curl-${CURL_VERSION}.tar.bz2" \
    && rm "curl-${CURL_VERSION}.tar.bz2" \
    && echo "=== Building boringssl via quiche ===" \
    && cd / \
    && git clone --recursive https://github.com/cloudflare/quiche \
    && cd /quiche && git submodule update --init \
    && cd /quiche/quiche/deps/boringssl && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=on .. \
    && make -j$(nproc) \
    && cd /quiche/quiche && mkdir -p deps/boringssl/src/lib \
    && ln -vnf $(find -name libcrypto.a -o -name libssl.a) deps/boringssl/src/lib/ \
    && echo "=== Building quiche (Rust) ===" \
    && git config --global http.postBuffer 524288000 \
    && git config --global http.sslVerify false \
    && cargo build --verbose --package quiche --release --features ffi,pkg-config-meta,qlog \
    && echo "=== Patching curl with curl-impersonate ===" \
    && cd "/tmp/curl-${CURL_VERSION}" \
    && wget -q "https://cdn.jsdelivr.net/gh/lwthiker/curl-impersonate@main/chrome/patches/curl-impersonate.patch" \
    && wget -q "https://cdn.jsdelivr.net/gh/curl/curl@master/lib/easy_lock.h" -O lib/easy_lock.h \
    && for p in $(ls curl-*.patch 2>/dev/null); do patch -p1 < "$p"; done \
    && autoreconf -fi \
    && LDFLAGS="-Wl,-rpath,/usr/lib,-rpath,/quiche/target/release" ./configure \
        --with-openssl=/quiche/quiche/deps/boringssl/src \
        --with-nghttp2=/usr \
        --without-ngtcp2 \
        --with-brotli \
        --prefix=/usr \
        --enable-ipv6 \
        --enable-unix-sockets \
        --with-libidn2 \
        --disable-static \
        --disable-ldap \
        --with-pic \
        --with-gssapi \
        --enable-ares \
        USE_CURL_SSLKEYLOGFILE=true \
    && make -j$(nproc) \
    && make install \
    && ln -fs /usr/bin/curl-impersonate-chrome /usr/bin/curl \
    && ln -fs /usr/bin/curl-impersonate-chrome-config /usr/bin/curl-config \
    && echo "=== Installing pycurl-ja3 ===" \
    && cd /tmp \
    && git clone https://github.com/a76yyyy/pycurl-ja3.git \
    && cd pycurl-ja3 \
    && python3 setup.py install --openssl-dir=/quiche/quiche/deps/boringssl/src \
    && echo "=== Cleaning build deps ===" \
    && cd / && rm -rf /tmp/* /quiche /root/.cargo /root/.rustup \
    && apt-get remove -y \
        python3-dev libidn2-dev libgsasl-dev libnghttp2-dev \
        libbrotli-dev zlib1g-dev libpsl-dev libzstd-dev libkrb5-dev libc-ares-dev \
        python3-setuptools python3-wheel \
        build-essential cmake perl autoconf g++ automake \
        linux-libc-dev libtool util-linux wget file patch git golang-go \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# 拷贝源码
COPY --from=builder /src /usr/src/app
WORKDIR /usr/src/app

# 复制 HA rootfs
COPY rootfs /

# 修复 Windows 平台丢失的执行权限 (Git 不保留 Unix 权限位)
RUN chmod a+x /etc/cont-init.d/*.sh /etc/s6-overlay/s6-rc.d/*/run /etc/s6-overlay/scripts/stage2_hook.sh

ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh
ENV PORT=8923
EXPOSE 8923/tcp

HEALTHCHECK --interval=30s --start-period=30s --timeout=5s --retries=3 \
    CMD curl -sf http://127.0.0.1:8923/ || exit 1

# S6 overlay 接管启动，不再依赖 Docker CMD
# 启动脚本见 rootfs/etc/s6-overlay/s6-rc.d/qdtoday/run
