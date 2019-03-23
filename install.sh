#!/bin/bash

# Make ZSH the default shell environment
if [ `cat /etc/passwd | grep $USER | awk -F ':' '{print $7}'` != "/bin/zsh" ]; then
	echo "Changing shell to zsh"
	chsh -s $(which zsh)
fi

# ZIM Installation
if [ ! -d "$HOME/.zim" ]; then
	echo "Installing ZIM"
	git clone --recursive --depth=1 https://github.com/zimfw/zimfw.git \
		${ZDOTDIR:-${HOME}}/.zim
else
	echo "ZIM already exists."
fi

# Powerlevel9k Theme
if [ ! -d "$HOME/.zim/modules/prompt/external-themes/powerlevel9k" ]; then
	echo "Installing Powerlevel9k theme"
	git clone --depth=1 https://github.com/bhilburn/powerlevel9k.git \
		~/.zim/modules/prompt/external-themes/powerlevel9k
	ln -s ~/.zim/modules/prompt/external-themes/powerlevel9k/powerlevel9k.zsh-theme ~/.zim/modules/prompt/functions/prompt_powerlevel9k_setup
else
	echo "Powerlevel9k already exists."
fi

# linking base stuff
$HOME/.dotfiles/dotfiles.sh link base  

# TODO install anaconda
# TODO install fasd
# TODO install marker