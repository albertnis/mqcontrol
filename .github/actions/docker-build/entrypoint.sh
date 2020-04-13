#!/bin/sh
set -e

BUILD_DIR=bin

docker build --target export \
    --build-arg GOARCH=$1 \
    --build-arg GOOS=$2 \
    -o $BUILD_DIR .

mv $BUILD_DIR/mqcontrol $BUILD_DIR/$3
chmod 755 $BUILD_DIR/$3

echo "::set-output name=artifact_path::./$BUILD_DIR/$3"