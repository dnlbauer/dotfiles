#!/usr/bin/env bash
set -e

# Install nbdime using pipx
if ! command -v pipx &> /dev/null; then
    echo "pipx not found. failed to install nbdime"
    exit 1
fi

if pipx list | grep -q nbdime; then
    echo "nbdime already installed. skipping."
    exit 0
fi

echo "Installing nbdime"
pipx install nbdime
