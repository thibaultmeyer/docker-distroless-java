#!/usr/bin/env bash


# Loads
source "$(dirname "${BASH_SOURCE[0]}")/constants.inc.bash"
source "$(dirname "${BASH_SOURCE[0]}")/rootfsbuilder/lib/libminish/libminish.bash"
source "${HOME}/.config/docker-curl-auth.conf"



# Checks credentials
if minish_string_isblank "${repo_user}"
then
    minish_die 1 "repo_user is blank"
elif minish_string_isblank "${repo_token}"
then
    minish_die 1 "repo_token is blank"
fi



# Authentication
AUTH_TOKEN=$(curl -s -H "Content-Type: application/json" -X POST        \
    -d '{"username": "'${repo_user}'", "password": "'${repo_token}'"}'  \
    https://hub.docker.com/v2/users/login/ | jq -r .token)

if minish_string_isblank "${AUTH_TOKEN}"
then
    minish_die 1 "Authentication failure"
fi



# Deletes temporary tags
for index in "${JDK_LIST[@]}"
do
    declare -n CURRENT_JDK=$index

    for platform in "${!CURRENT_JDK[@]}"
    do
        if [[ "${platform}" == "VERSION" || "${platform}" == "VENDOR" || "${platform}" == "LATEST" ]]
        then
            continue
        fi

        tag_full="${PLAT_TAG[$platform]}_${CURRENT_JDK[VENDOR]}-${CURRENT_JDK[VERSION]}"
        tag_major="${PLAT_TAG[$platform]}_${CURRENT_JDK[VENDOR]}-$(echo "${CURRENT_JDK[VERSION]}" | cut -d'.' -f1)"

        echo "Delete tag '${tag_full}' if it exists"
        curl                                            \
            -X DELETE                                   \
            -H "Authorization: Bearer ${AUTH_TOKEN}"    \
            "https://hub.docker.com/v2/repositories/thibaultmeyer/distroless-java/tags/${tag_full}" > /dev/null 2>&1
        
        echo "Delete tag '${tag_major}' if it exists"
        curl                                            \
            -X DELETE                                   \
            -H "Authorization: Bearer ${AUTH_TOKEN}"    \
            "https://hub.docker.com/v2/repositories/thibaultmeyer/distroless-java/tags/${tag_major}" > /dev/null 2>&1
    done
done
