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

    # Tests if tag already exist
    echo "Check tag existance for '${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}'"
    docker manifest inspect "thibaultmeyer/distroless-java:${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}" > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]} already exist. Skip!"
        continue
    fi


    # Cleans all images
    for image in `docker images --format '{{.Repository}}:{{.Tag}}' 'thibaultmeyer/distroless-java'`
    do
        docker rmi --force "${image}" > /dev/null 2>&1
    done


    # Creates manifest "full version"
    MANIFEST_LIST=()
    for platform in "${!CURRENT_JDK[@]}"
    do
        if [[ "${platform}" == "VERSION" || "${platform}" == "VENDOR" || "${platform}" == "LATEST" ]]
        then
            continue
        fi

        tag_full="${PLAT_TAG[$platform]}_${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}"

        # Tests if tag exist
        echo "Check tag existance for '${tag_full}'"
        docker manifest inspect "thibaultmeyer/distroless-java:${tag_full}" > /dev/null 2>&1
        if [ $? == 0 ]
        then
            echo "'${tag_full}' marked as candidate"
            MANIFEST_LIST+=("thibaultmeyer/distroless-java:${tag_full}")
        else
            echo "'${tag_full}' does not exist!"
        fi
    done

    minish_die_ifzero ${#MANIFEST_LIST[@]} "Manifest is empty"
    echo "Generate manifest for '${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}': ${MANIFEST_LIST[@]}"
    docker manifest create "thibaultmeyer/distroless-java:${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}" ${MANIFEST_LIST[@]}
    
    echo "Push manifest for '${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}'"
    docker manifest push --purge "thibaultmeyer/distroless-java:${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}"


    # Creates manifest "major version"
    if [ "${CURRENT_JDK[LATEST]}" == "true" ]
    then
        JAVA_VERSION_MAJOR="$(echo "${CURRENT_JDK[VERSION]}" | cut -d'.' -f1)"

        MANIFEST_LIST=()
        for platform in "${!CURRENT_JDK[@]}"
        do
            if [[ "${platform}" == "VERSION" || "${platform}" == "VENDOR" || "${platform}" == "LATEST" ]]
            then
                continue
            fi

            tag_major="${PLAT_TAG[$platform]}_${CURRENT_JDK[VENDOR]}-${JAVA_VERSION_MAJOR}"

            # Tests if tag exist
            echo "Check tag existance for '${tag_major}'"
            docker manifest inspect "thibaultmeyer/distroless-java:${tag_major}" > /dev/null 2>&1
            if [ $? == 0 ]
            then
                echo "'${tag_major}' marked as candidate"
                MANIFEST_LIST+=("thibaultmeyer/distroless-java:${tag_major}")
            else
                echo "'${tag_major}' does not exist!"
            fi
        done

        minish_die_ifzero ${#MANIFEST_LIST[@]} "Manifest is empty"
        echo "Generate manifest for '${CURRENT_JDK[VENDOR]}-${JAVA_VERSION_MAJOR}': ${MANIFEST_LIST[@]}"
        docker manifest create "thibaultmeyer/distroless-java:${CURRENT_JDK[VENDOR]}-${JAVA_VERSION_MAJOR}" ${MANIFEST_LIST[@]}

        echo "Push manifest for '${CURRENT_JDK[VENDOR]}-${JAVA_VERSION_MAJOR}'"
        docker manifest push --purge "thibaultmeyer/distroless-java:${CURRENT_JDK[VENDOR]}-${JAVA_VERSION_MAJOR}"
    fi
done
