#!/bin/sh

alias fzf_select="fzf --height=20 --border=none --reverse --no-separator --ansi --color=16"

fd() {
    choice="$(find ~/* \( -name '.git' -o -name 'env' \) -prune -false -o -type d | fzf_select)"
    if [ -n "$choice" ]; then
        cd "$choice" || exit
    fi
}

ff() {
    choice="$(find ~/* \( -name '.git' -o -name 'env' \) -prune -false -o -type f | fzf_select)"
    if [ -n "$choice" ]; then
        # pushd $(dirname $choice)
        nvim "$choice"
        # popd
    fi
}

fff() {
    choice="$(find ./* \( -name '.git' -o -name 'env' \) -prune -false -o -type f | fzf_select)"
    if [ -n "$choice" ]; then
        nvim "$choice"
    fi
}

fdd() {
    choice="$(find ./* \( -name '.git' -o -name 'env' \) -prune -false -o -type d | fzf_select)"
    if [ -b "$choice" ]; then
        cd "$choice" || exit
    fi
}

new_tmux_session() {
    echo "creating a new session"
    # create the session
    if [ -z "$2" ]; then
        tmux new-session -d -s "$1"
        tmux new-window -d -n 'build' -t "$1"
        tmux new-window -d -n 'vcs' -t "$1"
    else
        tmux new-session -d -s "$1" -c "$2"
        tmux new-window -d -n 'build' -t "$1" -c "$2"
        tmux new-window -d -n 'vcs' -t "$1" -c "$2"
    fi
    tmux rename-window -t "${1}":1 'edit'
}

custom_tmux_attach() {
    if [ -n "$2" ]; then # if passed two agruments
        tmux has-session -t "$1" 2> /dev/null
        # if ! tmux has-session -t "$1" 2>/dev/null; then
        if [ "$?" != 0 ]; then # if the session does not exist ...
            # create a new tmux session
            # echo "session does not exist"
            echo "about to create a new session"
            new_tmux_session "$1" "$2"
        fi
        # connect to the session
        if [ -z "$TMUX" ]; then # if not in a tmux session
            tmux attach-session -t "$1"
        else
            tmux switch-client -t "$1"
        fi
    fi
}

pp() {
    choice="$(find ~/vcon -mindepth 1 -maxdepth 1 -type d | xargs -n1 | rev | cut -d/ -f1 | rev | fzf_select)"
    custom_tmux_attach "$choice" ~/vcon/"$choice"
}

tat() {
    choice=$(tmux list-sessions | cut -d " " -f1 | cut -d ":" -f1 | fzf_select)
    if [ -n "$choice" ]; then   # if a choice was made ...
        if [ -z "$TMUX" ]; then # if not in a tmux session
            tmux attach-session -t "$choice"
        else
            tmux switch-client -t "$choice"
        fi
    fi
}

tnew() {
    if [ -z "$1" ]; then
        custom_tmux_attach "$(basename "$(pwd)")" "$(pwd)"
    else
        custom_tmux_attach "$1" "$(pwd)"
    fi
}
