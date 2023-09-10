autoload -Uz vcs_info
autoload -U colors && colors
precmd () { vcs_info }
# zstyle ':vcs_info:*' formats $'   %F{magenta}%{\x1b[3m%}%b%{\x1b[0m%}%f'
zstyle ':vcs_info:*' formats $' %F{magenta}%{\x1b[3m%}%b%{\x1b[0m%}%f'
setopt prompt_subst

# PS1=$'   %F{green}%{\x1b[3m%}%n%{\x1b[0m%}%f   %F{cyan}%(4~|%-1~/.../%2~|%3~)%f$vcs_info_msg_0_ %F{yellow} %f '
PS1=$' %F{cyan}%(4~|%-1~/.../%2~|%3~)%f$vcs_info_msg_0_ %F{yellow}>%f '
