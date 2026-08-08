#!/usr/bin/env bash

set -euo pipefail

if [ ! -d "$HOME/.fzf" ]; then
    echo "Installing fzf into ~/.fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    if [ ! -f "$HOME/.fzf/bin" ]; then
	$HOME/.fzf/install --completion --key-bindings --update-rc
    fi
fi

