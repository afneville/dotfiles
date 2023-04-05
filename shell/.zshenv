export QT_QPA_PLATFORMTHEME=qt5ct
export VISUAL=nvim
export EDITOR=/usr/bin/nvim
export _JAVA_AWT_WM_NONREPARENTING=1
export BAT_THEME="base16"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER='nvim +Man!'
# export MANPAGER="nvim -c 'set ft=man' -"
export ZDOTDIR="$HOME/.config/zsh"
export FZF_DEFAULT_OPTS="--ansi --color=16 --border=none --info=hidden"
export PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.emacs.d/bin:$HOME/.npm_global/bin
for i in $(find -L $HOME/bin -mindepth 1 -type d | xargs); do
    export PATH=${PATH}:${i}
done
