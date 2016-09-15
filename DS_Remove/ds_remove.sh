#!/bin/bash
#
#  Author: Spacecow
#  Date: 06/08/2016
#  Description:
#  Recursively delete all .DS_Store files from a directory structure


function main() {
    local DIRECTORY=
    while getopts 'hd:' OPT; do
        case ${OPT} in
            h)
                printf "${0} [-h] -d DIRECTORY\n"
                printf "\t-d DIRECTORY: Directory to purge of .DS_Store files\n"
                exit 0
                ;;
            d)
                if [ ! -d "${OPTARG}" ]; then
                    printf "${0}: Directory Error: Directory '${OPTARG}' doesn't exist\n" 1>&2
                    exit 1
                fi
                DIRECTORY="${OPTARG}"
                ;;
        esac
    done

    if [ -n ${DIRECTORY} ]; then
        local FILES=($(find "${DIRECTORY}" -type f -name '.DS_Store' -print))
        if [ -n ${FILES} ]; then
            for FILE in "${FILES}"; do
                rm -f "${FILE}"
            done
        fi
    fi
}


main ${@}
