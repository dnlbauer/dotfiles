# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi
export PATH=$PATH:/

# source my utility functions
source .zshrc_functions


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

# gromacs
if [ -z "$GMXRC" ]; then
    GMXRC="/opt/gromacs-cuda/bin/GMXRC"
fi
source $GMXRC


# python
PYTHONPATH="$PYTHONPATH:/opt/modeller/modlib:/opt/modeller/lib/x86_64-intel8/python3.3"
export PYTHONPATH
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/modeller/lib/x86_64-intel8"

export CUDA_HOME=/opt/cuda;
export TERMINAL="terminator"
export BROWSER="firefox"
export EDITOR="vim"
