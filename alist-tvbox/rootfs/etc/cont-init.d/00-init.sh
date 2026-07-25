#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox 初始化脚本
# ==============================================================================
# /config、/data 由 HAOS Supervisor 自动挂载（/data 持久但不在备份中）
# /config → 用户可见配置；/data → 数据库等内部状态

bashio::log.info "Initializing alist-tvbox..."

# 创建持久化目录
mkdir -p /config/atv/config
mkdir -p /data/atv/config
mkdir -p /data/log

# Alist 内核数据 → /data/alist（HAOS 持久化）
mkdir -p /data/alist
rm -rf /opt/alist/data
ln -sf /data/alist /opt/alist/data

# 上游 inDocker 检测需要 /entrypoint.sh 存在
# 否则 Spring Boot 会用 /opt/atv/alist/ 路径（找不到 config.json）
[ -f /entrypoint.sh ] || ln -sf /docker/scripts/entrypoint.sh /entrypoint.sh

# Spring Boot atv 数据直接写入 /data/store
mkdir -p /data/store

# ---- 读取 HA addon 配置选项并导出为环境变量 ----
LOW_MEMORY=$(bashio::config 'LOW_MEMORY' 'true')
if [ "${LOW_MEMORY}" = "true" ]; then
    export MEM_OPT="-Xmx512M"
else
    export MEM_OPT="-Xmx1024M"
fi
bashio::log.info "alist-tvbox JVM memory: ${MEM_OPT}"

# 调用上游初始化脚本（下载资源、配置 AList 等）
bashio::log.info "Running upstream initialization..."
export INSTALL=xiaoya
/docker/scripts/init-xiaoya.sh 2>&1 | tee /data/log/init.log || true

# 确保 AList config.json 存在（init-xiaoya.sh 不创建此文件，但 Spring Boot 启动需要）
# 必须在 init 之后，否则 init 脚本检测到 config.json 会跳过数据库建表
if [ ! -f /opt/alist/data/config.json ] && [ -f /alist.json ]; then
    bashio::log.info "Creating AList config.json from template..."
    cp /alist.json /opt/alist/data/config.json
    sed -i 's/127.0.0.1/0.0.0.0/' /opt/alist/data/config.json
fi

bashio::log.info "alist-tvbox initialization completed"
