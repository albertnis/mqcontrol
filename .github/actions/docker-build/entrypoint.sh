#!/bin/sh
set -e

BUILD_DIR=bin

docker build --target export \
    --build-arg GOARCH=$1 \
    --build-arg GOOS=$2 \
    --build-arg BIN_NAME=$3 \
    -o $BUILD_DIR .

echo "::set-output name=artifact_path::./$BUILD_DIR/$3"