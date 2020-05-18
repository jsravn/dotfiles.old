#!/bin/sh

. /etc/os-release
if [ "$ID" != "arch" ]; then
    exit
fi

if command -v fc-cache >/dev/null; then
    fc-cache
fi
