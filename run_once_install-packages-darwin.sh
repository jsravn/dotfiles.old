#!/bin/sh

. /etc/os-release

if command -v brew > /dev/null; then
    brew install ripgrep fd fzf
fi
