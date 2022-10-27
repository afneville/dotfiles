#!/bin/sh

function fd() {
    choice=$(echo "$(find ~/* \( -name '.git' -o -name 'env' \) -prune -false -o -type d)\nquit" | fzf --height=20 --border=sharp)
    if [[ $choice != "quit" ]]; then
        pushd $choice
    fi
}

function ff(){
    choice=$(echo "$(find ~/* \( -name '.git' -o -name 'env' \) -prune -false -o -type f)\nquit" | fzf --height=20 --border=sharp)
    if [[ ! -z "$choice" ]]; then
        if [[ $choice != "quit" ]]; then
            pushd $(dirname $choice)
            nvim $choice
            popd
        fi
    fi
}

function f.(){
    choice=$(echo "$(find ./* \( -name '.git' -o -name 'env' \) -prune -false -o -type f)\nquit" | fzf --height=20 --border=sharp)
    if [[ ! -z "$choice" ]]; then
        if [[ $choice != "quit" ]]; then
            nvim $choice
        fi
    fi
}
