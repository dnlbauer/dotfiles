#!/bin/bash

# Make ZSH the default shell environment
if [ `cat /etc/passwd | grep $USER | awk -F ':' '{print $7}'` != "/usr/bin/zsh" ]; then
	echo "Changing shell to zsh"
	chsh -s $(which zsh)
fi

# zgen Installation
if [ ! -d "$HOME/.zgen" ]; then
	echo "Installing zgen"
	git clone --depth=1 https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
else
	echo "zgen already exists."
fi

# Conda and pip
if [ ! -d "$HOME/conda" ]; then
	echo "Installing Conda"
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
	bash /tmp/miniconda.sh -b -p ~/conda 
	rm /tmp/miniconda.sh
	echo "yes" | conda install pip
else
	echo "Conda already installed"
fi

# Marker
if [ ! -d "$HOME/.marker" ]; then
	echo "Installing Marker"
	git clone --depth=1 https://github.com/pindexis/marker $HOME/.marker
	$HOME/.marker/install.py
fi

# fasd 
if [ ! -d "$HOME/bin" ]; then
	mkdir -p $HOME/bin
fi
if [ ! -f "$HOME/bin/fasd" ]; then
	echo "Installing fasd"
	wget https://raw.githubusercontent.com/clvv/fasd/master/fasd
	mv fasd $HOME/bin/fasd
	chmod +x $HOME/bin/fasd
fi

# vundle
if [ ! -d "$HOME/.vim/bundle" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# linking dotfiles
$HOME/.dotfiles/dotfiles.sh link base  

