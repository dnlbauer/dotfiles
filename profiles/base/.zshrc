export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh 

if [ z "$GMXRC" ]; then
    source $GMXRC
fi

# source $HOME/bin/antigen.zsh
# antigen init $HOME/.antigenrc

# source other dotfiles
source $HOME/.environment
if [ -f "$HOME/.environment.local" ]; then
	source $HOME/.environment.local
fi
source $HOME/.aliases
source $HOME/.functions
# config specific to this machine
if [ -f $HOME/.zshrc_local ]; then
    source $HOME/.zshrc_local
fi

# fasd autocompletion
eval "$(fasd --init auto)"

# marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

