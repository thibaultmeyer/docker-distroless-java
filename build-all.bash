#!/usr/bin/env bash


# Loads
source "$(dirname "${BASH_SOURCE[0]}")/constants.inc.bash"
source "$(dirname "${BASH_SOURCE[0]}")/rootfsbuilder/lib/libminish/libminish.bash"



# Checks settings
if minish_string_isblank "${CURRENT_PLATFORM}"
then
    minish_die 1 "CURRENT_PLATFORM is blank"
elif minish_string_isblank "${PLATFORM[${CURRENT_PLATFORM}]}"
then
    minish_die 1 "PLATFORM not handled"
fi



# Go
for index in "${JDK_LIST[@]}"
do
    declare -n CURRENT_JDK=$index

    # Tests if version already exist
    docker manifest inspect "thibaultmeyer/distroless-java:${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}" > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]} already exist. Skip!"
        continue
    fi


    # Cleans all images
    docker rmi --force "rootfs" > /dev/null 2>&1
    docker rmi --force "debian:bullseye" > /dev/null 2>&1
    for image in `docker images --format '{{.Repository}}:{{.Tag}}' 'thibaultmeyer/distroless-java'`
    do
        docker rmi --force "${image}" > /dev/null 2>&1
    done
    docker system prune --all --force


    # Builds
    for platform in "${!CURRENT_JDK[@]}"
    do
        if [[ "${platform}" == "VERSION" || "${platform}" == "VENDOR" || "${platform}" == "LATEST" ]]
        then
            continue
        elif [ "${platform}" != "${CURRENT_PLATFORM}" ]
        then
            continue
        fi

        echo "====================================="
        echo "JDK     : ${CURRENT_JDK[$platform]}"
        echo "Tag     : ${PLAT_TAG[$platform]}"
        echo "Platform: ${PLATFORM[$platform]}"
        echo "Vendor  : ${CURRENT_JDK[VENDOR]}"
        echo "Version : ${CURRENT_JDK[VERSION]}"
        echo "Latest  : ${CURRENT_JDK[LATEST]}"
        echo "====================================="

        tag_full="${PLAT_TAG[$platform]}_${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}"
        if [ "${CURRENT_JDK[LATEST]}" == "true" ]
        then
            tag_major="${PLAT_TAG[$platform]}_${CURRENT_JDK[VENDOR]}-$(echo "${CURRENT_JDK[VERSION]}" | cut -d'.' -f1)"
        else
            tag_major=""
        fi

        # Tests if image exist
        docker manifest inspect "thibaultmeyer/distroless-java:${tag_full}" > /dev/null 2>&1
        if [ $? == 0 ]
        then
            echo "${tag_full} already exist. Skip!"
            continue
        fi

        DOCKER_DEFAULT_PLATFORM=${PLATFORM[$platform]} bash ./build.bash "${CURRENT_JDK[$platform]}" "${tag_full}" "${tag_major}"
        minish_die_ifnotzero $? "Can't build base image '${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}'"
    done
done
