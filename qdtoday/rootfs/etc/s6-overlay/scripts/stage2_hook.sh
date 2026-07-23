#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# S6 Stage 2 Hook — 确保所有用户自定义服务被启动
# legacy-services 创建 down 标记早于 cont-init 执行，需在此阶段移除
# ==============================================================================
for svc_dir in /run/service/*/; do
    [ -d "$svc_dir" ] || continue
    svc_name=$(basename "$svc_dir")
    # 跳过 S6 内置服务
    case "$svc_name" in
        s6-*|.s6-*) continue ;;
    esac
    rm -f "${svc_dir}down"
    s6-svc -u "$svc_dir" 2>/dev/null
    bashio::log.info "Started service: ${svc_name}"
done
