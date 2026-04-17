#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
BINARY_NAME="difft"
TARBALL="difft-x86_64-unknown-linux-gnu.tar.gz"
DOWNLOAD_URL="https://github.com/Wilfred/difftastic/releases/latest/download/${TARBALL}"

echo "Downloading difftastic..."
wget -q --show-progress -O "/tmp/${TARBALL}" "${DOWNLOAD_URL}"

echo "Extracting..."
tar -xzf "/tmp/${TARBALL}" -C /tmp

echo "Installing to ${INSTALL_DIR}..."
sudo mv "/tmp/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
sudo chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

echo "Cleaning up..."
rm -f "/tmp/${TARBALL}"

echo "difftastic installed successfully!"
difft --version
