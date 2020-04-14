#!/bin/sh
set -e

BUILD_DIR=bin
ARTIFACT_PATH=$BUILD_DIR/$1

docker build --target export -o $BUILD_DIR \
    --build-arg TARGETOS=$2 --build-arg TARGETARCH=$3 \
    .

chmod -R 755 $BUILD_DIR
mv $BUILD_DIR/mqcontrol $ARTIFACT_PATH
echo "::set-output name=artifact_path::./$ARTIFACT_PATH"