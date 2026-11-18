#!/usr/bin/env bash
# ==============================================================================
# Unified GitHub Actions Summary Note Generator
# 用法:
#   gen-summary.sh plan   -> Version_Check.yml 全局规划与巡检总览
#   gen-summary.sh build  -> Release.yml 单 Addon 构建交付卡片
# ==============================================================================
set -euo pipefail

MODE="${1:-}"

emit_summary() {
    if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
        cat >> "${GITHUB_STEP_SUMMARY}"
    else
        cat
    fi
}

# 将逗号分隔的 reason 映射为统一可读徽章
format_reasons() {
    local raw="${1:-}"
    local result=""
    local IFS=','
    local part badge
    for part in ${raw}; do
        case "${part}" in
            version_changed) badge="🆕 上游更新" ;;
            base_updated)    badge="🧱 底包更新" ;;
            dockerfile)      badge="🐳 Dockerfile" ;;
            patches)         badge="🩹 补丁" ;;
            rootfs)          badge="📂 Rootfs" ;;
            config)          badge="🔧 配置" ;;
            workflow)        badge="⚙️ CI 工作流" ;;
            force_rebuild)   badge="🔁 强制重建" ;;
            "")              continue ;;
            *)               badge="\`${part}\`" ;;
        esac
        [ -n "${result}" ] && result="${result} + "
        result="${result}${badge}"
    done
    [ -z "${result}" ] && result="-"
    printf '%s' "${result}"
}

# 扫描指定 Addon 的生效补丁列表（输出格式: <repo>/<filename>，一行一条）
list_addon_patches() {
    local addon_dir="$1"
    local patch_root="${addon_dir}/patches"
    [ -d "${patch_root}" ] || return 0
    local repo_dir repo_name pf
    for repo_dir in "${patch_root}"/*; do
        [ -d "${repo_dir}" ] || continue
        repo_name="$(basename "${repo_dir}")"
        for pf in "${repo_dir}"/*; do
            case "${pf}" in
                *.patch|*.diff)
                    [ -f "${pf}" ] && printf '%s/%s\n' "${repo_name}" "$(basename "${pf}")"
                    ;;
            esac
        done
    done
}

# 转义 Markdown 表格管道符
md_escape() {
    printf '%s' "${1:-}" | tr '\r\n' ' ' | sed 's/|/\\|/g; s/^[[:space:]]*//; s/[[:space:]]*$//'
}

render_plan() {
    local event_name="${EVENT_NAME:-unknown}"
    local base_tag="${REMOTE_BASE_TAG:-unknown}"
    local total_addons="${TOTAL_ADDONS:-0}"
    local matrix_json="${MATRIX_JSON:-{\"include\":[]}}"
    local skipped_file="${SKIPPED_ERRORS_FILE:-}"
    local build_count
    build_count=$(printf '%s' "${matrix_json}" | jq -r '.include | length' 2>/dev/null | tr -d '\r\n' || true)
    [[ "${build_count}" =~ ^[0-9]+$ ]] || build_count=0

    {
        echo "## 🔍 版本检查与构建清单"
        echo ""
        echo "> **触发方式**：\`${event_name}\` · **检查总数**：\`${total_addons}\` · **需构建**：\`${build_count}\` · **底包版本**：\`debian-base:${base_tag}\`"
        echo ""

        if [ "${build_count}" -gt 0 ]; then
            echo "| 插件 | 触发原因 | 版本 | 补丁 | 说明 |"
            echo "|:---|:---|:---|:---:|:---|"

            printf '%s' "${matrix_json}" | jq -c '.include[]' | tr -d '\r' | while IFS= read -r item; do
                local addon reason new_ver commit_msg local_ver title reasons_fmt ver_col patch_count patch_col note_col
                addon=$(printf '%s' "${item}" | jq -r '.addon' | tr -d '\r')
                reason=$(printf '%s' "${item}" | jq -r '.reason' | tr -d '\r')
                new_ver=$(printf '%s' "${item}" | jq -r '.new_ver // ""' | tr -d '\r')
                commit_msg=$(printf '%s' "${item}" | jq -r '.commit_msg // ""' | tr -d '\r')

                title="${addon}"
                if [ -f "${addon}/config.yaml" ]; then
                    local cfg_name
                    cfg_name=$(yq eval '.name // ""' "${addon}/config.yaml" 2>/dev/null | tr -d '\r' || true)
                    [ -n "${cfg_name}" ] && title="${cfg_name} (\`${addon}\`)"
                fi

                local_ver=""
                [ -f "${addon}/version.yaml" ] && local_ver=$(yq eval '.version // ""' "${addon}/version.yaml" 2>/dev/null | tr -d '\r' || true)

                reasons_fmt=$(format_reasons "${reason}")
                if [ -n "${local_ver}" ] && [ -n "${new_ver}" ] && [ "${local_ver}" != "${new_ver}" ]; then
                    ver_col="\`${local_ver}\` → \`${new_ver}\`"
                elif [ -n "${new_ver}" ]; then
                    ver_col="\`${new_ver}\`"
                else
                    ver_col="\`${local_ver:-N/A}\`"
                fi

                patch_count=$(list_addon_patches "${addon}" | wc -l | tr -d ' ')
                if [ "${patch_count}" -gt 0 ]; then
                    patch_col="🩹 ${patch_count}"
                else
                    patch_col="-"
                fi

                note_col=$(printf '%s' "${commit_msg}" | head -n 1 | sed 's/^- //')
                [ -z "${note_col}" ] && note_col="-"
                note_col=$(md_escape "${note_col}")

                echo "| $(md_escape "${title}") | ${reasons_fmt} | ${ver_col} | ${patch_col} | ${note_col} |"
            done
        else
            echo "> ✅ **全部 ${total_addons} 个插件均已是最新，无需构建。**"
        fi

        if [ -n "${skipped_file}" ] && [ -s "${skipped_file}" ]; then
            echo ""
            echo "### ⚠️ 检查失败的上游仓库（已跳过）"
            echo ""
            echo "| 插件 | 上游仓库 | 检查方式 | 原因 |"
            echo "|:---|:---|:---:|:---|"
            while IFS='|' read -r s_addon s_repo s_strat s_msg; do
                [ -z "${s_addon}" ] && continue
                echo "| \`${s_addon}\` | \`${s_repo}\` | \`${s_strat}\` | $(md_escape "${s_msg}") |"
            done < "${skipped_file}"
        fi
        echo ""
    } | emit_summary
}

render_build() {
    local addon_dir="${ADDON_DIR:-}"
    local title="${ADDON_TITLE:-${addon_dir}}"
    local desc="${ADDON_DESC:-}"
    local license="${ADDON_LICENSE:-MIT}"
    local upstream_repo="${UPSTREAM_REPO:-}"
    local image_ref="${IMAGE_REF:-}"
    local job_status="${JOB_STATUS:-unknown}"
    local reason="${REASON:-}"
    local old_ver="${OLD_VERSION:-}"
    local build_ver="${BUILD_VERSION:-}"
    local commit_msg="${COMMIT_MSG:-}"
    local repo_owner="${REPO_OWNER:-${GITHUB_REPOSITORY_OWNER:-solarflows}}"
    local repo_full="${REPO_FULL:-${GITHUB_REPOSITORY:-solarflows/HomeAssistant-Addons}}"

    local status_icon="✅"
    local status_text="构建成功"
    if [ "${job_status}" != "success" ]; then
        status_icon="❌"
        status_text="构建失败 (${job_status})"
    fi

    local reasons_fmt
    reasons_fmt=$(format_reasons "${reason}")

    local ver_display="\`${build_ver}\`"
    if [ -n "${old_ver}" ] && [ -n "${build_ver}" ] && [ "${old_ver}" != "${build_ver}" ]; then
        ver_display="\`${old_ver}\` → \`${build_ver}\`"
    fi

    local upstream_cell="-"
    if [ -n "${upstream_repo}" ]; then
        upstream_cell="[${upstream_repo}](https://github.com/${upstream_repo}) · \`${license}\`"
    fi

    local ghcr_pkg_url="https://github.com/${repo_owner}/HomeAssistant-Addons/pkgs/container/${addon_dir}"

    {
        echo "### ${status_icon} ${title} (\`${addon_dir}\`) — ${status_text}"
        echo ""
        if [ -n "${desc}" ]; then
            echo "> ${desc}"
            echo ""
        fi

        echo "| 项目 | 内容 |"
        echo "|:---|:---|"
        echo "| **镜像地址** | \`${image_ref}\` ([GHCR 页面](${ghcr_pkg_url})) |"
        echo "| **触发原因** | ${reasons_fmt} |"
        echo "| **版本变化** | ${ver_display} |"
        echo "| **上游仓库** | ${upstream_cell} |"

        # 补丁清单
        local patches_list
        patches_list=$(list_addon_patches "${addon_dir}" || true)
        if [ -n "${patches_list}" ]; then
            local patches_inline
            patches_inline=$(printf '%s\n' "${patches_list}" | awk '{printf "%s`%s`", (NR>1 ? ", " : ""), $0}')
            echo "| **已打补丁** | 🩹 ${patches_inline} |"
        elif [ -d "${addon_dir}/patches" ]; then
            echo "| **已打补丁** | 无 |"
        fi
        echo ""

        # 多架构镜像大小表（仅构建成功时查询）
        if [ "${job_status}" = "success" ] && [ -n "${image_ref}" ] && command -v docker >/dev/null 2>&1; then
            local raw=""
            local i
            for i in 1 2 3 4 5; do
                raw=$(docker buildx imagetools inspect "${image_ref}" --raw 2>/dev/null || true)
                [ -n "${raw}" ] && break
                sleep 3
            done

            if [ -n "${raw}" ]; then
                echo "| 架构 | 镜像大小 |"
                echo "|:---|---:|"
                printf '%s' "${raw}" | jq -r '.manifests[]? | select(.platform.architecture != "unknown") | "\(.platform.os)/\(.platform.architecture)"' 2>/dev/null \
                  | while IFS= read -r platform; do
                      local size size_mb
                      size=$(regctl manifest get "${image_ref}" --platform "${platform}" --format '{{ .GetSize }}' 2>/dev/null || true)
                      if [ -n "${size}" ]; then
                          size_mb=$(awk "BEGIN {printf \"%.1f MB\", ${size} / 1000000}" 2>/dev/null || echo "N/A")
                      else
                          size_mb="N/A"
                      fi
                      echo "| \`${platform}\` | ${size_mb} |"
                    done || true
                echo ""
            fi
        fi

        if [ -n "${commit_msg}" ]; then
            echo "<details><summary>📝 变更记录</summary>"
            echo ""
            printf '%s\n' "${commit_msg}"
            echo ""
            echo "</details>"
            echo ""
        fi
    } | emit_summary
}

case "${MODE}" in
    plan)  render_plan ;;
    build) render_build ;;
    *)
        echo "[gen-summary] ERROR: expected mode 'plan' or 'build' (got '${MODE}')" >&2
        exit 1
        ;;
esac
