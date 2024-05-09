# custom functions
function spotdl { ~/.local/bin/spotdl download "$1" --output ~/sync/tunes; }
function host { ssh -fNR 8888:localhost:8888 pie; }

# environment variables for functional editors
export PATH="/home/shinysocks/.local/bin:/home/shinysocks/desktop/bin:$PATH"
export VISUAL="/home/shinysocks/.cargo/bin/hx"
export EDITOR="/home/shinysocks/.cargo/bin/hx"

# custom aliases
alias dots='/usr/bin/git --git-dir=$HOME/projects/dots --work-tree=$HOME'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias update='sudo apt update -y ; sudo apt upgrade -y; sudo apt autoremove -y'
alias ssh="kitty +kitten ssh"
alias croc='croc --overwrite --yes'
alias nmtui='nmcli -p dev wifi rescan ; nmtui'
alias zzz='systemctl suspend ; exit'
alias ..='cd ..'

eval "$(starship init bash)"
source "$HOME/.cargo/env"

# default .bashrc stuffs
case $- in
    *i*) ;;
      *) return;;
esac
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s checkwinsize
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color|*-256color|xterm-kitty) color_prompt=yes;;
esac
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

. "$HOME/.cargo/env"
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
