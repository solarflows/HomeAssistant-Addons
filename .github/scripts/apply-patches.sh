#!/bin/sh
# ==============================================================================
# Universal Build-Time Patch Applier (全仓唯一统一补丁执行器)
# 用法: apply-patches.sh [SRC_BASE_DIR]
# 规范:
#   - 强制多仓库自动映射模式: /patches/<repo_name>/*.patch -> /src/<repo_name>
#   - 无论当前是否有补丁一律无条件调用；无补丁时秒级放行 (exit 0)
#   - 若在 /patches/ 根目录误放散落补丁或目标 /src/<repo_name> 不存在，立即熔断 (exit 1)
# ==============================================================================
set -e

SRC_BASE_DIR="${1:-/src}"
PATCH_BASE_DIR="${PATCH_BASE_DIR:-/patches}"

if [ ! -d "${PATCH_BASE_DIR}" ]; then
    echo "[apply-patches] No patch base directory '${PATCH_BASE_DIR}', skipping."
    exit 0
fi

# 转化为绝对路径，消除后续 cd 对相对路径的影响（且支持路径含空格）
PATCH_BASE_DIR="$(cd "${PATCH_BASE_DIR}" && pwd)"

if [ ! -d "${SRC_BASE_DIR}" ]; then
    echo "[apply-patches] ERROR: Source base directory '${SRC_BASE_DIR}' does not exist." >&2
    exit 1
fi
SRC_BASE_DIR="$(cd "${SRC_BASE_DIR}" && pwd)"

# 1. 强校验：禁止在 /patches/ 根目录直接散落补丁（必须归档到 <repo_name>/ 子目录）
for stray in "${PATCH_BASE_DIR}"/*; do
    case "${stray}" in
        *.patch|*.diff)
            if [ -f "${stray}" ]; then
                echo "[apply-patches] [FATAL] Stray patch found in root '${PATCH_BASE_DIR}': $(basename "${stray}")" >&2
                echo "[apply-patches] Patches MUST be placed inside '${PATCH_BASE_DIR}/<repo_name>/'." >&2
                exit 1
            fi
            ;;
    esac
done

# 2. 扫描所有子目录，按 <repo_name> 自动映射至 ${SRC_BASE_DIR}/<repo_name>
TOTAL_APPLIED=0

for repo_patch_dir in "${PATCH_BASE_DIR}"/*; do
    [ -d "${repo_patch_dir}" ] || continue
    repo_name="$(basename "${repo_patch_dir}")"

    # 检查该子目录是否存在有效补丁文件
    has_patches=0
    for f in "${repo_patch_dir}"/*; do
        case "$f" in
            *.patch|*.diff)
                if [ -f "$f" ]; then
                    has_patches=1
                    break
                fi
                ;;
        esac
    done

    if [ "${has_patches}" -eq 0 ]; then
        continue
    fi

    target_dir="${SRC_BASE_DIR}/${repo_name}"
    if [ ! -d "${target_dir}" ]; then
        echo "[apply-patches] [FATAL] Target source directory '${target_dir}' does not exist for patch repo '${repo_name}'." >&2
        exit 1
    fi

    echo "================================================================================"
    echo "[apply-patches] Applying patches: ${repo_name} -> ${target_dir}"
    echo "================================================================================"

    cd "${target_dir}"

    for patch_file in "${repo_patch_dir}"/*; do
        case "${patch_file}" in
            *.patch|*.diff)
                [ -f "${patch_file}" ] || continue
                ;;
            *)
                continue
                ;;
        esac

        patch_name="$(basename "${patch_file}")"
        echo "[apply-patches] --> Applying: ${repo_name}/${patch_name}"

        # 优先使用 git apply (支持精确上下文检查、文件模式与重命名)
        if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            if git apply --check "${patch_file}" 2>/dev/null; then
                git apply "${patch_file}"
                echo "[apply-patches]     [SUCCESS] Applied via git apply: ${patch_name}"
                TOTAL_APPLIED=$((TOTAL_APPLIED + 1))
                continue
            fi
        fi

        # 降级使用 patch -p1
        if command -v patch >/dev/null 2>&1; then
            if patch -p1 --forward --batch --dry-run < "${patch_file}" >/dev/null 2>&1; then
                patch -p1 --forward --batch < "${patch_file}"
                echo "[apply-patches]     [SUCCESS] Applied via patch -p1: ${patch_name}"
                TOTAL_APPLIED=$((TOTAL_APPLIED + 1))
                continue
            fi
        fi

        # 失败排障输出并严格退出 1 阻断构建
        echo "[apply-patches] [FATAL] Failed to apply patch: ${repo_name}/${patch_name}" >&2
        echo "[apply-patches] Diagnostic dry-run output:" >&2
        if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            git apply --check "${patch_file}" || true
        elif command -v patch >/dev/null 2>&1; then
            patch -p1 --forward --batch --dry-run < "${patch_file}" || true
        fi
        exit 1
    done

    echo "[apply-patches] Completed '${repo_name}'."
    echo "================================================================================"
done

if [ "${TOTAL_APPLIED}" -eq 0 ]; then
    echo "[apply-patches] No patches found under '${PATCH_BASE_DIR}', skipping."
fi
