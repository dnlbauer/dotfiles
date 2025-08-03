#!/usr/bin/env bash

if [ ! -f "$HOME/.local/bin/diff-so-fancy" ]; then
    echo "Installing diff-so-fance into .local/bin"
    if [ ! -d "$HOME/.local/lib/diff-so-fancy" ]; then
        mkdir -p $HOME/.local/lib
        git clone --depth 1 https://github.com/so-fancy/diff-so-fancy.git $HOME/.local/lib/diff-so-fancy
    fi
    ln -s $HOME/.local/lib/diff-so-fancy/diff-so-fancy $HOME/.local/bin/diff-so-fancy
fi
