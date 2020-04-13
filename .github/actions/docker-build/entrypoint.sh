#!/bin/sh
set -e

docker build --target build \
    --build-arg RUNTIME_IMAGE=$1 \
    --build-arg GOARCH=$2 \
    --build-arg GOOS=$3 \
    --build-arg BIN_EXT=$4 \
    -t mqcontrol-builder:latest .

docker create --name builder mqcontrol-builder:latest
docker cp builder:/project/bin $(pwd)
docker container rm -f builder