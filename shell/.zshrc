

#
# User configuration sourced by interactive shells
#

# Change default zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

export LANG=en_US.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="~/.ssh/rsa_id"
export TERMINAL="terminator"
export BROWSER="firefox"

source ~/.zshrc_functions
source ~/.zshrc_local

# alter path
export PATH="$HOME/bin:${PATH}" # binaries
export PATH="$HOME/scripts:${PATH}" # scripts
export PATH="$HOME/.local/bin:${PATH}" # python executeables

# fasd autocompletion
eval "$(fasd --init auto)"

# marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# the fuck?
eval $(thefuck --alias)
