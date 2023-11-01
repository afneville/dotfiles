#!/bin/sh

alias fzf_select="fzf --height=20 --border=none --reverse --no-separator --ansi --color=16"

choice="$(find ~/.config/sway/monitor-configurations -type f | xargs -n1 basename | cut -d'.' -f1 | fzf_select)"

if [ -n "$choice" ]; then
    rm -f ~/.config/sway/display-config.sh
    ln -s ~/.config/sway/monitor-configurations/${choice}.sh ~/.config/sway/display-config.sh
fi
