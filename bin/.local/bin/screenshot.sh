#!/usr/bin/env bash

dpi=$(xrdb -query | grep dpi | cut -f2)

if [[ $dpi = "192" ]]; then
    padding="-4"
else
    padding="-2"
fi
case "${1}" in
    -f) # full screen
        maim -u -o | tee ~/imgs/scrshts/$(date +%s).png | xclip -selection clipboard -t image/png
        ;;
    -c) # current window with border
        maim -u -o -i $(xdotool getactivewindow) | tee ~/imgs/scrshts/$(date +%s).png | xclip -selection clipboard -t image/png
        ;;
    -w) # selected window without border
        maim -u -o -s --tolerance=999 --padding=$(echo $padding) | tee ~/imgs/scrshts/$(date +%s).png | xclip -selection clipboard -t image/png
        ;;
    -b) # selected window with border
        maim -u -o -s --tolerance=999 | tee ~/imgs/scrshts/$(date +%s).png | xclip -selection clipboard -t image/png
        ;;
    -s) # selection
        maim -u -o -s --bordersize=2 --tolerance=0 | tee ~/imgs/scrshts/$(date +%s).png | xclip -selection clipboard -t image/png
        ;;
esac
