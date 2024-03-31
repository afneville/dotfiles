#!/bin/sh

alias fzf_select="fzf --height=20 --border=none --reverse --no-separator --ansi --color=16"

fd() {
    choice="$(find ~/* \( -name '.git' -o -name 'env' -o -wholename '/home/alex/cloud' \) -prune -false -o -type d | fzf_select)"
    if [ -n "$choice" ]; then
        cd "$choice" || exit
    fi
}

tmux_create_session() {
    if [ -z "$2" ]; then
        tmux new-session -d -s "$1"
    else
        tmux new-session -d -s "$1" -c "$2"
    fi
}

tmux_create_and_attach() {
    if [ "0" = "$(tmux list-session | cut -d':' -f1 | grep "^${1}$" | wc -l)" ]; then
        tmux_create_session "$1" "$2"
    fi
    [ -z "$TMUX" ] && tmux attach-session -t "$1" || tmux switch-client -t "$1"
}

pp() {
    all_repos="$(find -L ~/vcon -mindepth 2 -maxdepth 2 -type d)"
    if [ -n "$1" ]; then
        matches="$(echo "${all_repos}" | grep -i "${1}")"
        if [ "1" = "$(echo "${matches}" | wc -l)" -a -n "${matches}" ]; then
            tmux_create_and_attach "$(basename "${matches}")" "${matches}"
        fi
    else
        choice="$(echo "${all_repos}" | fzf_select)"
        if [ -n "$choice" ]; then
            echo $choice
            tmux_create_and_attach "$(basename "${choice}")" "${choice}"
        fi
    fi
}

tmp() {
    if [ -n "$1" ]; then
        [ -f "${HOME}/local/tmp/${1}" ] && return 1
        [ ! -d "${HOME}/local/tmp/${1}" ] && mkdir -p "${HOME}/local/tmp/${1}"
        tmux_create_and_attach "$1" ~/local/tmp/"$1"
    else
        choice="$(find -L ~/local/tmp -mindepth 1 -maxdepth 1 -type d | xargs -n1 | rev | cut -d/ -f1 | rev | fzf_select)"
        if [ -n "$choice" ]; then
            tmux_create_and_attach "$choice" ~/local/tmp/"$choice"
        fi
    fi
}

tat() {
    if [ -n "$1" ]; then
        if [ "1" = "$(tmux list-session | cut -d':' -f1 | grep "^${1}$" | wc -l)" ]; then
            tmux_create_and_attach "${1}"
        fi
    else
        choice="$(tmux list-sessions | cut -d':' -f1 | fzf_select)"
        if [ -n "$choice" ]; then
            tmux_create_and_attach "$choice"
        fi
    fi
}

tnew() {
    if [ -z "$1" ]; then
        tmux_create_and_attach "$(basename "$(pwd)")" "$(pwd)"
    elif [ -z "$2" ]; then
        tmux_create_and_attach "$1" "$(pwd)"
    else
        tmux_create_and_attach "$1" "$2"
    fi
}

start_site_generator() {
    session_name="site-generator"
    tmux has-session -t "${session_name}" 2>/dev/null && return
    tmux_create_session "${session_name}" "${HOME}/vcon/personal/${session_name}"
    tmux send-keys -t ${session_name}:1.0 "sudo live-server --no-browser --port=80 out" Enter
    tmux split-window -t ${session_name}:1.0 -c "${HOME}/vcon/personal/${session_name}"
    tmux send-keys -t ${session_name}:1.1 "watch-directory.sh src make &" Enter
    tmux send-keys -t ${session_name}:1.1 "watch-directory.sh res make &" Enter
    tmux send-keys -t ${session_name}:1.1 "watch-directory.sh templates make &" Enter
    tmux select-layout -t ${session_name}:1 even-vertical
    sleep 1 && echo "" >"${HOME}/vcon/personal/${session_name}/src/.update"
}

notes() {
    start_site_generator
    pp "docs"
}
