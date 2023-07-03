#!/bin/sh

alias fzf_select="fzf --height=20 --border=none --reverse --no-separator --ansi --color=16"

fd() {
    choice="$(find ~/* \( -name '.git' -o -name 'env' -o -wholename '/home/alex/cloud' \) -prune -false -o -type d | fzf_select)"
    if [ -n "$choice" ]; then
        cd "$choice" || exit
    fi
}

new_tmux_session() {
    if [ -z "$2" ]; then
        tmux new-session -d -s "$1"
        # tmux new-window -d -n 'build' -t "$1"
        # tmux new-window -d -n 'vcs' -t "$1"
    else
        tmux new-session -d -s "$1" -c "$2"
        # tmux new-window -d -n 'build' -t "$1" -c "$2"
        # tmux new-window -d -n 'vcs' -t "$1" -c "$2"
    fi
    tmux rename-window -t "${1}":1 'main'
}

custom_tmux_attach() {
    tmux has-session -t "$1" 2>/dev/null
    if [ "$?" != 0 ]; then
        new_tmux_session "$1" "$2"
    fi
    [ -z "$TMUX" ] && tmux attach-session -t "$1" || tmux switch-client -t "$1"
}

pp() {
    choice="$(find ~/vcon -mindepth 1 -maxdepth 1 -type d | xargs -n1 | rev | cut -d/ -f1 | rev | fzf_select)"
    if [ -n "$choice" ]; then
        custom_tmux_attach "$choice" ~/vcon/"$choice"
    fi
}

tat() {
    tmux has-session 2> /dev/null || (echo "No active sessions!" && return 1)
    if [ -n "$1" ]; then
        tmux has-session -t "$1" 2>/dev/null && choice=$1 || return 1
    else
        choice=$(tmux list-sessions | cut -d " " -f1 | cut -d ":" -f1 | fzf_select)
    fi
    if [ -n "$choice" ]; then
        [ -z "$TMUX" ] && tmux attach-session -t "$choice" || tmux switch-client -t "$choice"
    fi
}

tnew() {
    if [ -z "$1" ]; then
        custom_tmux_attach "$(basename "$(pwd)")" "$(pwd)"
    else
        custom_tmux_attach "$1" "$(pwd)"
    fi
}
