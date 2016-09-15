#!/bin/bash
#
#  Author: Spacecow
#  Date: 06/08/2016
#  Description:
#  Converts lines of a file in to a python list().


function main() {
    local LIST=
    while getopts 'hl:' OPT; do
        case ${OPT} in
            h)
                printf "${0} [-h] -l PATH\n"
                printf "\t-l PATH: Path to file to read\n"
                exit 0
                ;;
            l)
                if [ ! -f "${OPTARG}" ]; then
                    printf "${0}: File Error: File '${OPTARG}' doesn't exist\n" 1>&2
                    exit 1
                fi
                LIST="${OPTARG}"
                ;;
        esac
    done

    if [ -z ${LIST} ]; then
        printf "${0}: Argument Error: -l PATH flag required\n" 1>&2
        exit 2
    fi

    printf "l = [\n"
    while read LINE; do
        printf "\"${LINE}\",\n"
    done < ${LIST}
    printf "]\n"
}


main ${@}
