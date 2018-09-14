if [ -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh ]; 
then
       	source /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh 
fi


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
export PAGER='most'

source ~/.zshrc_functions
if [ -f $HOME/.zshrc_local ]; 
then
source $HOME/.zshrc_local
fi

# alter path
export PATH="/opt/pymol:${PATH}"
export PATH="$HOME/anaconda3/bin:${PATH}" # binaries
export PATH="$HOME/bin:${PATH}" # binaries
export PATH="$HOME/scripts:${PATH}" # scripts
export PATH="$HOME/.local/bin:${PATH}" # python executeables

# fasd autocompletion
eval "$(fasd --init auto)"

# marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# clipboard
alias clip='xsel --clipboard'

alias groclean='rm \#*'
alias sm='snakemake'
alias ls='ls -lh'
alias workon='source activate' # enable anaconda environ
