#!/bin/sh
set -e

docker build --target export \
    --build-arg GOARCH=$1 \
    --build-arg GOOS=$2 \
    --build-arg BIN_NAME=$3 \
    -o bin .
