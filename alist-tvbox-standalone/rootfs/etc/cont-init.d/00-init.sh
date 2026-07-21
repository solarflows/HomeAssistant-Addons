#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox-standalone 初始化脚本
# ==============================================================================

bashio::log.info "Initializing alist-tvbox-standalone..."

# 创建持久化目录
mkdir -p /config/data
mkdir -p /config/atv/config
mkdir -p /data/log

bashio::log.info "alist-tvbox-standalone initialization completed"
