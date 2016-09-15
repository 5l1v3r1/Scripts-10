#!/bin/bash
#
#  Author: Spacecow
#  Date: 22/07/2016
#  Description:
#  Read list of domains and perform whois requests on them


function main() {

    local target_list=
    local output_dir='results/'
    while getopts 'ht:' OPT; do
        case ${OPT} in
            t)
                target_list=${OPTARG}
                ;;
            h)
                printf "${0} [-h] -t TARGETS\n"
                exit 0
                ;;
        esac
    done

    if [ -z ${target_list} ]; then
        printf "${0}: No target list specified: Please provide file with -t\n" 1>&2
        exit 1
    fi

    if [ ! -f ${target_list} ]; then
        printf "${0}: Target list doesn't exist: ${target_list}\n" 1>&2
        exit 2
    fi

    if [ ! -d ${output_dir} ]; then
        mkdir -p ${output_dir}
    fi

    for domain in $(cat ${target_list}); do
        printf "[+] Searching whois record for ${domain}\n"
        whois ${domain} > "${output_dir}${domain}.whois" 2>&1
        sleep 5
    done

}


main ${@}
