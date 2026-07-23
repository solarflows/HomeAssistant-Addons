#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Lucky 初始化脚本
# ==============================================================================
# Lucky 使用 -c 指定配置文件路径，数据库等会写入同目录，无需 symlink

bashio::log.info "Initializing Lucky..."

# 创建持久化目录（lucky 首次运行会自动生成 lucky.conf）
mkdir -p /config/luckyconf

bashio::log.info "Lucky initialization completed"

rm -f /run/service/lucky/down 2>/dev/null
