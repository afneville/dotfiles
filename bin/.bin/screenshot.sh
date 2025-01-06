#!/bin/bash

name_file() {
    image_dir="$(xdg-user-dir PICTURES)"
    if [ -f "${image_dir}${1}.png" ]; then
        j=1
        while [ -f "${image_dir}${1}(${j}).png" ]; do
            j=$((j + 1))
        done
        echo "${image_dir}${1}(${j}).png"
    else
        echo "${image_dir}${1}.png"
    fi
}

LONGOPTS=copy,display,monitor,window,area
OPTS=c,d,m,w,a
PARSED=$(getopt --options=$OPTS --longoptions=$LONGOPTS --name "$0" -- "$@")
eval set -- "$PARSED"

target="screen" copy="n"
while true; do
    case "$1" in
        "-c" | "--copy")
            copy="y"
            shift
            ;;
        "-d" | "--display")
            target="screen"
            shift
            ;;
        "-m" | "--monitor")
            target="output"
            shift
            ;;
        "-w" | "--window")
            target="active"
            shift
            ;;
        "-a" | "--area")
            target="area"
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            exit 3
            ;;
    esac
done

timestamp=$(date +%Y%m%d_%H%M%S)
filename="$(name_file "${timestamp}")"

if [ "$copy" = "y" ]; then
    to="| tee ${filename} | wl-copy"
    message="Screenshot Copied to Clipboard"
else
    to="> ${filename}"
    message="Screenshot Saved to File"
fi

eval "grimshot save ${target} - ${to}"
# notify-send "${message}" "${filename}"
