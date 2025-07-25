#!/usr/bin/env bash

if ! type zsh > /dev/null; then
    echo "Cannnot change default shell to zsh: not installed"
else
    # Make ZSH the default shell environment
    if [ $(cat /etc/passwd | grep $USER | awk -F ':' '{print substr($7, length($7)-3)}') != "/zsh" ]; then
        echo "Changing shell to zsh."
        chsh -s $(which zsh)
    else
        echo "Shell is already zsh."
    fi

    # Antidote Installation
    if [ ! -d "$HOME/.antidote" ]; then
        echo "Installing Antidote"

        # make sure git is installed
        if ! type git > /dev/null; then
            echo "Git not installed. Cannot install antidote"
	else
             git clone --depth=1 https://github.com/mattmc3/antidote.git $HOME/.antidote
        fi

    else
	echo "Antidote already exists."
    fi
    
fi
