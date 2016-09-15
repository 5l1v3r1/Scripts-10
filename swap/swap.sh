#!/bin/bash
#
#  Author: Spacecow
#  Date: 04/05/2016
#  Description:
#  Swap the contents of two files.


function main() {

    if [ ${#} -ne 2 ]; then
        printf "${0}: Argument Error: Incorrect amount of arguments\n" 1>&2
        printf "${0} [-h] FILE1 FILE2\n"
        exit 1
    fi

    if [ ! -f "${1}" ]; then
        printf "${0}: File Error: File 1 does not exist\n" 1>&2
        exit 2
    elif [ ! -f "${2}" ]; then
        printf "${0}: File Error: File 2 does not exist\n" 1>&2
        exit 3
    fi

    FILE_L="${1}"
    FILE_R="${2}"
    touch '_temp.tmp'

    mv "${FILE_R}" "_temp.tmp"
    mv "${FILE_L}" "${FILE_R}"
    mv "_temp.tmp" "${FILE_L}"
}

main ${@}
