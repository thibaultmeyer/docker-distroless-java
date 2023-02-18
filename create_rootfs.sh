#!/bin/env bash


###############################################################################
###############################################################################
##                                                                           ##
##                             CONFIGURATION                                 ##
##                                                                           ##
###############################################################################
###############################################################################

BIN_TO_INCLUDE_LIST=(
    "/bin/sh"
)


###############################################################################
###############################################################################
##                                                                           ##
##                               FUNCTIONS                                   ##
##                                                                           ##
###############################################################################
###############################################################################
function string_indexof() {

    if [[ "${#1}" == "0" && "${#2}" == "0" ]]; then
        echo "0"
        return
    fi

    local -r strindexof_subpart="${1/${2}*/}"
    if [[ "${strindexof_subpart}" == "${1}" ]]; then
        echo "-1"
        return
    fi

    echo "${#strindexof_subpart}"
}


function string_trim() {

    local tmp="${1}";
    local current_size=-1
    local new_size=0

    while (( current_size != new_size )); do
        current_size=${#tmp}
        tmp="${tmp#[[:space:]]}"
        tmp="${tmp%[[:space:]]}"
        new_size=${#tmp}
    done

    echo "${tmp}"
}


function resolve_library_ldd() {

    for line in `ldd "${1}" | grep -v '\.\.' | grep '/' | grep -v '/jdk/' | cut -d'=' -f2`; do
        if [ "$(string_indexof "${line}" "/")" != "-1" ]; then
            echo $(string_trim "${line}")
        fi
    done
}


function scan_library() {

    JAVA_MODULE_LIST=()

    for library in `resolve_library_ldd "/jdk/bin/java"`
    do
        JAVA_MODULE_LIST+=("${library}")
    done

    for line in `find /jdk/lib/`
    do
        if [ "$(string_indexof "${line}" ".so")" != "-1" ]; then
            for library in `resolve_library_ldd "$(string_trim "${line}")"`
            do
                JAVA_MODULE_LIST+=("${library}")
            done
        fi
    done

    for bin in "${BIN_TO_INCLUDE_LIST[@]}"
    do
        for library in `resolve_library_ldd "${bin}"`
        do
            JAVA_MODULE_LIST+=("${library}")
        done
    done

    printf "%s\n" "${JAVA_MODULE_LIST[@]}" | sort -u
}


function install_tools() {

    apt -y update
    apt -y install binutils wget curl locales libxext6 libx11-6
}


function install_jdk() {

    wget \
        --no-check-certificate          \
        --output-document jdk.tar.gz    \
        --output-file /dev/null         \
        https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.tar.gz
    
    tar -xf jdk.tar.gz
    rm -f jdk.tar.gz
    mv jdk* jdk
}


function build_jre() {

    /jdk/bin/jlink                  \
        --verbose                   \
        --strip-debug               \
        --no-header-files           \
        --no-man-pages              \
        --compress=1                \
        --add-modules ${1}          \
        --module-path /jdk/jmods    \
        --output /tmp/dist/opt/jre
}


function archive_rootfs() {

    rm -f /tmp/rootfs.tar.gz
    tar -cf /tmp/rootfs.tar.gz -C /tmp/dist/ .
}


###############################################################################
###############################################################################
##                                                                           ##
##                               MAIN ENTRY                                  ##
##                                                                           ##
###############################################################################
###############################################################################

# Prepares environment
install_tools
install_jdk
mkdir --parents /tmp/dist/opt


# Copies needed libraries
for line in `scan_library`
do
    cp --parents "${line}" /tmp/dist/
done


# Copies utils
for bin in "${BIN_TO_INCLUDE_LIST[@]}"
do
    cp --parents "${bin}" /tmp/dist/
done


# Build JRE
JAVA_MODULES=$(/jdk/bin/java --list-modules | grep -v 'jdk.incubator' | cut -d'@' -f1 | tr '\n' ',' | sed -z 's/.$//')
build_jre "${JAVA_MODULES}"


# Creates rootfs.tar.gz
archive_rootfs
