#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DEST="/root/vcon/personal/dotfiles"
GPG_SSH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

if [[ ! -S "$GPG_SSH_SOCK" ]]; then
    echo "error: gpg ssh socket not found at $GPG_SSH_SOCK"
    exit 1
fi

declare -A BOOTSTRAP=(
    [archlinux]="pacman -Sy --noconfirm ansible git sudo openssh"
    [fedora]="dnf install -y ansible git sudo openssh-clients"
    [ubuntu]="apt-get update && apt-get install -y ansible git sudo openssh-client xz-utils"
)

IMAGES=("archlinux:latest" "fedora:latest" "ubuntu:latest")

for image in "${IMAGES[@]}"; do
    distro="${image%%:*}"
    echo "============================================"
    echo " Testing: $distro"
    echo "============================================"

    podman run --rm -t \
        --hostname dotfiles-test \
        -v "${SCRIPT_DIR}:/mnt/dotfiles:ro" \
        -v "${GPG_SSH_SOCK}:/run/user/0/gnupg/S.gpg-agent.ssh:ro" \
        -e SSH_AUTH_SOCK=/run/user/0/gnupg/S.gpg-agent.ssh \
        "$image" \
        bash -c "
            set -euo pipefail
            ${BOOTSTRAP[$distro]}

            mkdir -p /root/.ssh
            ssh-keyscan -t ed25519,ecdsa github.com >> /root/.ssh/known_hosts 2>/dev/null

            mkdir -p \$(dirname ${DOTFILES_DEST})
            cp -a /mnt/dotfiles ${DOTFILES_DEST}

            cd ${DOTFILES_DEST}
            git remote set-url origin https://github.com/afneville/dotfiles.git
            git submodule deinit --all -f
            rm -rf .git/modules

            ansible-playbook ${DOTFILES_DEST}/local.yml -e full_install=true
        "

    echo " $distro: PASSED"
    echo ""
done

echo "All tests passed."
