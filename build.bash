#!/usr/bin/env bash


JDK_URL="${1}"
TAG_FULL="${2}"
TAG_MAJOR="${3}"



# Loads libraries
source "$(dirname "${BASH_SOURCE[0]}")/rootfsbuilder/lib/libminish/libminish.bash"



# Checks settings
if minish_string_isblank "${JDK_URL}"; then
    minish_die 1 "JDK_URL arguments is missing"
elif minish_string_isblank "${TAG_FULL}"; then
    minish_die 1 "TAG_FULL arguments is missing"
fi



# Creates rootfs
docker build                            \
    --file Dockerfile.rootfs            \
    --tag rootfs                        \
    --build-arg JDK_URL="${JDK_URL}"    \
    .
minish_die_ifnotzero $? "Can't build rootfs archive"

docker run      \
    --rm rootfs \
    cat /tmp/rootfs.tar.gz > rootfs.tar.gz
minish_die_ifnotzero $? "Can't retrieve rootfs archive"



# Creates Java base image
docker build                                           \
    --tag thibaultmeyer/distroless-java                \
    --tag thibaultmeyer/distroless-java:${TAG_FULL}    \
    --file Dockerfile .
minish_die_ifnotzero $? "Can't build Java base image"



# Push image
docker push thibaultmeyer/distroless-java:${TAG_FULL}

if ! minish_string_isblank "${TAG_MAJOR}"
then
    docker tag thibaultmeyer/distroless-java:${TAG_FULL} thibaultmeyer/distroless-java:${TAG_MAJOR}
    docker push thibaultmeyer/distroless-java:${TAG_MAJOR}
fi



# Cleans temporary images
docker rmi --force rootfs > /dev/null 2>&1
docker rmi --force debian:bullseye > /dev/null 2>&1
docker rmi --force thibaultmeyer/distroless-java > /dev/null 2>&1
