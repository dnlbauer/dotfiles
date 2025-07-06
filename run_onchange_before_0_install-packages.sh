#!/bin/bash

set -e

echo "Installing packages"
sudo apt update -qq

for package in git neovim git ripgrep; do
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo $package is already installed.
    else
        echo Installing $package
        sudo apt install -y $package
    fi
done
