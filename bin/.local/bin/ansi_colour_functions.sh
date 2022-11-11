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

