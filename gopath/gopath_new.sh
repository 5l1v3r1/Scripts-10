#!/bin/bash
#
#  Author: Spacecow
#  Date: 13/08/2014
#  Description:
#  A little script that sets up a GOPATH in the user's home directory.


function main() {
    local TESTING=
    local GITHUBACCT=

    while getopts "htg:" OPT; do
        case ${OPT} in
            h)
                printf "${0} [-h] [-t] [-g USERNAME]\n"
                printf "\t-t: Test GOPATH environment once setup\n"
                printf "\t-g USERNAME: Create structure for github account in GOPATH\n"
                exit 0
                ;;
            t)
                TESTING="true"
                ;;
            g)
                GITHUBACCT="${OPTARG}"
                ;;
        esac
    done

    printf "Setting up GOPATH in ${HOME} directory\n"
    printf "Dont forget to add the following to your .bashrc file:\n"
    printf "\tGOPATH=\$HOME/go\n"
    mkdir -p ${HOME}/go/bin ${HOME}/go/pkg ${HOME}/go/src 2>/dev/null

    if [ -n ${GITHUBACCT} ]; then
        printf "Creating path for '${GITHUBACCT}' github account\n"
        mkdir -p ${HOME}/go/src/github.com/${GITHUBACCT}
    fi

    if [ -n ${TESING} ]; then
        printf "Testing GO and GOPATH installation\n"
        go version
        if [ ${?} -ne 0 ]; then
            printf "Go is either not installed or not in \$PATH\n" 1>&2
            exit 1
        else
            mkdir ${HOME}/go/src/gopath_test 2>/dev/null
            touch ${HOME}/go/src/gopath_test/test_run.go
            printf 'package main\nimport "fmt"\nfunc main() { fmt.Println("Hello, world!") }' > ${HOME}/go/src/gopath_test/test_run.go
            go run ${HOME}/go/src/gopath_test/test_run.go
            if [ ${?} -eq 0 ]; then
                printf "Go file compiled and executed correctly\n"
            else
                printf "Go encountered errors during test run, troubleshooting is required\n" 1>&2
            fi
            rm -rf ${HOME}/go/src/gopath_test
        fi
    fi
}


main ${@}
