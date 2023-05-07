HISTFILE=~/.cache/zsh_history
HISTSIZE=10000
SAVEHIST=10000
ZSH_DISABLE_COMPFIX=true

# export PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.emacs.d/bin:$HOME/.npm_global/bin
# for i in $(find -L $HOME/bin -mindepth 1 -type d | xargs); do
#     export PATH=${PATH}:${i}
# done
# vim mode
bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # 1 = block 4 = beam
        viins|main) echo -ne '\e[1 q';;
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne '\e[1 q'
}
zle -N zle-line-init
echo -ne '\e[1 q'
preexec() { echo -ne '\e[1 q' ;}

# features
setopt extendedglob nomatch menucomplete
setopt interactive_comments
zle_highlight=('paste:none')
unsetopt BEEP

autoload -U colors && colors
autoload -Uz compinit
compinit -u

zstyle :compinstall filename '/home/alex/.config/zsh/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
_comp_options+=(globdots)

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

# source aliases

# custom "plugin manager"
# [ -f "$HOME/.aliasrc.sh" ] && source "$HOME/.aliasrc.sh"
# [ -f "$HOME/.sh_theme.sh" ] && source "$HOME/.sh_theme.sh"
# [ -f "$ZDOTDIR/plugin_manager.sh" ] && source "$ZDOTDIR/plugin_manager.sh"

function source_file() {
    [ -f "$1" ] && source "$1"
}

function add_zsh_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
        source_file "$ZDOTDIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        source_file "$ZDOTDIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh-theme" || \
        source_file "$ZDOTDIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
}

source_file "$ZDOTDIR/functions.sh"
source_file "$ZDOTDIR/prompt.sh"
source_file "$HOME/.aliasrc.sh"
source_file "$HOME/.sh_theme.sh"
add_zsh_plugin "zsh-users/zsh-autosuggestions"
add_zsh_plugin "zsh-users/zsh-syntax-highlighting"

theme.sh -s -t $shell_theme

# uncomment for space before and after output.
# preexec() {
#
#     echo ""
#
# }
#
# precmd() {
#     if [ -z "$OPTIONAL_NEW_LINE" ]; then
#         OPTIONAL_NEW_LINE=1
#     elif [ "$OPTIONAL_NEW_LINE" -eq 1 ]; then
#         echo "\n"
#     fi
# }

# paste after
vi-append-x-selection () { RBUFFER=$(wl-paste </dev/null)$RBUFFER; }
zle -N vi-append-x-selection
bindkey -M vicmd 'p' vi-append-x-selection

# paste over
vi-paste-x-selection () { zle vi-delete; RBUFFER=$(wl-paste </dev/null)$RBUFFER; }
zle -N vi-paste-x-selection
bindkey -M visual 'p' vi-paste-x-selection

# yank selection
vi-yank-x-selection () { zle vi-yank;  print -rn -- $CUTBUFFER | wl-copy; }
zle -N vi-yank-x-selection
bindkey -M visual 'y' vi-yank-x-selection

# yank whole line
vi-yank-x-line () { zle vi-yank-whole-line;  print -rn -- $CUTBUFFER | wl-copy; }
zle -N vi-yank-x-line
bindkey -M vicmd 'Y' vi-yank-x-line

typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
