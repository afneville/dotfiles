export GTK_USE_PORTAL=0
export GNUPGHOME="~/.config/gpg/"
export MOZ_ENABLE_WAYLAND=1
export XDG_CURRENT_DESKTOP=sway
export QT_QPA_PLATFORMTHEME=wayland
export VISUAL=nvim
export EDITOR=nvim
export _JAVA_AWT_WM_NONREPARENTING=1
export BAT_THEME="base16"


# export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man' -\""
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER='nvim +Man!'
export MANWIDTH=999
# export MANPAGER="nvim -c 'set ft=man' -"
export GTK_THEME=Adwaita-dark
# export GDK_DPI_SCALE=1.75
# export XCURSOR_SIZE=36
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=Adwaita-dark
export ZDOTDIR="$HOME/.config/zsh"
export FZF_DEFAULT_OPTS="--ansi --color=16 --border=none --info=hidden"
export PATH=$PATH:$HOME/.local/bin:$HOME/.bin:$HOME/.emacs.d/bin:$HOME/.npm-global/bin
for i in $(find -L $HOME/.bin -mindepth 1 -type d | xargs); do
    export PATH=${PATH}:${i}
done
