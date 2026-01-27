#!/bin/bash

#set -euo pipefail
set -exu 
set -o pipefail

VERSION="$1"

ORG='elastic'
PROJ='logstash'
ARCH='loongarch64'
WORKSPACE="/workspace"
SRCS="$WORKSPACE/srcs"
DISTS="$WORKSPACE/dists"
PATCHES="$WORKSPACE/patches"

mkdir -p "$SRCS" "$DISTS/$VERSION"

SRC_DIR="$PROJ-${VERSION#v}"

prepare()
{
    pushd "$SRCS" > /dev/null

    local TAR_FILE="$VERSION.tar.gz" 
    if [ ! -f "$TAR_FILE" ]; then
        wget -O "$TAR_FILE" --quiet --show-progress "https://artifacts.elastic.co/downloads/$PROJ/$PROJ-${VERSION#v}-linux-x86_64.tar.gz"
    fi

    if [ -d "$SRC_DIR" ]; then rm -rf "$SRC_DIR"; fi
    tar -xzf $TAR_FILE

    popd > /dev/null
}

process()
{   
    # patch
    "$PATCHES/patch.sh" "$SRCS/$SRC_DIR" "${VERSION#v}"
    
    OBJ_TAR="$SRC_DIR-linux-$ARCH.tar.gz"
    tar -czf "$DISTS/$VERSION/$OBJ_TAR" -C "$SRCS" "$SRC_DIR"
}

main()
{
    prepare
    process
}

main "$@"
