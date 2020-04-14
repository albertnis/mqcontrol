#!/bin/sh
set -e

BUILD_DIR=bin
ARTIFACT_PATH=$BUILD_DIR/$2

docker build --target export --build-arg GOOPTIONS="$1" \
    -o $BUILD_DIR .

chmod -R 755 $BUILD_DIR
mv $BUILD_DIR/mqcontrol ARTIFACT_PATH
echo "::set-output name=artifact_path::./$ARTIFACT_PATH"