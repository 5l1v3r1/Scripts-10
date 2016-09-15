#!/bin/bash
#
#  Author:  Spacecow
#  Date:    19/10/2014
#  Description:
#  Manage a local mirror of RFCs from rfc-editor.org using rsync.
#  Search through them by number and view using less.
#  Sort of like man pages for RFCs.


# Location to store local RFC copies. (Recommend Changing This)
RFC_STORAGE="/tmp/my-rfc-mirror"

# Update our local RFC cache
function update_rfcs() {
    printf "[   OK   ]  Updating local RFC mirror. This may take a while!\n"
    rsync -avz --delete ftp.rfc-editor.org::rfcs-text-only "${RFC_STORAGE}"

    if [ ${?} -ne 0 ]; then
        printf "[  FAIL  ]  Could not update mirror.\n" 1>&2
        exit 2
    else
        printf "[   OK   ]  RFC update was successful.\n"
    fi
}

# Search for a specific RFC file locally
function search_rfcs() {
    local RFC_NUM="$(echo "${1}" | egrep '^\d+$')"
    local MATCH="rfc${1}.txt"

    if [ -z "${RFC_NUM}" ]; then
        printf "${0}: Argument Error: RFC number must only be digits\n" 1>&2
        exit 3
    fi

    for FILE in ${RFC_STORAGE}/*; do
        if [ "${FILE}" = "${RFC_STORAGE}/${MATCH}" ]; then
            less "${FILE}"
        fi
    done
}

function main() {
    local UPDATE=
    local SERIAL=
    while getopts 'hur:' OPT; do
        case ${OPT} in
            h)
                printf "${0} [-h] [-u] -r SERIAL\n"
                printf "\t-u: Update local RFC mirror\n"
                printf "\n-r SERIAL: Serial number of RFC to lookup\n"
                exit 0
                ;;
            u)
                UPDATE='true'
                ;;
            r)
                SERIAL="${OPTARG}"
                ;;
        esac
    done

    if [ ! -d "${RFC_STORAGE}" ]; then
        printf "[  Fail  ]  Could not find local RFC mirror: update local mirror\n" 1>&2
        exit 1
    fi

    if [ -n ${UPDATE} ]; then
        update_rfcs
    fi

    if [ -n ${SERIAL} ]; then
        search_rfcs "${SERIAL}"
    fi
}


main ${@}
