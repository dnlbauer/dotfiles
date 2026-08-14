#!/bin/bash

set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif command -v sudo >/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

echo "Installing packages"
echo "Updating sources..."
$SUDO apt update -qq

for package in zsh xsel unzip git git-extras neovim git ripgrep pipx age; do
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo $package is already installed.
    else
        echo Installing $package ...
        $SUDO apt install -y $package
    fi
done
