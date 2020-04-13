#!/bin/sh
set -e

VERSION=$1

mkdir -p ~/.docker
echo "{\"experimental\": \"enabled\"}" > ~/.docker/config.json

docker login -u albertnis -p $2 docker.io

for RI in alpine debian
do
  docker build --target runtime \
    --build-arg GOARCH=arm \
    --build-arg GOOS=linux \
    --build-arg RUNTIME_IMAGE=$RI:latest \
    --build-arg RUNTIME_PLATFORM=linux/arm/v7 \
    -t albertnis/mqcontrol:$VERSION-$RI-arm32v7 \
    -t albertnis/mqcontrol:latest-$RI-arm32v7 .
  docker push albertnis/mqcontrol:$VERSION-$RI-arm32v7
  docker push albertnis/mqcontrol:latest-$RI-arm32v7

  docker build --target runtime \
    --build-arg GOARCH=arm64 \
    --build-arg GOOS=linux \
    --build-arg RUNTIME_IMAGE=$RI:latest \
    --build-arg RUNTIME_PLATFORM=linux/arm64/v8 \
    -t albertnis/mqcontrol:$VERSION-$RI-arm64v8 \
    -t albertnis/mqcontrol:latest-$RI-arm64v8 .
  docker push albertnis/mqcontrol:$VERSION-$RI-arm64v8
  docker push albertnis/mqcontrol:latest-$RI-arm64v8

  docker build --target runtime \
    --build-arg GOARCH=amd64 \
    --build-arg GOOS=linux \
    --build-arg RUNTIME_IMAGE=$RI:latest \
    --build-arg RUNTIME_PLATFORM=linux/amd64 \
    -t albertnis/mqcontrol:$VERSION-$RI-amd64 \
    -t albertnis/mqcontrol:latest-$RI-amd64 .
  docker push albertnis/mqcontrol:$VERSION-$RI-amd64
  docker push albertnis/mqcontrol:latest-$RI-amd64
done
