#!/bin/sh

# General:
alias grep='grep --color=auto'
# alias config_monitor='xrandr --output eDP1 --mode 1920x1080 --auto --output HDMI1 --mode 1920x1080 --right-of eDP1 --primary  --auto'
# alias ls='exa -a --group-directories-first'
# alias lsl='exa -lag --group-directories-first'
# alias sudo="doas"
alias ls='ls --color=auto --group-directories-first'
alias lsl='ls -l'
alias lsla='ls -la'
# alias tree='exa --tree --color=always -a --ignore-glob="*.git"'
alias setbg='feh --bg-fill'

alias locate='updatedb && locate'
alias volume='alsamixer'
alias nm='nm-connection-editor'
alias off="poweroff"
alias restart="reboot now"
alias aliases="nvim ~/.aliasrc.sh"
alias simple-prompt="PS1=\"$ \""
alias x="startx"
alias c="unset OPTIONAL_NEW_LINE && clear"
alias clear="unset OPTIONAL_NEW_LINE && clear"
alias xmerge="xrdb -merge ~/.Xresources"
alias getbrightness="ddcutil -t -d 1 getvcp 10 && ddcutil -t -d 2 getvcp 10"

# tmux
alias tls="tmux ls | cut -d':' -f1"

# Directories:
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Utilities
alias g="git"
alias p="python3"
alias s="systemctl"
alias v="nvim"
alias top="htop"
alias t="htop"

# Git
alias gs="git status"
alias ga="git add"
alias gc="git commit"

# Misc
alias copy_png="xclip -selection clipboard -target image/png -i"
alias paste_png="xclip -selection clipboard -target image/png -o"
alias copy_text="xclip -selection clipboard -i"
alias paste_text="xclip -selection clipboard -o"
alias laptop="ssh alex@192.168.1.115"
alias main="tmux new-session -As main -c ~/"
alias pick-colour="grim -g \"\$(slurp -p)\" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-"

# aws cli
alias s3="aws s3"
alias ec2="aws ec2"
alias cloudfront="aws cloudfront"
alias codecommit="aws codecommit"
