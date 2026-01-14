#!/usr/bin/env bash
set -euo pipefail

FONT_DIR="${HOME}/.local/share/fonts"
TEMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

mkdir -p "$FONT_DIR"

echo "Installing fonts to ${FONT_DIR}..."

# Install Nerd Fonts
NERD_FONTS_VERSION="v3.4.0"
NERD_FONTS=(
    "UbuntuMono"
    "SourceCodePro"
    "AtkinsonHyperlegibleMono"
)

for font in "${NERD_FONTS[@]}"; do
    echo "Downloading ${font} Nerd Font..."
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/${font}.zip" -o "${TEMP_DIR}/${font}.zip"

    unzip -q "${TEMP_DIR}/${font}.zip" -d "${TEMP_DIR}/${font}"

    # Copy only TTF and OTF files, excluding Windows-compatible versions
    find "${TEMP_DIR}/${font}" -type f \( -name "*.ttf" -o -name "*.otf" \) ! -name "*Windows Compatible*" -exec cp {} "${FONT_DIR}/" \;

    echo "Installed ${font} Nerd Font"
done

# Install Inter (sans-serif)
echo "Downloading Inter..."
curl -fsSL "https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip" -o "${TEMP_DIR}/Inter.zip"
unzip -q "${TEMP_DIR}/Inter.zip" -d "${TEMP_DIR}/inter"
find "${TEMP_DIR}/inter" -path "*/Inter Desktop/*.ttf" -exec cp {} "${FONT_DIR}/" \;
echo "Installed Inter"

# Install Charis SIL
echo "Downloading Charis SIL..."
CHARIS_VERSION="6.200"
curl -fsSL "https://software.sil.org/downloads/r/charis/CharisSIL-${CHARIS_VERSION}.zip" -o "${TEMP_DIR}/CharisSIL.zip"

unzip -q "${TEMP_DIR}/CharisSIL.zip" -d "${TEMP_DIR}/charis"
find "${TEMP_DIR}/charis" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "${FONT_DIR}/" \;

echo "Installed Charis SIL"

# Update font cache
echo "Updating font cache..."
fc-cache -f "$FONT_DIR"
echo "Done"

