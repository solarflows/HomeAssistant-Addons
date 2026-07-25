#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox-standalone 初始化脚本
# ==============================================================================
# /config、/data 由 HAOS Supervisor 自动挂载（/data 持久但不在备份中）

bashio::log.info "Initializing alist-tvbox-standalone..."

# 创建持久化目录
mkdir -p /config/atv/config
mkdir -p /data/log

# Spring Boot atv 数据直接写入 /data/store
mkdir -p /data/store

# ---- 读取 HA addon 配置选项并导出为环境变量 ----
export MEM_OPT=$(bashio::config 'MEM_OPT' '-Xmx512M')
bashio::log.info "alist-tvbox-standalone JVM memory: ${MEM_OPT}"

# 调用上游初始化脚本（配置 AList 等）
bashio::log.info "Running upstream initialization..."
export INSTALL=new
/docker/scripts/init-alist.sh 2>&1 | tee /data/log/init.log || true

bashio::log.info "alist-tvbox-standalone initialization completed"
