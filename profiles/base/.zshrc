# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -f $HOME/.zshrc_local ]; then
    source $HOME/.zshrc_local
fi

ENV_FILE="$HOME/.environment"
LOCAL_ENV_FILE="$HOME/.environment.local"

ALIAS_FILE="$HOME/.aliases"
LOCAL_ALIAS_FILE="$HOME/.aliases.local"

source $ENV_FILE
if [ -f $LOCAL_ENV_FILE ]; then
    source $LOCAL_ENV_FILE
fi
source $ALIAS_FILE
if [ -f $LOCAL_ALIAS_FILE ]; then
    source $LOCAL_ALIAS_FILE
fi

autoload -U +X compinit && compinit # fix compdef not found
source $HOME/.antidote/antidote.zsh
antidote load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# vim mode
bindkey -v

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^f' fzf-file-widget 

$HOME/.dotfiles/auto-update.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"  # Load cargo env
