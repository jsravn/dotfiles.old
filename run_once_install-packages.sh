#!/bin/sh

set -eu

if command -v pacman > /dev/null; then
    sudo pacman -Sy --noconfirm --needed \
        ripgrep \
        zsh \
        chromium \
        editorconfig-core-c \
        fd \
        fzf \
        pyenv \
        zsh-autosuggestions \
        zsh-syntax-highlighting
fi

if command -v yay > /dev/null; then
    yay -S zsh-theme-powerlevel10k-git
fi

if command -v brew > /dev/null; then
    brew install ripgrep fd fzf
fi
