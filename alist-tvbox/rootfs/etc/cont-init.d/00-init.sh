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
mkdir -p /data/log

# Alist 内核数据 → /data/alist（HAOS 持久化）
rm -rf /opt/alist/data
ln -sf /data/alist /opt/alist/data

# Spring Boot atv 数据直接写入 /data/store
mkdir -p /data/store

bashio::log.info "alist-tvbox initialization completed"
