#!/bin/bash

# custom functions
function spotdl {
    CURRENT=$(pwd)

    python3 -m spotdl "$1" --output ~/sync/tunes/{duration}.{artist}.{title}.{output-ext} --bitrate 128k --lyrics genius
    cd ~/sync/tunes

    LATEST="$(ls -ht | head -n 1)" ; mv "$LATEST" "${LATEST// /.}"
    LATEST="$(ls -ht | head -n 1)" ; mv "$LATEST" "${LATEST// /.}"

    rm -f .spotdl-cache

    cd $CURRENT
}

function upload { curl -# https://shinysocks.net/up -T "$1" -H "name: $1" | cat; }

# environment variables for functional editors
export SDKMAN_DIR="$HOME/.sdkman"
export PATH="~/projects/dots/scripts/:$PATH"
export VISUAL="/home/linuxbrew/.linuxbrew/bin/nvim"
export EDITOR="/home/linuxbrew/.linuxbrew/bin/nvim"
export tunes="/home/shinysocks/sync/tunes/"
export memories="/home/shinysocks/sync/memories/"
export PROMPT_DIRTRIM=2

# prompt styling
l=$(tput setaf 5 bold);b=$(tput dim setaf 4 bold);r=$(tput sgr0);g=$(tput bold setaf 2)
export PS1="\[${l}\][\[${b}\] \w \[${r}${l}\]] \[${g}\]\$ \[${r}\]"

# custom aliases
alias globalprotect='sudo gpclient --fix-openssl connect vpn.msoe.edu'
alias l='ls -Aht'
alias update='sudo apt update -y ; sudo apt upgrade -y; sudo apt autoremove -y ; brew upgrade ; brew cleanup ; brew leaves > ~/projects/dots/brewlist'
alias croc='croc --overwrite --yes'
alias ..='cd ..'
alias rsync='rsync -azP --delete /home/shinysocks/sync/ shinysocks@192.168.0.121:/home/shinysocks/sync/'
alias recentsongs='ls -ht ~/sync/tunes | head -n 15'

# load sdkman & homebrew
export SDKMAN_DIR=$(/home/linuxbrew/.linuxbrew/bin/brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# unlimited history size
HISTSIZE=-1
HISTFILESIZE=-1
