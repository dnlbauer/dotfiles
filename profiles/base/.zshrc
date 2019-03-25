if [ -f `which powerline-daemon` ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh
fi

# Change default zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh 

# source other dotfiles
source $HOME/.environment
if [ -f "$HOME/.environment.local" ]; then
	source $HOME/.environment.local
fi

source $HOME/.aliases
source $HOME/.functions

if [ -z "$GMXRC" ]; then
    GMXRC="/opt/gromacs-2018/bin/GMXRC"
fi
source $GMXRC

# config specific to this machine
if [ -f $HOME/.zshrc_local ]; then
    source $HOME/.zshrc_local
fi

# fasd autocompletion
eval "$(fasd --init auto)"

# marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"
