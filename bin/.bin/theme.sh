#!/usr/bin/env bash

theme_dir="$HOME/.themes/themes"

if [ ! -d "${theme_dir}" ]; then
    echo "No theme files found!"
    exit 1
fi

if [ -n "$TMUX" ]; then
    set_palette_color() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
    set_term_param() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
    send_escape_seq() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
    set_palette_color() { printf '\033P\033]4;%d;rgb:%s\007\033\\' $@; }
    set_term_param() { printf '\033P\033]%d;rgb:%s\007\033\\' $@; }
    send_escape_seq() { printf '\033P\033]%s%s\007\033\\' $@; }
elif [ "${TERM%%-*}" = "linux" ]; then
    set_palette_color() { [ "$1" -lt 16 ] && printf "\e]P%x%s" "$1" "$(echo "$2" | sed 's/\///g')"; }
    set_term_param() { true; }
    send_escape_seq() { true; }
else
    set_palette_color() { printf '\033]4;%d;rgb:%s\033\\' $@; }
    set_term_param() { printf '\033]%d;rgb:%s\033\\' $@; }
    send_escape_seq() { printf '\033]%s%s\033\\' $@; }
fi

add_slashes() {
    original=$1
    echo "${original:0:2}/${original:2:2}/${original:4:2}"
}

usage() {
    echo "Usage: $(basename "$0") [-t string] [-s]"
    echo "    -t name of the theme to set"
    echo "    -s set shell escape sequences only"
    exit 1
}

interactive=1
shell_only=0
while getopts "t:s" opt; do
    case "${opt}" in
        t)
            theme_name="$OPTARG"
            interactive=0
            ;;
        s) shell_only=1 ;;
        ?) usage ;;
    esac
done

# determine theme to set
if [ $interactive -eq 0 ]; then
    if [ -z "${theme_name}" ]; then
        usage
    fi
    if [ ! -f "${theme_dir}/${theme_name}.yaml" ]; then
        # echo "theme \"${theme_name}\" not found"
        exit 1
    else
        choice=$theme_name
    fi
else
    themes=()
    for file in "$theme_dir"/*; do
        filename="$(basename "$file")"
        themes+=("${filename%.*}")
    done
    choice=$(printf '%s\n' "${themes[@]}" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [ -z "$choice" ]; then
        exit 1
    fi
fi

theme_path="${theme_dir}/${choice}.yaml"

# Parse YAML and export as environment variables
for i in {0..9}; do
    val=$(sed -ne 's/base0'"${i}"': "\(.*\)".*/\1/p' "$theme_path")
    export "COL${i}=${val}"
done

for i in {10..15}; do
    hex_char=$(printf "%X" $((i)))
    val=$(sed -ne 's/base0'"${hex_char}"': "\(.*\)".*/\1/p' "$theme_path")
    export "COL${i}=${val}"
done

# shell colours
set_palette_color 0 "$(add_slashes "$COL0")"  # black
set_palette_color 1 "$(add_slashes "$COL8")"  # red
set_palette_color 2 "$(add_slashes "$COL11")" # green
set_palette_color 3 "$(add_slashes "$COL10")" # yellow
set_palette_color 4 "$(add_slashes "$COL13")" # blue
set_palette_color 5 "$(add_slashes "$COL14")" # magenta
set_palette_color 6 "$(add_slashes "$COL12")" # cyan
set_palette_color 7 "$(add_slashes "$COL5")"  # white

set_palette_color 8  "$(add_slashes "$COL3")"  # bright black
set_palette_color 9  "$(add_slashes "$COL8")"  # bright red
set_palette_color 10 "$(add_slashes "$COL11")" # bright green
set_palette_color 11 "$(add_slashes "$COL10")" # bright yellow
set_palette_color 12 "$(add_slashes "$COL13")" # bright blue
set_palette_color 13 "$(add_slashes "$COL14")" # bright magenta
set_palette_color 14 "$(add_slashes "$COL12")" # bright cyan
set_palette_color 15 "$(add_slashes "$COL5")"  # bright white

set_term_param 10 "$(add_slashes "$COL5")"
set_term_param 11 "$(add_slashes "$COL0")"
send_escape_seq 12 ";7"

if [ $shell_only -eq 1 ]; then
    exit # done
fi

printf "#!/bin/sh\nshell_theme=\"%s\"" "$choice" >~/.sh_theme.sh

# Define template files
template_files=(
    "$HOME/.Xresources.conf.d/colours.in"
    "$HOME/.config/alacritty/colours.toml.in"
    "$HOME/.config/kitty/colours.conf.in"
    "$HOME/.config/zathura/zathurarc.in"
    "$HOME/.config/polybar/colours.ini.in"
    "$HOME/.config/bspwm/bspwmrc.in"
    "$HOME/.config/sway/colours.in"
    "$HOME/.config/waybar/colours.css.in"
    "$HOME/.config/swaylock/config.in"
    "$HOME/.config/swaync/colours.css.in"
    "$HOME/.config/nvim/colors/b16-inherit-from-shell.vim.in"
)

# Process each template file using envsubst
for template in "${template_files[@]}"; do
    if [ -f "$template" ]; then
        output="${template%.in}"  # Remove .in suffix
        envsubst < "$template" > "$output"
    fi
done
