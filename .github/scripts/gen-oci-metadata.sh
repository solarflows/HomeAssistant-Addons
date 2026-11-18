#!/usr/bin/env bash
# ==============================================================================
# Unified OCI Metadata & GHCR Description Generator
# 从各 Addon 的 config.yaml / version.yaml / analysis.yaml 单一真理源
# 统一生成 docker/build-push-action 所需的 labels 与多架构 OCI index annotations
# ==============================================================================
set -euo pipefail

ADDON_DIR="${1:-${ADDON_DIR:-}}"
BUILD_VERSION="${2:-${BUILD_VERSION:-latest}}"
REPO_FULL="${REPO_FULL:-${GITHUB_REPOSITORY:-solarflows/HomeAssistant-Addons}}"
REPO_OWNER="${REPO_OWNER:-${GITHUB_REPOSITORY_OWNER:-solarflows}}"
GIT_SHA="${GIT_SHA:-${GITHUB_SHA:-unknown}}"

if [ -z "${ADDON_DIR}" ] || [ ! -d "${ADDON_DIR}" ]; then
    echo "[gen-oci-metadata] ERROR: valid ADDON_DIR is required (got '${ADDON_DIR}')" >&2
    exit 1
fi

CONFIG_FILE="${ADDON_DIR}/config.yaml"
VERSION_FILE="${ADDON_DIR}/version.yaml"
ANALYSIS_FILE="${ADDON_DIR}/analysis.yaml"

# 1. 从单一真理源读取基础文案与元数据
TITLE=""
DESCRIPTION=""
if [ -f "${CONFIG_FILE}" ]; then
    TITLE=$(yq eval '.name // ""' "${CONFIG_FILE}" | tr '\r\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    DESCRIPTION=$(yq eval '.description // ""' "${CONFIG_FILE}" | tr '\r\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
fi
[ -z "${TITLE}" ] && TITLE="${ADDON_DIR}"
[ -z "${DESCRIPTION}" ] && DESCRIPTION="${TITLE} Home Assistant Add-on"

UPSTREAM_REPO=""
if [ -f "${VERSION_FILE}" ]; then
    UPSTREAM_REPO=$(yq eval '.repo // ""' "${VERSION_FILE}" | tr '\r\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
fi

# 2. 提取并清洗标准 SPDX License 标识（兼容顶层 upstream.license 与嵌套 upstream.gateway.license）
RAW_LICENSE=""
if [ -f "${ANALYSIS_FILE}" ]; then
    RAW_LICENSE=$(yq eval '.upstream.license // .upstream.gateway.license // ""' "${ANALYSIS_FILE}" 2>/dev/null | tr '\r\n' ' ' || true)
fi
LICENSE=$(printf '%s' "${RAW_LICENSE}" | sed -E 's/[（(].*$//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
[ -z "${LICENSE}" ] && LICENSE="MIT"

# 3. 拼装标准 OCI 链接与时间戳
CREATED=$(date -u +%Y-%m-%dT%H:%M:%SZ)
SOURCE_URL="https://github.com/${REPO_FULL}"
ADDON_URL="https://github.com/${REPO_FULL}/tree/main/${ADDON_DIR}"
DOCS_URL="https://github.com/${REPO_FULL}/blob/main/${ADDON_DIR}/DOCS.md"

# 4. 生成镜像 Config Labels（供 docker inspect 读取）
LABELS=$(cat <<EOF
org.opencontainers.image.title=${TITLE}
org.opencontainers.image.description=${DESCRIPTION}
org.opencontainers.image.authors=${REPO_OWNER}
org.opencontainers.image.vendor=${REPO_OWNER}
org.opencontainers.image.source=${SOURCE_URL}
org.opencontainers.image.url=${ADDON_URL}
org.opencontainers.image.documentation=${DOCS_URL}
org.opencontainers.image.version=${BUILD_VERSION}
org.opencontainers.image.revision=${GIT_SHA}
org.opencontainers.image.created=${CREATED}
org.opencontainers.image.licenses=${LICENSE}
EOF
)

# 5. 生成多架构 OCI Index Annotations（供 GHCR 包首页展示 Description / 链接 / 许可）
ANNOTATIONS=$(cat <<EOF
index:org.opencontainers.image.title=${TITLE}
index:org.opencontainers.image.description=${DESCRIPTION}
index:org.opencontainers.image.authors=${REPO_OWNER}
index:org.opencontainers.image.vendor=${REPO_OWNER}
index:org.opencontainers.image.source=${SOURCE_URL}
index:org.opencontainers.image.url=${ADDON_URL}
index:org.opencontainers.image.documentation=${DOCS_URL}
index:org.opencontainers.image.version=${BUILD_VERSION}
index:org.opencontainers.image.revision=${GIT_SHA}
index:org.opencontainers.image.created=${CREATED}
index:org.opencontainers.image.licenses=${LICENSE}
EOF
)

# 6. 写入 GITHUB_OUTPUT（或在本地调试时打印到 stdout）
if [ -n "${GITHUB_OUTPUT:-}" ]; then
    {
        echo "title=${TITLE}"
        echo "description=${DESCRIPTION}"
        echo "license=${LICENSE}"
        echo "upstream_repo=${UPSTREAM_REPO}"
        echo "labels<<OCI_LABELS_EOF"
        echo "${LABELS}"
        echo "OCI_LABELS_EOF"
        echo "annotations<<OCI_ANNOTATIONS_EOF"
        echo "${ANNOTATIONS}"
        echo "OCI_ANNOTATIONS_EOF"
    } >> "${GITHUB_OUTPUT}"
else
    echo "=== OCI Metadata Preview (${ADDON_DIR} @ ${BUILD_VERSION}) ==="
    echo "title        : ${TITLE}"
    echo "description  : ${DESCRIPTION}"
    echo "license      : ${LICENSE}"
    echo "upstream_repo: ${UPSTREAM_REPO}"
    echo "--- labels ---"
    echo "${LABELS}"
    echo "--- annotations ---"
    echo "${ANNOTATIONS}"
fi
