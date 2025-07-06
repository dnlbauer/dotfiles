#!/usr/bin/env sh

if [ ! -d "$HOME/.vim/autoload" ]; then
    echo "setup vim plug"
    curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
