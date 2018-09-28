if [ -f `which powerline-daemon` ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh
fi

# gromacs needs to be before ZIM for autocompletion
if [ -z "$GMXRC" ]; then
    GMXRC="/opt/gromacs-2018/bin/GMXRC"
fi
source $GMXRC

# Change default zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh 

# preferences
export LANG=en_US.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="~/.ssh/rsa_id"
export TERMINAL="terminator"
export BROWSER="firefox"
export PAGER='most'

# alter path
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/anaconda3/bin:${PATH}" # binaries
export PATH="$HOME/bin:${PATH}" # binaries
export PATH="$HOME/scripts:${PATH}" # scripts
export PATH="$HOME/.local/bin:${PATH}" # python executeables

# aliases
alias clip='xsel --clipboard'
alias groclean='rm \#*'
alias sm='snakemake'
alias ls='ls -lh'
alias workon='source activate' # enable anaconda environ

# config specific to this machine (not copied from dotfiles)
if [ -f $HOME/.zshrc_local ]; then
    source $HOME/.zshrc_local
fi

# fasd autocompletion
eval "$(fasd --init auto)"

# marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

