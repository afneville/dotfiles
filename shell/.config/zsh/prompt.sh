autoload -Uz vcs_info
autoload -U colors && colors
precmd () { vcs_info }
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' •'
zstyle ':vcs_info:*' unstagedstr ' •'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
     git status --porcelain | grep -m 1 '^??' &>/dev/null
  then
    hook_com[misc]=' •'
  fi
}

zstyle ':vcs_info:*' formats $' %F{magenta}%{\x1b[3m%}%b%{\x1b[0m%}%f %F{green}%c%f%F{yellow}%u%f%F{red}%m%f '
zstyle ':vcs_info:*' actionformats $' %F{magenta}%{\x1b[3m%}%b %a%{\x1b[0m%}%f %F{green}%c%f%F{yellow}%u%f%F{red}%m%f '
setopt prompt_subst

PS1=$' %F{green}%{\x1b[3m%}%n%{\x1b[0m%}%f  %F{blue}%{\x1b[3m%}%m%{\x1b[0m%}%f  %F{cyan}%{\x1b[3m%}%(4~|%-1~/.../%2~|%3~)%{\x1b[0m%}%f $vcs_info_msg_0_\n %F{yellow}> %f '
