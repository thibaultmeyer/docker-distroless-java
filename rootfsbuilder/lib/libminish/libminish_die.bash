# Terminates current execution with an error message.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] Value passed to 'exit' instruction
#   $2 - [IN][REQUIRED] Message to display on the error message
#   $3 - [IN][OPTIONAL] Caller information
function minish_die() {

    local -r caller_file=$(echo "${3:-$(caller 0)}" | cut -d' ' -f3)
    local -r caller_function=$(echo "${3:-$(caller 0)}" | cut -d' ' -f2)
    local -r caller_line=$(echo "${3:-$(caller 0)}" | cut -d' ' -f1)

    echo "[ERROR] ${2}" 1>&2
    echo "[ERROR] ret_code=${1} file=${caller_file} function=${caller_function} line=${caller_line}" 1>&2
    exit "${1}"
}


# Terminates current execution with an error message if
# value of the first argument is not equal to zero.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] Value to test
#   $2 - [IN][REQUIRED] Message to display on the error message
#
function minish_die_ifnotzero() {

    [[ "${1}" != "0" ]] && minish_die "${1}" "${2}" "$(caller 0)"
}


# Terminates current execution with an error message if
# value of the first argument is equal to zero.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] Value to test
#   $2 - [IN][REQUIRED] Message to display on the error message
#
function minish_die_ifzero() {

    [[ "${1}" == "0" ]] && minish_die "${1}" "${2}" "$(caller 0)"
}
