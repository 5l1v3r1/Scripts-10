#!/bin/sh -u
#
# Author: Jacques Pharand
# Date: 13/08/2014
# License: The MIT License (MIT)
# Description:
#   A little ugly duckly script that sets up a GOPATH in the user's home directory.
#   - Creates $HOME/go, $HOME/go/bin, $HOME/go/pkg and $HOME/go/src
#   - Attempts to add $GOPATH to users shell config file
#   - Offers to create a github directory under $GOPATH/src
#   - Finally tests whether go is properly installed and will run a simple test program


if [ $# -gt 0 ]; then
    echo "$0: Set up a $GOPATH on a Unix workstation."
    exit 1
fi

echo "[*] Setting up GOPATH in $HOME directory"  # Creating directories for GOPATH under $HOME
mkdir $HOME/go 2>/dev/null
mkdir $HOME/go/bin 2>/dev/null
mkdir $HOME/go/pkg 2>/dev/null
mkdir $HOME/go/src 2>/dev/null

if [ $SHELL = '/bin/bash' ]; then  # Attempting to add GOPATH variable to shell config file.
    if [ -f "$HOME/.bashrc" ]; then
        echo 'GOPATH=$HOME/go' >> $HOME/.bashrc
    else
        echo '[!] Could not find .bashrc, GOPATH variable must be added manually'
        sleep 2
    fi
elif [ $SHELL = '/bin/zsh' ]; then
    if [ -f "$HOME/.zshrc" ]; then
        echo 'GOPATH=$HOME/go' >> $HOME/.zshrc
    else
        echo '[!] Could not find .zshrc, GOPATH variable must be added manually'
        sleep 2
    fi
else
    echo "[!] Unknown shell found in \$SHELL, GOPATH variable must be added manually."
    sleep 2
fi

read -p "Would you like to add a github account to your GOPATH? [y/N] " github  # Offer to create a github directory for user's account

if [ $github = 'Y' -o $github = 'y' ]; then
    read -p "Enter your github user account name: " acct
    echo "[*] Creating directory $GOPATH/src/github.com/$acct"
    sleep 2
    mkdir -p $HOME/go/src/github.com/$acct
else
    echo "[!] Skipping account creation"
    sleep 2
fi

echo "[*] Testing Go and GOPATH installation"  # Attempt to test go installation and compile a test program
sleep 2
go version 1>/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "[!] Go is either not installed or not in PATH"
    sleep 2
else
    mkdir $HOME/go/src/helloworld 2>/dev/null
    touch $HOME/go/src/helloworld/hello.go 2>/dev/null
    echo 'package main\n' > $HOME/go/src/helloworld/hello.go
    echo 'import "fmt"\n' >> $HOME/go/src/helloworld/hello.go
    echo 'func main() { fmt.Println("Hello, world!") }' >> $HOME/go/src/helloworld/hello.go
    go run $HOME/go/src/helloworld/hello.go 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "[*] Go file compiled and excecuted correctly"
        echo "[*] Happy coding Gopher!"
        sleep 2
    else
        echo "[!] Go encounterd errors during execution"
        echo "[!] Manual troubleshooting is required"
        sleep 2
    fi
fi
