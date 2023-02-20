function scan_library() {

    local -a -x lib_dep_array=()

    for library in `minish_linux_resolvesharedlibraries "/jdk/bin/java"`
    do
        lib_dep_array+=("${library}")
    done

    for line in `find /jdk/lib/`
    do
        if [ "$(minish_string_indexof "${line}" ".so")" != "-1" ]; then
            for library in `minish_linux_resolvesharedlibraries "$(minish_string_trim "${line}")"`
            do
                lib_dep_array+=("${library}")
            done
        fi
    done

    for bin in "${BIN_TO_INCLUDE_LIST[@]}"
    do
        for library in `minish_linux_resolvesharedlibraries "${bin}"`
        do
            lib_dep_array+=("${library}")
        done
    done

    printf "%s\n" "${lib_dep_array[@]}" | sort -u
}
