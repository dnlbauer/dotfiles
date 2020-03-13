#export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
#[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh 
#source $HOME/bin/antigen.zsh
#antigen init $HOME/.antigenrc
source "${HOME}/.zgenrc"

# source other dotfiles
source $HOME/.environment
if [ -f "$HOME/.environment.local" ]; then
    source $HOME/.environment.local
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/bauer/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/bauer/conda/etc/profile.d/conda.sh" ]; then
        . "/home/bauer/conda/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:/home/bauer/conda/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source $HOME/.aliases
# config specific to this machine
if [ -f $HOME/.zshrc_local ]; then
    source $HOME/.zshrc_local
fi

if [ -n "$GMXRC" ]; then
    source $GMXRC
fi

# fasd autocompletion
eval "$(fasd --init auto)"

# marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# snakemake autocomplete
#if hash snakemake 2>/dev/null; then
#    compdef _gnu_generic snakemake
#fi
