#!/bin/sh

function fd() {
    choice=$(echo "$(find ~/* \( -name '.git' -o -name 'env' \) -prune -false -o -type d)\nquit" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [[ $choice != "quit" ]]; then
        pushd $choice
    fi
}

function ff(){
    choice=$(echo "$(find ~/* \( -name '.git' -o -name 'env' \) -prune -false -o -type f)\nquit" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [[ ! -z "$choice" ]]; then
        if [[ $choice != "quit" ]]; then
            pushd $(dirname $choice)
            nvim $choice
            popd
        fi
    fi
}

function ff.(){
    choice=$(echo "$(find ./* \( -name '.git' -o -name 'env' \) -prune -false -o -type f)\nquit" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [[ ! -z "$choice" ]]; then
        if [[ $choice != "quit" ]]; then
            nvim $choice
        fi
    fi
}

function fd.() {
    choice=$(echo "$(find ./* \( -name '.git' -o -name 'env' \) -prune -false -o -type d)\nquit" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [[ $choice != "quit" ]]; then
        pushd $choice
    fi
}
