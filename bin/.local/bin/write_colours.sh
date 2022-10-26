#!/bin/bash

scheme_dir="$HOME/.Xresources.conf.d/schemes/"
scheme_file="$HOME/.Xresources.conf.d/colours"

format_colour () {
    original=$1
    echo "${original:1:2}/${original:3:2}/${original:5:2}"
}

get_colours () {

    FOREGROUND="$(xrdb -query | grep 'foreground:'| awk '{print $NF}')"
    BACKGROUND="$(xrdb -query | grep 'background:'| awk '{print $NF}')"
    CURSOR="$(xrdb -query | grep 'cursorColor:'| awk '{print $NF}')"
    BLACK="$(xrdb -query | grep 'color0:'| awk '{print $NF}')"
    RED="$(xrdb -query | grep 'color1:'| awk '{print $NF}')"
    GREEN="$(xrdb -query | grep 'color2:'| awk '{print $NF}')"
    YELLOW="$(xrdb -query | grep 'color3:'| awk '{print $NF}')"
    BLUE="$(xrdb -query | grep 'color4:'| awk '{print $NF}')"
    MAGENTA="$(xrdb -query | grep 'color5:'| awk '{print $NF}')"
    CYAN="$(xrdb -query | grep 'color6:'| awk '{print $NF}')"
    WHITE="$(xrdb -query | grep 'color7:'| awk '{print $NF}')"
    ALTBLACK="$(xrdb -query | grep 'color8:'| awk '{print $NF}')"
    ALTRED="$(xrdb -query | grep 'color9:'| awk '{print $NF}')"
    ALTGREEN="$(xrdb -query | grep 'color10:'| awk '{print $NF}')"
    ALTYELLOW="$(xrdb -query | grep 'color11:'| awk '{print $NF}')"
    ALTBLUE="$(xrdb -query | grep 'color12:'| awk '{print $NF}')"
    ALTMAGENTA="$(xrdb -query | grep 'color13:'| awk '{print $NF}')"
    ALTCYAN="$(xrdb -query | grep 'color14:'| awk '{print $NF}')"
    ALTWHITE="$(xrdb -query | grep 'color15:'| awk '{print $NF}')"

    colour00=$(format_colour $BLACK)
    colour01=$(format_colour $RED)
    colour02=$(format_colour $GREEN)
    colour03=$(format_colour $YELLOW)
    colour04=$(format_colour $BLUE)
    colour05=$(format_colour $MAGENTA)
    colour06=$(format_colour $CYAN)
    colour07=$(format_colour $WHITE)
    colour08=$(format_colour $ALTBLACK)
    colour09=$(format_colour $ALTRED)
    colour10=$(format_colour $ALTGREEN)
    colour11=$(format_colour $ALTYELLOW)
    colour12=$(format_colour $ALTBLUE)
    colour13=$(format_colour $ALTMAGENTA)
    colour14=$(format_colour $ALTCYAN)
    colour15=$(format_colour $ALTWHITE)
    colour_foreground=$(format_colour $FOREGROUND)
    colour_background=$(format_colour $BACKGROUND)

}

polybar_colours () {

	cat > $HOME/.config/polybar/colours <<- EOF	
	[color]
	foreground = ${FOREGROUND}
	background = ${BACKGROUND}
	black = ${BLACK}
	red = ${RED}
	green = ${GREEN}
	yellow = ${YELLOW}
	blue = ${BLUE}
	magenta = ${MAGENTA}
	cyan = ${CYAN}
	white = ${WHITE}
	altblack = ${ALTBLACK}
	altred = ${ALTRED}
	altgreen = ${ALTGREEN}
	altyellow = ${ALTYELLOW}
	altblue = ${ALTBLUE}
	altmagenta = ${ALTMAGENTA}
	altcyan = ${ALTCYAN}
	altwhite = ${ALTWHITE}
	EOF
}

alacritty_colours () {

	cat > $HOME/.config/alacritty/colours.yml <<- _EOF_
		colors:
		  primary:
		    background: '${BACKGROUND}'
		    foreground: '${FOREGROUND}'
		  normal:
		    black:   '${BLACK}'
		    red:     '${RED}'
		    green:   '${GREEN}'
		    yellow:  '${YELLOW}'
		    blue:    '${BLUE}'
		    magenta: '${MAGENTA}'
		    cyan:    '${CYAN}'
		    white:   '${WHITE}'
		  bright:
		    black:   '${ALTBLACK}'
		    red:     '${ALTRED}'
		    green:   '${ALTGREEN}'
		    yellow:  '${ALTYELLOW}'
		    blue:    '${ALTBLUE}'
		    magenta: '${ALTMAGENTA}'
		    cyan:    '${ALTCYAN}'
		    white:   '${ALTWHITE}'
	_EOF_
}

kitty_colours () {

	cat > $HOME/.config/kitty/colours.conf <<- EOF	
    background ${BACKGROUND}
    foreground ${FOREGROUND}
    cursor ${CURSOR}
    selection_background ${CURSOR}
    color0 ${BLACK}
    color8 ${ALTBLACK}
    color1 ${RED}
    color9 ${ALTRED}
    color2 ${GREEN}
    color10 ${ALTGREEN}
    color3 ${YELLOW}
    color11 ${ALTYELLOW}
    color4 ${BLUE}
    color12 ${ALTBLUE}
    color5 ${MAGENTA}
    color13 ${ALTMAGENTA}
    color6 ${CYAN}
    color14 ${ALTCYAN}
    color7 ${WHITE}
    color15 ${ALTWHITE}
    selection_foreground ${BACKGROUND}
    EOF
}
rofi_colours () {
	cat > $HOME/.config/rofi/themes/colours.rasi <<- EOF	
	* {
		background:			${BACKGROUND};
		foreground:			${FOREGROUND};
		selected:			${BLUE};
		urgent:				${RED};
		on:					${GREEN};
		off:				${RED};
        comment:            #8A8F99;
	}
	EOF
}

zathura_colours () {

	cat > $HOME/.config/zathura/zathurarc <<- EOF
	set default-bg                  "${BACKGROUND}"
        set default-fg                  "${FOREGROUND}"
        set statusbar-fg                "${FOREGROUND}"
        set statusbar-bg                "${BACKGROUND}"
        set inputbar-bg                 "${BACKGROUND}"
        set inputbar-fg                 "${CYAN}"
        set notification-bg             "${BACKGROUND}"
        set notification-fg             "${FOREGROUND}"
        set notification-error-bg       "${BACKGROUND}"
        set notification-error-fg       "${FOREGROUND}"
        set notification-warning-bg     "${BACKGROUND}"
        set notification-warning-fg     "${FOREGROUND}"
        set highlight-color             "${BLUE}"
        set highlight-active-color      "${BLUE}"
        set completion-bg               "${FOREGROUND}"
        set completion-fg               "${BLUE}"
        set completion-highlight-fg     "${CYAN}"
        set completion-highlight-bg     "${BLUE}"
        set recolor-lightcolor          "${BACKGROUND}"
        set recolor-darkcolor           "${FOREGROUND}"
        set selection-clipboard clipboard       
        set recolor                     "false"
        set recolor-keephue             "true"
        set guioptions none
	EOF

}

shell_colours () {

    if [ -n "$TMUX" ]; then
      # Tell tmux to pass the escape sequences through
      # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
      put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
      put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
      put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
    elif [ "${TERM%%[-.]*}" = "screen" ]; then
      # GNU screen (screen, screen-256color, screen-256color-bce)
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
    
    put_template 0  $colour00
    put_template 1  $colour01
    put_template 2  $colour02
    put_template 3  $colour03
    put_template 4  $colour04
    put_template 5  $colour05
    put_template 6  $colour06
    put_template 7  $colour07
    put_template 8  $colour08
    put_template 9  $colour09
    put_template 10 $colour10
    put_template 11 $colour11
    put_template 12 $colour12
    put_template 13 $colour13
    put_template 14 $colour14
    put_template 15 $colour15
    
    # foreground / background / cursor color
    put_template_var 10 $colour_foreground
    # if [ "$BASE16_SHELL_SET_BACKGROUND" != false ]; then
    put_template_var 11 $colour_background
    # fi
    put_template_custom 12 ";7" # cursor (reverse video)
}

if [ ! -z "$1" ]; then
    cat $scheme_dir$1 > $scheme_file
fi

# get the colours from .Xresources
xrdb ~/.Xresources
get_colours

alacritty_colours
# polybar_colours
# kitty_colours
# zathura_colours
# shell_colours
# rofi_colours
# hsetroot -solid $(xrdb -query | grep 'background:'| awk '{print $NF}')
