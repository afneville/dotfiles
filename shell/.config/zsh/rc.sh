HISTFILE=~/.cache/zsh_history
HISTSIZE=10000
SAVEHIST=10000
ZSH_DISABLE_COMPFIX=true

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

# paste before
vi-prepend-gui-clipboard () { LBUFFER=$LBUFFER$(wl-paste </dev/null); }
zle -N vi-prepend-gui-clipboard
bindkey -M vicmd 'P' vi-prepend-gui-clipboard

# paste after
vi-append-gui-clipboard () { RBUFFER=${RBUFFER:0:1}$(wl-paste </dev/null)${RBUFFER:1}; }
zle -N vi-append-gui-clipboard
bindkey -M vicmd 'p' vi-append-gui-clipboard

# paste over
vi-paste-gui-clipboard () { zle vi-delete; RBUFFER=$(wl-paste </dev/null)$RBUFFER; }
zle -N vi-paste-gui-clipboard
bindkey -M visual 'p' vi-paste-gui-clipboard
bindkey -M visual 'P' vi-paste-gui-clipboard

# yank selection
vi-yank-gui-clipboard () { zle vi-yank;  print -rn -- $CUTBUFFER | wl-copy; }
zle -N vi-yank-gui-clipboard
bindkey -M visual 'y' vi-yank-gui-clipboard

# yank whole line
# vi-yank-line-gui-clipboard () { zle vi-yank-whole-line;  print -rn -- $CUTBUFFER | wl-copy; }
# zle -N vi-yank-line-gui-clipboard
# bindkey -M vicmd 'yy' vi-yank-line-gui-clipboard

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
