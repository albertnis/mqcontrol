#!/bin/sh
set -e

docker build --target build -t mqcontrol-builder:latest .
docker create --name builder mqcontrol-builder:latest
docker cp builder:/project/bin $(pwd)
docker container rm -f builder