#!/bin/sh

## autoload vcs and colors
# enable only git
# setup a hook that runs before every ptompt.
# autoload -Uz vcs_info
# autoload -U colors && colors
# zstyle ':vcs_info:*' enable git
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
# setopt prompt_subst

# uncomment for space before and after output.
# preexec() {
#
#     echo ""
#
# }
# precmd() {
#     if [ -z "$OPTIONAL_NEW_LINE" ]; then
#         OPTIONAL_NEW_LINE=1
#     elif [ "$OPTIONAL_NEW_LINE" -eq 1 ]; then
#         echo "\n"
#     fi
# }

# zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
# +vi-git-untracked(){
#     if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
#         git status --porcelain | grep '??' &> /dev/null ; then
# 
#         # untracked files in pwd
#         #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
# 
#         # untracked files in whole repo
#         hook_com[staged]+='!'
#     fi
# }
# 
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%})"

# PROMPT="%B%{$fg[magenta]%}[%b%{$fg[cyan]%}%~%{$fg[magenta]%}%B]%b\$vcs_info_msg_0_ %{$fg[blue]%}%{$fg[green]%}%{$fg[yellow]%}%{$reset_color%} "
# PROMPT="%B%{$fg[magenta]%}[%b%{$fg[cyan]%}%~%{$fg[magenta]%}%B]%b %{$fg[blue]%}%{$fg[green]%}%{$fg[yellow]%}%{$reset_color%} "
PROMPT="%B%{$fg[magenta]%}[%b%{$fg[cyan]%}%~%{$fg[magenta]%}%B]%b %{$fg[blue]%}$%{$reset_color%} "
