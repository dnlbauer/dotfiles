#!/bin/bash

set -e

echo "Installing packages"
echo "Updating sources..."
sudo apt update -qq

for package in zsh xsel unzip git git-extras neovim git ripgrep pipx; do
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo $package is already installed.
    else
        echo Installing $package ...
        sudo apt install -y $package
    fi
done
