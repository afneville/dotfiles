#!/usr/bin/bash

pid=$(xdotool search --class scratchpad | head -n 1)
if [ -z "$pid" ]; then
    alacritty --class scratchpad -e zsh -ic "tmux new-session -As scratchpad" &
else
    bspc node "$pid" --flag hidden -f
fi
