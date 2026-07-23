#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# S6 Stage 2 Hook — Ensure all user-defined services are started
# legacy-services creates down flags before cont-init runs, so we remove
# them here (after cont-init) and explicitly start the services.
# ==============================================================================
for svc_dir in /run/service/*/; do
    [ -d "$svc_dir" ] || continue
    svc_name=$(basename "$svc_dir")
    case "$svc_name" in
        s6-*|.s6-*) continue ;;
    esac
    rm -f "${svc_dir}down" 2>/dev/null
    /package/admin/s6/command/s6-svc -u "$svc_dir" 2>/dev/null
    bashio::log.info "Started service: ${svc_name}"
done
