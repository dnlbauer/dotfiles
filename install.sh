#!/bin/bash

# Make ZSH the default shell environment
if [ `cat /etc/passwd | grep $USER | awk -F ':' '{print $7}'` != "/bin/zsh" ]; then
	echo "Changing shell to zsh"
	chsh -s $(which zsh)
fi

# linking base stuff
$HOME/.dotfiles/dotfiles.sh link base  
