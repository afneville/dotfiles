#!/usr/bin/env bash

theme_dir="$HOME/vcon/b16-themes/themes"

if [ -n "$TMUX" ]; then
    put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
    put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
    put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
    put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\' $@; }
    put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\' $@; }
    put_template_custom() { printf '\033P\033]%s%s\007\033\\' $@; }
elif [ "${TERM%%-*}" = "linux" ]; then
    put_template() { [ $1 -lt 16 ] && printf "\e]P%x%s" $1 $(echo $2 | sed 's/\///g'); }
    put_template_var() { true; }
    put_template_custom() { true; }
else
    put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
    put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
    put_template_custom() { printf '\033]%s%s\033\\' $@; }
fi

add_slashes () {
    original=$1
    echo "${original:0:2}/${original:2:2}/${original:4:2}"
}

# pass arguments
usage () {
    echo "Usage: $(basename "$0") [-t string] [-s]"
    echo "    -t name of the theme to set"
    echo "    -s set shell escape sequences only"
    exit 1
}
interactive=1
shell_only=0
while getopts "t:s" opt
do
    case "${opt}" in
        t)
            theme_name="$OPTARG"
            interactive=0
            ;;
        s) shell_only=1 ;;
        ?) usage ;;
    esac
done


#determine theme to set
if [ $interactive -eq 0 ]
then
    if [ -z "${theme_name}" ]; then
        usage
    fi
    if [ ! -f "${theme_dir}/${theme_name}.yaml" ]; then
        # echo "theme \"${theme_name}\" not found"
        exit 1;
    else
        choice=$theme_name
    fi
else
    themes=()
    for file in $theme_dir/*; do
        filename="$(basename $file)"
        themes+=("${filename%.*}")
    done
    choice=$(printf '%s\n' "${themes[@]}" | fzf --height=20 --border=none --reverse --no-separator --ansi --color=16)
    if [ -z "$choice" ]; then
        exit 1;
    fi
fi

theme_path="${theme_dir}/${choice}.yaml"
theme=()
for c in base0{0..9} base0{A..F}
do
    theme+=($(sed -ne 's/'"${c}"': "\(.*\)".*/\1/p' $theme_path))
done
# echo "${theme[@]}"

# shell colours
put_template 0  $(add_slashes ${theme[2]})
put_template 1  $(add_slashes ${theme[8]})
put_template 2  $(add_slashes ${theme[11]})
put_template 3  $(add_slashes ${theme[10]})
put_template 4  $(add_slashes ${theme[13]})
put_template 5  $(add_slashes ${theme[14]})
put_template 6  $(add_slashes ${theme[12]})
put_template 7  $(add_slashes ${theme[5]})

put_template 8  $(add_slashes ${theme[3]})
put_template 9  $(add_slashes ${theme[8]})
put_template 10 $(add_slashes ${theme[11]})
put_template 11 $(add_slashes ${theme[10]})
put_template 12 $(add_slashes ${theme[13]})
put_template 13 $(add_slashes ${theme[14]})
put_template 14 $(add_slashes ${theme[12]})
put_template 15 $(add_slashes ${theme[5]})

put_template_var 10 $(add_slashes ${theme[5]})
put_template_var 11 $(add_slashes ${theme[0]})
put_template_custom 12 ";7"

put_template 16 $(add_slashes ${theme[9]})
put_template 17 $(add_slashes ${theme[15]})
put_template 18 $(add_slashes ${theme[1]})
put_template 19 $(add_slashes ${theme[2]})
put_template 20 $(add_slashes ${theme[4]})
put_template 21 $(add_slashes ${theme[6]})

if [ $shell_only -eq 1 ]; then
    exit; # done
fi

printf "#!/bin/sh\nshell_theme=\"$choice\"\n" > ~/.sh_theme.sh

[ -f "$HOME/.Xresources.conf.d/colours.in" ] && cp ~/.Xresources.conf.d/colours.in ~/.Xresources.conf.d/colours
[ -f "$HOME/.config/alacritty/colours.yml.in" ] && cp ~/.config/alacritty/colours.yml.in ~/.config/alacritty/colours.yml.tmp
[ -f "$HOME/.config/kitty/colours.conf.in" ] && cp ~/.config/kitty/colours.conf.in ~/.config/kitty/colours.conf
[ -f "$HOME/.config/zathura/zathurarc.in" ] && cp ~/.config/zathura/zathurarc.in ~/.config/zathura/zathurarc
[ -f "$HOME/.config/polybar/colours.ini.in" ] && cp ~/.config/polybar/colours.ini.in ~/.config/polybar/colours.ini
[ -f "$HOME/.config/bspwm/bspwmrc.in" ] && cp ~/.config/bspwm/bspwmrc.in ~/.config/bspwm/bspwmrc
[ -f "$HOME/.config/nvim/colors/b16-inherit-from-shell.vim.in" ] && cp ~/.config/nvim/colors/b16-inherit-from-shell.vim.in ~/.config/nvim/colors/b16-inherit-from-shell.vim

for i in {0..15}; do
    [ -f "$HOME/.Xresources.conf.d/colours.in" ] && sed -i "s/%col${i}%/${theme[$i]}/g" ~/.Xresources.conf.d/colours
    [ -f "$HOME/.config/alacritty/colours.yml.in" ] && sed -i "s/%col${i}%/${theme[$i]}/g" ~/.config/alacritty/colours.yml.tmp
    [ -f "$HOME/.config/kitty/colours.conf.in" ] && sed -i "s/%col${i}%/${theme[$i]}/g" ~/.config/kitty/colours.conf
    [ -f "$HOME/.config/zathura/zathurarc.in" ] && sed -i "s/%col${i}%/${theme[$i]}/g" ~/.config/zathura/zathurarc
    [ -f "$HOME/.config/polybar/colours.ini.in" ] && sed -i "s/%col${i}%/${theme[$i]}/g" ~/.config/polybar/colours.ini
    [ -f "$HOME/.config/bspwm/bspwmrc.in" ] && sed -i "s/%col${i}%/${theme[$i]}/g" ~/.config/bspwm/bspwmrc
    [ -f "$HOME/.config/nvim/colors/b16-inherit-from-shell.vim.in" ] && sed -i "s/%col${i}%/${theme[$i]}/g" ~/.config/nvim/colors/b16-inherit-from-shell.vim
done

mv ~/.config/alacritty/colours.yml.tmp ~/.config/alacritty/colours.yml
xrdb ~/.Xresources
