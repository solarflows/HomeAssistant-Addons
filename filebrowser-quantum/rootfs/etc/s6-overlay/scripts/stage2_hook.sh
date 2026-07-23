#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# S6 Stage 2 Hook — 后台等待 legacy-services 创建服务树后启动用户服务
#
# S6_STAGE2_HOOK 在 s6-rc 管道之前执行，此时 /run/service/*/ 尚未创建。
# 主流程立即返回（不阻塞 s6-rc），后台轮询等待 legacy-services 就绪。
# ==============================================================================
(
  for i in $(seq 1 30); do
    found=0
    for svc_dir in /run/service/*/; do
      [ -d "$svc_dir" ] || continue
      svc_name=$(basename "$svc_dir")
      case "$svc_name" in s6-*|.s6-*) continue ;; esac
      found=1; break
    done
    [ "$found" = "1" ] && break
    sleep 1
  done
  for svc_dir in /run/service/*/; do
    [ -d "$svc_dir" ] || continue
    svc_name=$(basename "$svc_dir")
    case "$svc_name" in s6-*|.s6-*) continue ;; esac
    rm -f "${svc_dir}down" 2>/dev/null
    s6-svc -u "$svc_dir" 2>/dev/null
    bashio::log.info "Started service: ${svc_name}"
  done
) &
