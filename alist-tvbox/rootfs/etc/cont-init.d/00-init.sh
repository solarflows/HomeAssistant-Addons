#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# alist-tvbox 初始化脚本
# 等价于上游 entrypoint.sh 的初始化部分（去掉 JVM 启动，由 S6 longrun 接管）
# 上游入口：docker/scripts/entrypoint.sh -> init-xiaoya.sh -> 启动服务
# 我们拆分：00-init.sh -> init-xiaoya.sh（初始化）; alist-tvbox/run -> 启动服务
# ==============================================================================

export INSTALL=xiaoya

# ---- HA addon 配置 ----
LOW_MEMORY=$(bashio::config "LOW_MEMORY" "true")
if [ "${LOW_MEMORY}" = "true" ]; then
    export MEM_OPT="-Xmx512M"
else
    export MEM_OPT="-Xmx1024M"
fi
bashio::log.info "alist-tvbox JVM memory: ${MEM_OPT}"

# Spring Boot external config 目录：上游 entrypoint.sh 在 exec java 前创建
# HAOS 中 /data 是持久卷，但空目录不会自动创建，需要显式 mkdir
# 如果在 00-init.sh 中提前创建，即使 alist-tvbox/run 并行执行也能确保目录存在
mkdir -p /data/atv/config/

# ---- HAOS 特有：上游 Docker 不需要，但我们的容器每次重启会丢失这些 ----
# AList 数据持久化：上游 Docker /data 是 volume，/opt/alist/data 自然持久
# HAOS 中 /data 是 supervisor 挂载的持久卷，但 /opt/alist/data 是容器层，重启会丢失
mkdir -p /data/alist
rm -rf /opt/alist/data
ln -sf /data/alist /opt/alist/data

# inDocker 检测：上游 entrypoint.sh 本身就存在于 /，我们用 symlink 兼容
[ -f /entrypoint.sh ] || ln -sf /docker/scripts/entrypoint.sh /entrypoint.sh

# ---- 以下与上游 entrypoint.sh 保持一致 ----
. /docker/scripts/lib/common.sh
. /docker/scripts/lib/proxy.sh

load_custom_env
setup_env_proxy
chmod a+x /docker/scripts/*.sh /docker/scripts/lib/*.sh
ensure_dir /data/log

bashio::log.info "Running upstream init-xiaoya.sh..."
# init-xiaoya.sh 有 set -e，某些步骤（索引下载、grep 等）可能非致命失败
# 记录退出码但不传播给 S6，防止 cont-init 标记为 failed 导致容器重启
set +e
/docker/scripts/init-xiaoya.sh 2>&1 | tee /data/log/init.log
init_exit=${PIPESTATUS[0]}
set -e
if [ ${init_exit} -ne 0 ]; then
    bashio::log.warning "init-xiaoya.sh exited with code ${init_exit} (non-fatal, continuing)"
fi

bashio::log.info "alist-tvbox initialization completed"