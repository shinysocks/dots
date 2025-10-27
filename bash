#!/usr/bin/env bash

function dl {
    CURRENT=$(pwd)
    cd ~/sync/tunes/ || exit

    uv run yt-dlp "$1" -x --audio-format mp3 -o "%(duration)s.%(artist)s.%(track)s.%(ext)s"

    for _ in {1..5};
    do
        LATEST="$(ls -ht | head -n 1)" ; mv "$LATEST" "${LATEST// /.}";
    done

    cd "$CURRENT" || exit
}

function commit {
    git status &> /dev/null

    if [ $? -eq 0 ]; then

      gum style "$(git branch --show-current)" --foreground="#50C878"
      echo
      git status -s
      git add .

      CHANGES="$(git status -s | wc -l)"
      MESSAGE=$(gum input --prompt "commit: " --placeholder "made changes to $CHANGES files..")

      gum confirm "push $CHANGES files to remote?" --affirmative="send it!" --negative="nevermind" \
      && git commit -q -m "$MESSAGE" && gum spin --title "pushing.." git push || git restore --staged .

    else
      gum style "there's no git repo here" --foreground="#F38BA8"
    fi

    echo done.
}

function passme {
    # TODO: generate a password with pwgen
    # TODO: add encryption for passwords file

    PASSWORDS=~/sync/recovery/passwords 

    INFO=$(sudo -k cat $PASSWORDS | grep -m 1 $1)
    echo -n $INFO | cut -d "|" -f2 | cat
}

function copy_songs_to_nokia {
    IFS=$'\n';

    mkdir -p ~/nokia

    sudo mount -t drvfs D: ~/nokia

    rm -rf ~/nokia/Audio/* && echo "erased current nokia songs"

    for file in $(ls ~/sync/tunes/ -ht | head -n 100)
    do
        cp -v -n ~/sync/tunes/"$file" ~/nokia/Audio/"$file"
    done

    sleep 10
    sudo umount ~/nokia && echo "unmounted nokia"
    rm -rf ~/nokia
}


export tunes="/home/shinysocks/sync/tunes/"
export memories="/home/shinysocks/sync/memories/"

# prompt styling
l=$(tput setaf 5 bold);b=$(tput dim setaf 4 bold);r=$(tput sgr0);g=$(tput bold setaf 2)
export PS1="\[${l}\][\[${b}\] \w \[${r}${l}\]] \[${g}\]\$ \[${r}\]"

# custom aliases
alias globalprotect='sudo gpclient --fix-openssl connect vpn.msoe.edu'
alias l='ls -Aht'
alias croc='croc --overwrite --yes'
alias ..='cd ..'
alias rsync='rsync -azP --delete /home/shinysocks/sync/ shinysocks@pie:/home/shinysocks/sync/'
alias recentsongs='ls -ht ~/sync/tunes | head -n 15'

# unlimited history size
HISTSIZE=-1
HISTFILESIZE=-1
