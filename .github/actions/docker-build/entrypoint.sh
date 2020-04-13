#!/bin/sh
set -e

docker build --target export \
    --build-arg RUNTIME_IMAGE=$1 \
    --build-arg GOARCH=$2 \
    --build-arg GOOS=$3 \
    --build-arg BIN_EXT=$4 \
    -o bin .
