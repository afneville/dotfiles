#
# ~/.bashrc
#

#colorscript -e 5
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#set -o vi

#This is a nice prompt variable, but it is too long :(
#PS1='\[\e[33m\]\A \[\e[01;36m\]\u \[\e[00m\]at \[\e[01;32m\]\h \[\e[00m\]in \[\e[01;34m\]\w \[\e[33m\]\$: \[\e[00m\]'
PS1='\[\e[34m\]\w\[\e[36m\] $: \[\e[00m\]'
[ -f "$HOME/.aliasrc.sh" ] && source "$HOME/.aliasrc.sh"

# export PYTHONPATH=/home/alex/python/packages/
export PATH=$PATH:$HOME/.local/bin:$HOME/.emacs.d/bin
export VISUAL=nvim
export EDITOR=nvim

# umask 0022 
