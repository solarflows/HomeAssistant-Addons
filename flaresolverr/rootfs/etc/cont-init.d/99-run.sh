#!/bin/bash
# shellcheck shell=bash
# ==============================================================================
# FlareSolverr 启动脚本
# ==============================================================================

echo "Starting FlareSolverr..."

# 调用原始入口
exec /usr/bin/dumb-init -- python -u /app/flaresolverr.py
