#!/bin/sh
set -e
VERSION=$1

docker run --privileged --rm tonistiigi/binfmt --install all
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
