#!/bin/bash
#
#  Author: Spacecow
#  Date: 13/08/2014
#  Description:
#  Custom OSX Setup script (fork of thoughtbot/laptop).
#  Turn your OSX install in to MY perfect development machine.
#  Feel free to fork and customize for your own preferences.
#
#  Turns my MBA into a super duper administration pooper.
#  Custom fork for myself, but feel free to copy :)


fancy_echo() {
    printf "\n%b\n" "${1}"
}


#########################
##  Setting up ZSHell  ##
#########################

append_to_zshrc() {
    local text="${1}" zshrc
    local skip_new_line="${2}"

    if [[ -w "${HOME}/.zshrc.local" ]]; then
        zshrc="${HOME}/.zshrc.local"
    else
        zshrc="${HOME}/.zshrc"
    fi

    if ! grep -Fqs "${text}" "${zshrc}"; then
        if (( skip_new_line )); then
            printf "%s\n" "${text}" >> "${zshrc}"
        else
            printf "\n%s\n" "${text}" >> "${zshrc}"
        fi
    fi
}


trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT
set -e

if [[ ! -d "${HOME}/.bin/" ]]; then
    mkdir "${HOME}/.bin"
fi

if [ ! -f "${HOME}/.zshrc" ]; then
    touch "${HOME}/.zshrc"
fi

fancy_echo "Changing your shell to zsh ..."
chsh -s $(which zsh)


#########################
## Setting up Homebrew ##
#########################

brew_install_or_upgrade() {
    if brew_is_installed "${1}"; then
        if brew_is_upgradable "${1}"; then
            brew upgrade "${@}"
        fi
    else
        brew install "${@}"
    fi
}


brew_is_installed() {
    local NAME=$(brew_expand_alias "${1}")
    brew list -1 | grep -Fqx "${NAME}"
}


brew_is_upgradable() {
    local NAME=$(brew_expand_alias "${1}")

    brew outdated --quiet "${NAME}" >/dev/null
    [[ ${?} -ne 0 ]]
}


brew_expand_alias() {
    brew info "${1}" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}


brew_launchctl_restart() {
    local NAME=$(brew_expand_alias "${1}")
    local DOMAIN="homebrew.mxcl.${NAME}"
    local PLIST="${DOMAIN}.plist"

    mkdir -p ~/Library/LaunchAgents
    ln -sfv /usr/local/opt/${NAME}/${PLIST} ~/Library/LaunchAgents

    if launchctl list | grep -q ${DOMAIN}; then
        launchctl unload ~/Library/LaunchAgents/${PLIST} >/dev/null
    fi
    launchctl load ~/Library/LaunchAgents/${PLIST} >/dev/null
}

if [[ -f /etc/zshenv ]]; then
    fancy_echo "Fixing OSX zsh environment bug ..."
    sudo mv /etc/{zshenv,zshrc}
fi

if ! command -v brew >/dev/null; then
    fancy_echo "Installing Homebrew, a good OS X package manager ..."
    ruby <(curl -fsS https://raw.githubusercontent.com/Homebrew/install/master/install)

    append_to_zshrc '# recommended by brew doctor'
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH:$HOME/.bin"' 1
    export PATH="/usr/local/bin:${PATH}"
else
    fancy_echo "Homebrew already installed. Skipping ..."
fi


###############################
## Installing extra software ##
###############################

fancy_echo "Updating Homebrew formulas ..."
brew update

fancy_echo "Installing vim from Homebrew to get the latest version ..."
brew_install_or_upgrade 'vim'

fancy_echo "Installing ctags, to index files for vim tab completion of methods, classes, variables ..."
brew_install_or_upgrade 'ctags'

fancy_echo "Installing tmux, to save project state and switch between projects ..."
brew_install_or_upgrade 'tmux'

fancy_echo "Installing lua, a scripting language with a small embeddable vm ..."
brew_install_or_upgrade 'lua'

fancy_echo "Installing mono, an open source .Net implementation ..."
brew_install_or_upgrade 'mono'

fancy_echo "Installing nmap, the standard in port scanning tools ..."
brew_install_or_upgrade 'nmap'

fancy_echo "Installing radare2, a set of useful tools for reverse engineering ..."
brew_install_or_upgrade 'radare2'

fancy_echo "Installing python3, to get you to use the standard version of python ..."
brew_install_or_upgrade 'python3'

fancy_echo "Installing wget, to get things from the w ..."
brew_install_or_upgrade 'wget'

fancy_echo "Installing weechat, an IRC client to talk to strangers on the internet ..."
brew_install_or_upgrade 'weechat'

fancy_echo "Installing lynx, a CLI browser for using the web while looking l337..."
brew_install_or_upgrade 'lynx'

fancy_echo "Installing nginx, the best web server no money can buy..."
brew_install_or_upgrade 'nginx'

fancy_echo "Installing sqlite, a small portable database system..."
brew_install_or_upgrade 'sqlite'

fancy_echo "Installing dos2unix, a tool to convert text files between DOS and UNIX LC..."
brew_install_or_upgrade 'dos2unix'

fancy_echo "Installing bpython3, an improved python3 interpreter"
brew_install_or_upgrade 'bpython3'

pip3 install boltons requests flask python-nmap install pcapy
