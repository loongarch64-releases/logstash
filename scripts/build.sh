#!/bin/bash
set -xeuo pipefail

UPSTREAM_OWNER=elastic
UPSTREAM_REPO=logstash
VERSION="${1}"
echo "   🏢 Org:   ${UPSTREAM_OWNER}"
echo "   📦 Proj:  ${UPSTREAM_REPO}"
echo "   🏷️  Ver:   ${VERSION}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
DISTS="${ROOT_DIR}/dists"
SRCS="${ROOT_DIR}/srcs"
PATCHES="${ROOT_DIR}/patches"

mkdir -p "${DISTS}/${VERSION}" "${SRCS}"

# ==========================================
# 👇 用户自定义构建逻辑 (示例)
# ==========================================

echo "🔧 Compiling ${UPSTREAM_OWNER}/${UPSTREAM_REPO} ${VERSION}..."

# 1. 准备阶段：安装依赖、下载代码、应用补丁等
prepare()
{
    echo "📦 [Prepare] Setting up build environment..."
    
    [ -d "${SRCS}/${UPSTREAM_REPO}-${VERSION}" ] && rm -rf "${SRCS}/${UPSTREAM_REPO}-${VERSION}"
    mkdir -p "${SRCS}/${UPSTREAM_REPO}-${VERSION}"
    wget -O "${SRCS}/${VERSION}.tar.gz" --quiet --show-progress "https://artifacts.elastic.co/downloads/${UPSTREAM_REPO}/${UPSTREAM_REPO}-${VERSION}-linux-x86_64.tar.gz"
    tar -xzf "${SRCS}/${VERSION}.tar.gz" -C "${SRCS}/${UPSTREAM_REPO}-${VERSION}" --strip-components=1

    # patch
    "${PATCHES}/patch.sh" "${SRCS}/${UPSTREAM_REPO}-${VERSION}" "${VERSION}"
    
    echo "✅ [Prepare] Environment ready."
}

# 2. 编译阶段：核心构建命令
build()
{
    echo "🔨 [Build] Compiling source code..."

    # nothing to do

    echo "✅ [Build] Compilation finished."
}

# 3. 后处理阶段：整理产物、清理临时文件、验证版本
post_build()
{
    echo "📦 [Post-Build] Organizing artifacts..."
    
    local PRODUCT="${DISTS}/${VERSION}/${UPSTREAM_REPO}-${VERSION}-linux-loongarch64.tar.gz"
    tar -czf "${PRODUCT}" -C "${SRCS}" "${UPSTREAM_REPO}-${VERSION}"
    chown -R "${HOST_UID}:${HOST_GID}" "${DISTS}" "${SRCS}"
    
    echo "✅ [Post-Build] Artifacts ready in ./dists/${VERSION}."
}

# 主入口
main()
{
    prepare
    build
    post_build
}

main

# ==========================================
# 👆 自定义逻辑结束
# ==========================================

cat > "${DISTS}/${VERSION}/release.txt" <<EOF
Project: ${UPSTREAM_REPO}
Organization: ${UPSTREAM_OWNER}
Version: ${VERSION}
Build Time: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

echo "✅ Compilation finished."
ls -lh "${DISTS}/${VERSION}"
