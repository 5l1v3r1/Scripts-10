#!/bin/bash
#
#  Author:
#  Date:
#  Description:
#  Authomatically sets up my Linux environment


function main() {
    while getopts 'h' OPT; do
        case ${OPT} in
            h)
                printf ""
                exit 0
                ;;
        esac
    done

    printf "[+] Creating ${HOME}/bin directory\n"
    if [ -d ${HOME}/bin ]; then
        printf "[-] Folder already exists\n"
    else
        mkdir ${HOME}/bin
    fi
    printf "[*] Remember to add the following line to your shell config\n"
    printf "    PATH=\$PATH:\$HOME/bin"

    printf "[+] Installing tools for firmware RE\n"
    apt-get install -y squashfs-tools radare2 binwalk qemu clang lldb

}


main ${@}
