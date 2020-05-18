#!/bin/sh

if [ "$(lsb_release -is)" != "Arch" ]; then
    exit
fi

set -eu

if command -v pacman >/dev/null; then
  sudo pacman -Sy --noconfirm go
fi
export GOPATH=$HOME/go
mkdir -p $GOPATH
go get github.com/motemen/gore/cmd/gore
go get github.com/mdempsky/gocode
go get golang.org/x/tools/cmd/godoc
go get golang.org/x/tools/cmd/goimports
go get golang.org/x/tools/cmd/gorename
go get golang.org/x/tools/cmd/guru
go get github.com/fatih/gomodifytags
go get github.com/cweill/gotests/...
GO111MODULE=on go get golang.org/x/tools/gopls@master golang.org/x/tools@master
