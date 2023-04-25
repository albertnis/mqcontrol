#!/bin/sh
set -e
VERSION=$1

docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --use --name builder

docker login -u albertnis -p $2 docker.io

for RI in scratch 'debian:11.6' 'alpine:3.17'
do
  docker buildx build --target runtime \
    --platform linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --build-arg TARGETIMAGE=$RI \
    -t albertnis/mqcontrol:$VERSION-${RI%%:*} \
    -t albertnis/mqcontrol:latest-${RI%%:*} \
    -t albertnis/mqcontrol:latest \
    . \
    --push
done

for RI in 'docker:23.0.4'
do
  docker buildx build --target runtime \
    --platform linux/amd64,linux/arm64/v8 \
    --build-arg TARGETIMAGE=$RI \
    -t albertnis/mqcontrol:$VERSION-${RI%%:*} \
    -t albertnis/mqcontrol:latest-${RI%%:*} \
    -t albertnis/mqcontrol:latest \
    . \
    --push
done
