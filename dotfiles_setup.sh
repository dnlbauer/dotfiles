#!/bin/bash
dir="${HOME}/dotfiles"
conffolder="${HOME}/.config"

dotfiles=(".pymolrc" ".pymol" ".vimrc" ".vim" ".vimrc" ".zshrc" ".zshrc_functions" ".zim" ".zimrc" ".gitconfig")
for dotfile in "${dotfiles[@]}"; do
	ln -sf $dir/$dotfile ${HOME}/${dotfile}
done

# fonts
mkdir -p ~/.config/fontconfig
ln -sf $dir/.config/fontconfig/fonts.conf $conffolder/fontconfig/fonts.conf

# matplotlib
ln -sf $dir/.config/matplotlib ~/.config/matplotlib
