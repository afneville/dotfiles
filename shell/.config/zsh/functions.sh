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
    else
        tmux new-session -d -s "$1" -c "$2"
    fi
}

custom_tmux_attach() {
    tmux has-session -t "$1" 2>/dev/null
    if [ "$?" != 0 ]; then
        new_tmux_session "$1" "$2"
    fi
    [ -z "$TMUX" ] && tmux attach-session -t "$1" || tmux switch-client -t "$1"
}

pp() {
    choice="$(find -L ~/vcon -mindepth 1 -maxdepth 1 -type d | xargs -n1 | rev | cut -d/ -f1 | rev | fzf_select)"
    if [ -n "$choice" ]; then
        custom_tmux_attach "$choice" ~/vcon/"$choice"
    fi
}

tmp() {
    # if 1 arg, ensure dir exists and attach/start session in it
    if [ -n "$1" ]; then
        [ -f "${HOME}/local/tmp/${1}" ] && return 1
        [ ! -d "${HOME}/local/tmp/${1}" ] && mkdir -p "${HOME}/local/tmp/${1}"
        custom_tmux_attach "$1" ~/local/tmp/"$1"
    else
        choice="$(find -L ~/local/tmp -mindepth 1 -maxdepth 1 -type d | xargs -n1 | rev | cut -d/ -f1 | rev | fzf_select)"
        if [ -n "$choice" ]; then
            custom_tmux_attach "$choice" ~/local/tmp/"$choice"
        fi
    fi
}

tat() {
    tmux has-session 2>/dev/null || (echo "No active sessions!" && return 1)
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
    elif [ -z "$2" ]; then
        custom_tmux_attach "$1" "$(pwd)"
    else
        custom_tmux_attach "$1" "$2"
    fi
}

notes() {
    session_name="site-generator"
    tmux has-session -t "${session_name}" 2>/dev/null && return
    new_tmux_session "${session_name}" "${HOME}/vcon/${session_name}"
    tmux send-keys -t ${session_name}:1.0 "sudo live-server --no-browser --port=80 out" Enter
    tmux split-window -t ${session_name}:1.0 -c "${HOME}/vcon/${session_name}"
    tmux send-keys -t ${session_name}:1.1 "watch-directory.sh src make &" Enter
    tmux send-keys -t ${session_name}:1.1 "watch-directory.sh res make &" Enter
    tmux send-keys -t ${session_name}:1.1 "watch-directory.sh templates make &" Enter
    tmux select-layout -t ${session_name}:1 even-vertical
    sleep 1 && echo "" >"${HOME}/vcon/${session_name}/src/.update"
}
