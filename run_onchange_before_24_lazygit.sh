#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"

VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

curl -fsSL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${VERSION}_Linux_x86_64.tar.gz" | tar -xz -C /tmp lazygit

mkdir -p "$INSTALL_DIR"
mv /tmp/lazygit "$INSTALL_DIR/"

echo "Installed lazygit v${VERSION} to ${INSTALL_DIR}/lazygit"
