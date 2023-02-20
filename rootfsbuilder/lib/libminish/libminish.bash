__LIBMINISH_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"

for script_fullpath in "${__LIBMINISH_DIRECTORY}"/*.bash; do

    __minish_lib_filename="$(basename "${script_fullpath}")"
    if [[ "${__minish_lib_filename}" == "libminish.bash" ]]; then
        unset __minish_lib_filename
        continue
    fi

    # shellcheck disable=SC1090
    source "${__LIBMINISH_DIRECTORY}/${__minish_lib_filename}" || exit 1
    unset __minish_lib_filename
done

unset __LIBMINISH_DIRECTORY
