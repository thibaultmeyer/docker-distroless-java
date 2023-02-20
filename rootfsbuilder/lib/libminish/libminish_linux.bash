# Resolves required shared object (shared libraries).
#
# Arguments:
#
#   $1 - [IN][REQUIRED] path to program or shared object
#
# Example:
#
#   minish_linux_resolvesharedlibraries "/bin/sh"
function minish_linux_resolvesharedlibraries() {

    for line in `ldd "${1}" | grep -v '\.\.' | grep '/' | grep -v '/jdk/' | cut -d'=' -f2`; do
        if [ "$(minish_string_indexof "${line}" "/")" != "-1" ]; then
            echo $(minish_string_trim "${line}")
        fi
    done
}
