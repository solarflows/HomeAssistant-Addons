#!/bin/sh
# ==============================================================================
# Universal Build-Time Patch Applier (全仓库统一补丁执行器)
# 用法: apply-patches.sh <REPO_NAME> [TARGET_DIR]
# 规范: 无论当前是否有补丁一律无条件调用；无补丁时秒级放行 (exit 0)
# ==============================================================================
set -e

REPO_NAME="${1:-}"
TARGET_DIR="${2:-.}"
PATCH_BASE_DIR="${PATCH_BASE_DIR:-/patches}"

if [ -z "${REPO_NAME}" ]; then
    echo "[apply-patches] ERROR: REPO_NAME argument is required" >&2
    exit 1
fi

REPO_PATCH_DIR="${PATCH_BASE_DIR}/${REPO_NAME}"

# 1. 检查是否存在该仓库的补丁目录（无补丁时直接放行）
if [ ! -d "${REPO_PATCH_DIR}" ]; then
    echo "[apply-patches] No patch directory for '${REPO_NAME}' (${REPO_PATCH_DIR}), skipping."
    exit 0
fi

# 转化为绝对路径，消除后续 cd 对相对路径的影响（且支持路径含空格）
REPO_PATCH_DIR="$(cd "${REPO_PATCH_DIR}" && pwd)"

# 2. 检查是否存在 .patch 或 .diff 文件
HAS_PATCHES=0
for f in "${REPO_PATCH_DIR}"/*; do
    case "$f" in
        *.patch|*.diff)
            if [ -f "$f" ]; then
                HAS_PATCHES=1
                break
            fi
            ;;
    esac
done

if [ "$HAS_PATCHES" -eq 0 ]; then
    echo "[apply-patches] No patches found in ${REPO_PATCH_DIR}, skipping."
    exit 0
fi

# 3. 逐个应用补丁
echo "================================================================================"
echo "[apply-patches] Applying patches for '${REPO_NAME}' in '${TARGET_DIR}'..."
echo "================================================================================"

# 进入目标工作目录
cd "${TARGET_DIR}"

for patch_file in "${REPO_PATCH_DIR}"/*; do
    case "${patch_file}" in
        *.patch|*.diff)
            [ -f "${patch_file}" ] || continue
            ;;
        *)
            continue
            ;;
    esac

    patch_name=$(basename "${patch_file}")
    echo "[apply-patches] --> Applying: ${patch_name}"
    
    # 优先使用 git apply (支持精确上下文检查、文件模式与重命名)
    if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        if git apply --check "${patch_file}" 2>/dev/null; then
            git apply "${patch_file}"
            echo "[apply-patches]     [SUCCESS] Applied via git apply: ${patch_name}"
            continue
        fi
    fi

    # 降级使用 patch -p1
    if command -v patch >/dev/null 2>&1; then
        if patch -p1 --forward --batch --dry-run < "${patch_file}" >/dev/null 2>&1; then
            patch -p1 --forward --batch < "${patch_file}"
            echo "[apply-patches]     [SUCCESS] Applied via patch -p1: ${patch_name}"
            continue
        fi
    fi

    # 失败排障输出并严格退出 1 阻断构建
    echo "[apply-patches] [FATAL] Failed to apply patch: ${patch_file}" >&2
    echo "[apply-patches] Diagnostic dry-run output:" >&2
    if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git apply --check "${patch_file}" || true
    elif command -v patch >/dev/null 2>&1; then
        patch -p1 --forward --batch --dry-run < "${patch_file}" || true
    fi
    exit 1
done

echo "[apply-patches] All patches for '${REPO_NAME}' successfully applied."
echo "================================================================================"
