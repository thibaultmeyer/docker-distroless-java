#!/bin/env sh

docker build -t rootfs -f Dockerfile.rootfs .
docker run --rm rootfs cat /tmp/rootfs.tar.gz > rootfs.tar.gz
docker rmi --force rootfs

docker build -t thibaultmeyer/distroless-java -f Dockerfile .
