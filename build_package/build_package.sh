#!/bin/bash
#
#  Author:
#  Date:
#  Description:
#  Converts files to DOS format and builds an archive.


function main() {
    local TARGET=
    while getopts 'ht:' OPT; do
        case ${OPT} in
            h)
                printf "${0} [-h] -t PATH\n"
                printf "\t-t PATH: Path to folder to achive\n"
                exit 0
                ;;
            t)
                if [ ! -d ${OPTARG} ]; then
                    printf "${0}: IOError: ${OPTARG} not a valid directory\n" 1>&2
                    exit 3
                fi
                TARGET="${OPTARG}"
                ;;
        esac
    done

    local FILES="$(find ${TARGET} -type f -print 2>/dev/null)"
    if [ "${FILES}" ]; then
        for FILE in ${FILES}; do
            unix2dos ${FILE}
        done
        zip -r "${TARGET}.zip" "${TARGET}"
        #tar -czPf "${TARGET}.tar.gz" ${TARGET}
        for FILE in ${FILES}; do
            # Im too lazy to do this in a cleaner way
            dos2unix ${FILE}
        done
    else
        printf "${0}: IOError: No files found in ${TARGET}\n" 1>&2
    fi
}


main ${@}
