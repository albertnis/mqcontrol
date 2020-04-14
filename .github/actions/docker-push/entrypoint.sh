#!/bin/sh
set -e
VERSION=$1

docker login -u albertnis -p $2 docker.io

for RI in alpine debian
do
  docker buildx build --target runtime \
    --platform linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --build-arg RUNTIME_IMAGE=$RI:latest \
    -t albertnis/mqcontrol:$VERSION-$RI \
    -t albertnis/mqcontrol:latest-$RI \
    . \
    --push
done
