#!/bin/sh

function fd() {
    choice=$(echo "$(find ~/* \( -name '.git' -o -name 'env' \) -prune -false -o -type d)" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [[ ! -z $choice ]]; then
        pushd $choice
    fi
}

function ff(){
    choice=$(echo "$(find ~/* \( -name '.git' -o -name 'env' \) -prune -false -o -type f)" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [[ ! -z "$choice" ]]; then
        # pushd $(dirname $choice)
        nvim $choice
        # popd
    fi
}

function fff(){
    choice=$(echo "$(find ./* \( -name '.git' -o -name 'env' \) -prune -false -o -type f)" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [[ ! -z "$choice" ]]; then
        nvim $choice
    fi
}

function fdd() {
    choice=$(echo "$(find ./* \( -name '.git' -o -name 'env' \) -prune -false -o -type d)" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [[ ! -z $choice ]]; then
        pushd $choice
    fi
}

function new_tmux_session() {
    # create the session
    if [[ -z "$2" ]]
    then
        tmux new-session -d -s $1
        tmux new-window -d -n 'build' -t $1
        tmux new-window -d -n 'vcs' -t $1
    else
        tmux new-session -d -s $1 -c $(echo "$2")
        tmux new-window -d -n 'build' -t $1 -c $(echo "$2")
        tmux new-window -d -n 'vcs' -t $1 -c $(echo "$2")
    fi
    tmux rename-window -t ${1}:1 'edit'
}

function pp () {
    choice=$(echo "$(find ~/vcon -mindepth 1 -maxdepth 1 -type d | xargs -n1 | rev | cut -d/ -f1 | rev)" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16) 
    echo "choice: $choice"
    if [[ ! -z $choice ]] # if a choice was made ...
    then
        tmux has-session -t $choice 2>/dev/null
        if [ $? != 0 ] # if the session does not exist ...
        then
            # create a new tmux session
            echo "session does not exist"
            new_tmux_session $choice ~/vcon/$choice
        fi
        # connect to the session
        if [[ -z "$TMUX" ]] # if not in a tmux session
        then
            tmux attach-session -t $choice
        else
            tmux switch-client -t $choice
        fi
        fi
    }
