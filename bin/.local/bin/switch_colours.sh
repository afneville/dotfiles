#!/bin/bash

scheme_dir="$HOME/.Xresources.conf.d/schemes/"
scheme_file="$HOME/.Xresources.conf.d/colours"

files=()

for file in $scheme_dir/*; do

    files+=("$(basename $file)")

done


choice=$(printf '%s\n' "${files[@]}" | fzf --height=20 --border=sharp)

if [ "$choice" ]; then

    cat $scheme_dir/$choice > $scheme_file
    write_colours.sh $choice

fi
