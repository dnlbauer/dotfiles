# fzf
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    if [ ! -f "$HOME/.fzf/bin" ]; then
	$HOME/.fzf/install --completion --key-bindings --update-rc
    fi
fi

# diff-so-fancy
if [ ! -f "$HOME/.local/bin/diff-so-fancy" ]; then
    if [ ! -d "$HOME/.local/lib/diff-so-fancy" ]; then
        git clone --depth 1 https://github.com/so-fancy/diff-so-fancy.git $HOME/.local/lib/diff-so-fancy
    fi
    ln -s $HOME/.local/lib/diff-so-fancy/diff-so-fancy $HOME/.local/bin/diff-so-fancy
fi

# vimplug
if [ ! -d "$HOME/.vim/autoload" ]; then
    echo "setup vim plug"
    curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# install rust
if [ ! -d "$HOME/.cargo" ]; then
    echo "setup cargo"
    curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y --profile minimal -q
fi

# install some rust packages
for package in ripgrep bat; do
    echo "setup $package"
    $HOME/.cargo/bin/cargo install -q $package
done

# linking dotfiles
$HOME/.dotfiles/dotfiles.sh link base

if ! type zsh > /dev/null; then
    echo "Cannnot change default shell to zsh: not installed"
else
    # Make ZSH the default shell environment
    if [ $(cat /etc/passwd | grep $USER | awk -F ':' '{print substr($7, length($7)-3)}') != "/zsh" ]; then
        echo "Changing shell to zsh"
        chsh -s $(which zsh)
    fi

    # Antidote Installation
    if [ ! -d "$HOME/.antidote" ]; then
        echo "Installing antidote"

        # make sure git is installed
        if ! type git > /dev/null; then
            echo "Git not installed. Cannot install antidote"
	else
             git clone --depth=1 https://github.com/mattmc3/antidote.git $HOME/.antidote
        fi

    else
	echo "antidote already exists."
    fi
    
fi



