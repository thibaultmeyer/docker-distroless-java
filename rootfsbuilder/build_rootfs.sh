#!/bin/env bash


# Settings
JDK_URL="${1}"

BIN_TO_INCLUDE_LIST=(
    "/bin/bash"
    "/bin/sh"
)



# Loads libraries
source "$(dirname "${BASH_SOURCE[0]}")/lib/libminish/libminish.bash"
source "$(dirname "${BASH_SOURCE[0]}")/lib/libinternal.bash"



# Checks settings
if minish_string_isblank "${JDK_URL}"; then
    minish_die 1 "JDK_URL arguments is missing"
fi



# Prepares environment
echo "> Update Debian installation"
apt --assume-yes update > /dev/null 2>&1
    
echo "> Install needed tools"
apt --assume-yes install binutils curl locales libxext6 libx11-6 > /dev/null 2>&1



# Installs JDK
echo "> Download JDK from '${JDK_URL}'"
curl                                                            \
    --silent                                                    \
    --insecure                                                  \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    --output jdk.tar.gz                                         \
    --location "${JDK_URL}"
minish_die_ifnotzero $? "Can't download JDK"

tar -xf jdk.tar.gz
minish_die_ifnotzero $? "Can't extract JDK archive"

rm -f jdk.tar.gz
mv jdk* jdk



# Build JRE
echo "> Build JRE"
#JAVA_MODULES=$(/jdk/bin/java --list-modules | grep -v 'jdk.incubator' | cut -d'@' -f1 | tr '\n' ',' | sed -z 's/.$//')
JAVA_MODULES=$(/jdk/bin/java --list-modules | grep -E '^(jdk.(unsupported)|java).*$' | cut -d'@' -f1 | tr '\n' ',' | sed -z 's/.$//')

/jdk/bin/jlink                      \
    --verbose                       \
    --strip-debug                   \
    --no-header-files               \
    --no-man-pages                  \
    --compress=1                    \
    --add-modules ${JAVA_MODULES}   \
    --module-path /jdk/jmods        \
    --output /tmp/dist/opt/jre
minish_die_ifnotzero $? "Can't build JRE"

echo "> Test JRE"
/tmp/dist/opt/jre/bin/java -version
minish_die_ifnotzero $? "Can't run JRE"



# Create rootfs
echo "> Create rootfs into '/tmp/dist'"
mkdir --parents /tmp/dist/etc
mkdir --parents /tmp/dist/opt

cp --parents /etc/timezone /tmp/dist/
cp /usr/share/zoneinfo/Etc/UTC /tmp/dist/etc/locale

# Copies needed libraries
for line in `scan_library`
do
    cp --parents "${line}" /tmp/dist/
    minish_die_ifnotzero $? "Can't copy library '${line}'"
done

# Copies tools
for bin in "${BIN_TO_INCLUDE_LIST[@]}"
do
    cp --parents "${bin}" /tmp/dist/
    minish_die_ifnotzero $? "Can't copy '${bin}'"
done



# Creates rootfs.tar.gz
echo "> Create 'rootfs.tar.gz' archive"
rm -f /tmp/rootfs.tar.gz
tar -cf /tmp/rootfs.tar.gz -C /tmp/dist/ .
minish_die_ifnotzero $? "Can't create 'rootfs.tar.gz' archive"

echo "> Done!"
