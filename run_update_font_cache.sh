#!/bin/sh

if [ "$(lsb_release -is)" != "Arch" ]; then
    exit
fi

if command -v fc-cache >/dev/null; then
    fc-cache
fi
