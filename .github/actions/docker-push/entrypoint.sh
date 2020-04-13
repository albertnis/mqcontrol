#!/bin/sh
set -e

VERSION=$1

mkdir -p ~/.docker
echo "{\"experimental\": \"enabled\"}" > ~/.docker/config.json

docker login -u albertnis -p $2

for RI in alpine debian
do
  docker build --target runtime \
    --build-arg GOARCH=arm \
    --build-arg GOOS=linux \
    --build-arg RUNTIME_IMAGE=$RI:latest \
    --build-arg RUNTIME_PLATFORM=linux/arm/v7 \
    -t mqcontrol:$VERSION-$RI-arm32v7 .

  docker build --target runtime \
    --build-arg GOARCH=arm64 \
    --build-arg GOOS=linux \
    --build-arg RUNTIME_IMAGE=$RI:latest \
    --build-arg RUNTIME_PLATFORM=linux/arm64/v8 \
    -t mqcontrol:$VERSION-$RI-arm64v8 .

  docker build --target runtime \
    --build-arg GOARCH=amd64 \
    --build-arg GOOS=linux \
    --build-arg RUNTIME_IMAGE=$RI:latest \
    --build-arg RUNTIME_PLATFORM=linux/amd64 \
    -t mqcontrol:$VERSION-$RI-amd64 .

  docker manifest create \
    albertnis/mqcontrol:$VERSION-$RI \
    mqcontrol:$VERSION-$RI-arm32v7 \
    mqcontrol:$VERSION-$RI-arm64v8 \
    mqcontrol:$VERSION-$RI-amd64

  docker manifest create \
    albertnis/mqcontrol:latest-$RI \
    albertnis/mqcontrol:$VERSION-$RI

  docker manifest push albertnis/mqcontrol:$VERSION-$RI
  docker manifest push albertnis/mqcontrol:latest-$RI

done

docker manifest create \
  albertnis/mqcontrol:$VERSION \
  albertnis/mqcontrol:$VERSION-debian

docker manifest create \
  albertnis/mqcontrol:latest \
  albertnis/mqcontrol:$VERSION-debian

  docker manifest push albertnis/mqcontrol:$VERSION
  docker manifest push albertnis/mqcontrol:latest