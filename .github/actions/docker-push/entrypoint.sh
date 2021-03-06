#!/bin/sh
set -e
VERSION=$1

docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
docker buildx create --use --name builder

docker login -u albertnis -p $2 docker.io

for RI in debian docker scratch alpine
do
  docker buildx build --target runtime \
    --platform linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --build-arg TARGETIMAGE=$RI \
    -t albertnis/mqcontrol:$VERSION-$RI \
    -t albertnis/mqcontrol:latest-$RI \
    -t albertnis/mqcontrol:latest \
    . \
    --push
done
