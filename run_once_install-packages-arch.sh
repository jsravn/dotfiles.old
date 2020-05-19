#!/bin/sh

. /etc/os-release
if [ "$ID" != "arch" ]; then
    exit
fi

set -eu

if command -v pacman > /dev/null; then
    sudo pacman -Sy --noconfirm --needed \
        ripgrep \
        zsh \
        chromium \
        editorconfig-core-c \
        fd \
        fzf \
        pyenv
fi

if command -v brew > /dev/null; then
    brew install ripgrep fd fzf
fi
