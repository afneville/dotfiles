HISTFILE=~/.cache/zsh_history
HISTSIZE=10000
SAVEHIST=10000
ZSH_DISABLE_COMPFIX=true
export GPG_TTY=$(tty)
PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"
# vim mode
bindkey -v
export KEYTIMEOUT=1
# 0  -> blinking block.
# 1  -> blinking block (default).
# 2  -> steady block.
# 3  -> blinking underline.
# 4  -> steady underline.
# 5  -> blinking bar, xterm.
# 6  -> steady bar, xterm.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # 1 = block 4 = underscore 5 = beam
        viins|main) echo -ne '\e[4 q';;
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne '\e[4 q'
}
zle -N zle-line-init
echo -ne '\e[4 q'
preexec() { echo -ne '\e[4 q' ;}

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

alias dirs='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index


autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

# features
setopt extendedglob nomatch menucomplete
setopt interactive_comments
zle_highlight=('paste:none')
unsetopt BEEP

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^[' undo
bindkey -M menuselect '\e' undo

autoload -U colors && colors
autoload -Uz compinit
compinit -u
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle :compinstall filename '/home/alex/.config/zsh/.zshrc'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
# zstyle ':completion:*' file-list all
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' complete-options true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:*files' ignored-patterns '~/mnt/nextcloud/*'
zstyle ':completion:*:*directories' ignored-patterns '~/mnt/nextcloud/*'
_comp_options+=(globdots)
setopt AUTO_PARAM_SLASH

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'n' edit-command-line
# bindkey -M vicmd '\r' edit-command-line

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

theme.sh -s -t $shell_theme

# paste before
vi-prepend-gui-clipboard () { LBUFFER=$LBUFFER$(wl-paste </dev/null); }
zle -N vi-prepend-gui-clipboard
# bindkey -M vicmd 'P' vi-prepend-gui-clipboard

# paste after
vi-append-gui-clipboard () { RBUFFER=${RBUFFER:0:1}$(wl-paste </dev/null)${RBUFFER:1}; }
zle -N vi-append-gui-clipboard
# bindkey -M vicmd 'p' vi-append-gui-clipboard

# paste over
vi-paste-gui-clipboard () { zle vi-delete; RBUFFER=$(wl-paste </dev/null)$RBUFFER; }
zle -N vi-paste-gui-clipboard
# bindkey -M visual 'p' vi-paste-gui-clipboard
# bindkey -M visual 'P' vi-paste-gui-clipboard

# yank selection
vi-yank-gui-clipboard () { zle vi-yank;  print -rn -- $CUTBUFFER | wl-copy; }
zle -N vi-yank-gui-clipboard
# bindkey -M visual 'y' vi-yank-gui-clipboard

# yank whole line
vi-yank-line-gui-clipboard () { zle vi-yank-whole-line;  print -rn -- $CUTBUFFER | wl-copy; }
zle -N vi-yank-line-gui-clipboard
# bindkey -M vicmd 'Y' vi-yank-line-gui-clipboard


bindkey -M vicmd '^k' up-line-or-history
bindkey -M vicmd '^j' down-line-or-history
bindkey -M viins '^k' up-line-or-history
bindkey -M viins '^j' down-line-or-history

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
