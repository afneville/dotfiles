export GTK_USE_PORTAL=0
export MOZ_ENABLE_WAYLAND=1
export XDG_CURRENT_DESKTOP=sway
export QT_QPA_PLATFORMTHEME=wayland
export QT_STYLE_OVERRIDE=Adwaita-dark
export _JAVA_AWT_WM_NONREPARENTING=1
export GTK_THEME=Adwaita-dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
# export GDK_DPI_SCALE=1.75
# export XCURSOR_SIZE=36
export ELECTRON_OZONE_PLATFORM_HINT="auto"

# export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man' -\""
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export MANPAGER='nvim +Man!'
# export MANWIDTH=999
# export MANPAGER="nvim -c 'set ft=man' -"

export GNUPGHOME="~/.config/gpg/"
export ZDOTDIR="$HOME/.config/zsh"
export VISUAL=nvim
export EDITOR=nvim
export GOPATH="${HOME}/.go"
export PYTHON_BASIC_REPL=1

export FZF_DEFAULT_OPTS="--ansi --color=16 --border=none --info=hidden"
export PATH=$PATH:$HOME/.local/bin:$HOME/.bin:$HOME/.emacs.d/bin:$HOME/.npm-global/bin
for i in $(find -L $HOME/.bin -mindepth 1 -type d | xargs); do
    export PATH=${PATH}:${i}
done
