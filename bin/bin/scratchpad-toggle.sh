#!/usr/bin/bash

if [ -z "$(xdotool search --class scratchpad | head -n 1)" ]
then
    alacritty --class scratchpad -e zsh -ic "tmux new-session -As scratchpad" &
    # pid=$(xdotool search --class scratchpad | head -n 1)
    # while [[ -z "$pid" ]]; do
    #     pid=$(xdotool search --class scratchpad | head -n 1)
    # done
    # bspc node $pid --flag hidden -f
fi

pid=$(xdotool search --class scratchpad | head -n 1)
bspc node $pid --flag hidden -f
