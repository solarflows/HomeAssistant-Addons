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

bashio::log.info "alist-tvbox-standalone initialization completed"

rm -f /run/service/atv-standalone/down 2>/dev/null
