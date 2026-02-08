# Personal Configuration Files

This version control repository contains a selection of my system
configuration files. The word _dotfile_ is a colloquialism referring to
the leading `.` character used to hide a file on most Unix-like systems.

Initially, a single repository was sufficient for managing all of my
settings and configuration files, however I have since extracted certain
sections to independently versioned submodules:

- [My Neovim Configuration](https://github.com/afneville/nvim-config)
- [My Emacs Configuration](https://github.com/afneville/emacs-config)
- [My Theme Collection](https://github.com/afneville/b16-themes)

## Screenshot

![](./screenshots/sway.png)

## Installation

Install on a new machine (sudo required):

```bash
ansible-pull -U https://github.com/afneville/dotfiles.git -e "full_install=true" -K
```

Detect drift (drop `--check` to apply):

```bash
ansible-playbook local.yml --check -e "full_install=true" -K
```
