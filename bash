#!/bin/bash

# custom functions
function spotdl { python3 -m spotdl "$1" --output ~/sync/archive/tunes; }
function upload { curl -# https://shinysocks.net/up -T "$1" -H "name: $1" | cat; }
function vim { nvim $@; }

# environment variables for functional editors
export SDKMAN_DIR="$HOME/.sdkman"
export PATH="/home/shinysocks/.local/bin:/usr/local/texlive/2024/bin/x86_64-linux$PATH"
export VISUAL="/home/linuxbrew/.linuxbrew/bin/nvim"
export EDITOR="/home/linuxbrew/.linuxbrew/bin/nvim"
export tunes="/home/shinysocks/sync/archive/tunes/"
export memories="/home/shinysocks/sync/archive/memories/"
export PROMPT_DIRTRIM=2

# prompt styling
l=$(tput setaf 5 bold);b=$(tput dim setaf 4 bold);r=$(tput sgr0);g=$(tput bold setaf 2)
export PS1="\[${l}[${b}\] \w \[${r}${l}] ${g}\$ ${r}\]"

# custom aliases
alias globalprotect='sudo gpclient --fix-openssl connect vpn.msoe.edu'
alias dots='/usr/bin/git --git-dir=$HOME/projects/dots --work-tree=$HOME'
alias l='ls -1Aht'
alias update='sudo apt update -y ; sudo apt upgrade -y; sudo apt autoremove -y ; brew upgrade ; brew cleanup ; brew leaves > ~/projects/dots/brewlist'
alias ssh="kitty +kitten ssh"
alias croc='croc --overwrite --yes'
alias ..='cd ..'

# load sdkman & homebrew
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# unlimited history size
HISTSIZE=-1
HISTFILESIZE=-1

echo -e "$(tput setaf 3 bold)$USER$(tput setaf 1).$(tput setaf 4)$HOSTNAME$(tput sgr0)\n"
