# Returns the index within a string of the first occurrence of the specified string.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] Sentence in which search given element
#   $2 - [IN][REQUIRED] substring or character to search
#
# Example:
#
#   minish_string_indexof "wo" "hello world"
function minish_string_indexof() {

    if [[ "${#1}" == "0" && "${#2}" == "0" ]]; then
        echo "0"
        return
    fi

    local -r minish_strindexof_subpart="${1/${2}*/}"
    if [[ "${minish_strindexof_subpart}" == "${1}" ]]; then
        echo "-1"
        return
    fi

    echo "${#minish_strindexof_subpart}"
}


# Returns the length of a string.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String for which to get the length
#
# Example:
#
#   minish_string_length "hello world"
function minish_string_length() {

    echo "${#1}"
}


# Removes leading and trailing whitespaces.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to trim
#
# Example:
#
#   minish_string_trim "  hello world  "
function minish_string_trim() {

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


# Removes leading whitespaces.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to trim
#
# Example:
#
#   minish_string_ltrim "  hello world"
function minish_string_ltrim() {

    local tmp="${1}";
    local current_size=-1
    local new_size=0

    while (( current_size != new_size )); do
        current_size=${#tmp}
        tmp="${tmp#[[:space:]]}"
        new_size=${#tmp}
    done

    echo "${tmp}"
}


# Removes trailing whitespaces.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to trim
#
# Example:
#
#   minish_string_rtrim "hello world  "
function minish_string_rtrim() {

    local tmp="${1}";
    local current_size=-1
    local new_size=0

    while (( current_size != new_size )); do
        current_size=${#tmp}
        tmp="${tmp%[[:space:]]}"
        new_size=${#tmp}
    done

    echo "${tmp}"
}


# Capitalizes the first letter of each word.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to capitalize
#
# Example:
#
#   minish_string_capitalize "hello world"
function minish_string_capitalize() {

    local -r minish_strcap_lower="${1,,}"
    local minish_strcap_tmp=""
    local minish_strcap_need_uppercase=true

    for (( idx = 0; idx < ${#minish_strcap_lower}; idx++ )); do
        if [[ ${minish_strcap_need_uppercase} == true ]]; then
            minish_strcap_tmp="${minish_strcap_tmp}$(minish_string_uppercase "${minish_strcap_lower:${idx}:1}")"
            minish_strcap_need_uppercase=false
        else
            minish_strcap_tmp="${minish_strcap_tmp}${minish_strcap_lower:${idx}:1}"
        fi

        if [[ "${minish_strcap_lower:${idx}:1}" == " " ]]; then
            minish_strcap_need_uppercase=true
        fi
    done

    echo "${minish_strcap_tmp}"
}


# Converts a string to lower case letters.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to convert
#
# Example:
#
#   minish_string_lowercase "HELLO WORLD"
function minish_string_lowercase() {

    echo "${1,,}"
}


# Converts a string to upper case letters.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to convert
#
# Example:
#
#   minish_string_uppercase "hello world"
function minish_string_uppercase() {

    echo "${1^^}"
}


# Reverses a string.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to reverse
#
# Example:
#
#   minish_string_reverse "hello world"
function minish_string_reverse() {

    local rev=""

    for (( idx = 0; idx < ${#1}; idx++ )); do
        rev="${rev}${1:~idx:1}"
    done

    echo "$rev"
}


# Checks if a string ends with the specified suffix.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to test
#   $2 - [IN][REQUIRED] Suffix
#
# Example:
#
#   if minish_string_endswith "hello world" "orld"; then
#       echo "Yes"
#   fi
function minish_string_endswith() {

    [[ "${1}" == *"${2}" ]]
}


# Checks if a string starts with the specified prefix.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to test
#   $2 - [IN][REQUIRED] Prefix
#
# Example:
#
#   if minish_string_startswith "hello world" "hell"; then
#       echo "Yes"
#   fi
function minish_string_startswith() {

    [[ "${1}" == "${2}"* ]]
}


# Replaces all substring in a string that math the given content.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to modify
#   $2 - [IN][REQUIRED] Content to replace
#   $3 - [IN][REQUIRED] New content
#
# Example:
#
#   minish_string_replace "hello world" "world" "universe"
function minish_string_replace() {

    echo "${1//${2}/${3}}"
}


# Extracts the substring of the given string at the given start position with the given length.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to take a substring from
#   $2 - [IN][REQUIRED] Starting position
#   $3 - [IN][OPTIONAL] Length of string to extract
#
# Example:
#
#   minish_string_substr "hello world" 0 5
#   minish_string_substr "hello world" 6
function minish_string_substr() {

    if [[ -z "${3}" ]]; then
        echo "${1:${2}}"
    else
        echo "${1:${2}:${3}}"
    fi
}


# Checks if the given string is empty.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to check
#
# Example:
#
#   if minish_string_isempty ""; then
#       echo "EMPTY"
#   fi
function minish_string_isempty() {

    [[ "${1}" == "" ]]
}


# Checks if the given string is blank.
#
# Arguments:
#
#   $1 - [IN][REQUIRED] String to check
#
# Example:
#
#   if minish_string_isblank ""; then
#       echo "BLANK"
#   fi
#
#   if minish_string_isblank "   "; then
#       echo "BLANK"
#   fi
function minish_string_isblank() {

    [[ "${1}" == "" ]] || [[ "${1}" =~ ^[[:space:]]+$ ]]
}
