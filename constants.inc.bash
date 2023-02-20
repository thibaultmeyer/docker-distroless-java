ARCHITECTURE="$(uname -m)"
if [ "${ARCHITECTURE}" == "x86_64" ]
then
    CURRENT_PLATFORM="PLATFORM_AMD64"
elif [ "${ARCHITECTURE}" == "arm64" ]
then
    CURRENT_PLATFORM="PLATFORM_ARM64_V8"
else
    CURRENT_PLATFORM=""
fi


declare -A PLATFORM
PLATFORM[PLATFORM_AMD64]="linux/amd64"
PLATFORM[PLATFORM_ARM64_V8]="linux/arm64/v8"

declare -A PLAT_TAG
PLAT_TAG[PLATFORM_AMD64]="linux-amd64"
PLAT_TAG[PLATFORM_ARM64_V8]="linux-arm64v8"

declare -A OPENJDK_17_0_2
OPENJDK_17_0_2[LATEST]="true"
OPENJDK_17_0_2[VERSION]="17.0.2"
OPENJDK_17_0_2[VENDOR]="openjdk"
OPENJDK_17_0_2[PLATFORM_AMD64]="https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz"
OPENJDK_17_0_2[PLATFORM_ARM64_V8]="https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-aarch64_bin.tar.gz"

declare -A OPENJDK_19_0_2
OPENJDK_19_0_2[LATEST]="true"
OPENJDK_19_0_2[VERSION]="19.0.2"
OPENJDK_19_0_2[VENDOR]="openjdk"
OPENJDK_19_0_2[PLATFORM_AMD64]="https://download.java.net/java/GA/jdk19.0.2/fdb695a9d9064ad6b064dc6df578380c/7/GPL/openjdk-19.0.2_linux-x64_bin.tar.gz"
OPENJDK_19_0_2[PLATFORM_ARM64_V8]="https://download.java.net/java/GA/jdk19.0.2/fdb695a9d9064ad6b064dc6df578380c/7/GPL/openjdk-19.0.2_linux-aarch64_bin.tar.gz"

declare -A ORACLE_17_0_6
ORACLE_17_0_6[LATEST]="true"
ORACLE_17_0_6[VERSION]="17.0.6"
ORACLE_17_0_6[VENDOR]="oracle"
ORACLE_17_0_6[PLATFORM_AMD64]="https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz"
ORACLE_17_0_6[PLATFORM_ARM64_V8]="https://download.oracle.com/java/17/latest/jdk-17_linux-aarch64_bin.tar.gz"

declare -A ORACLE_19_0_2
ORACLE_19_0_2[LATEST]="true"
ORACLE_19_0_2[VERSION]="19.0.2"
ORACLE_19_0_2[VENDOR]="oracle"
ORACLE_19_0_2[PLATFORM_AMD64]="https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.tar.gz"
ORACLE_19_0_2[PLATFORM_ARM64_V8]="https://download.oracle.com/java/19/latest/jdk-19_linux-aarch64_bin.tar.gz"


JDK_LIST=(
    OPENJDK_17_0_2
    OPENJDK_19_0_2
    ORACLE_17_0_6
    ORACLE_19_0_2
)
