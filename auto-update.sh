#!/bin/bash
# adapted from: https://github.com/jez/dotfiles/blob/master/util/auto-update.sh	

# Number of seconds to wait before printing a reminder
UPDATE_THRESHOLD="604800" # 1 week

check_for_updates() {
  [ ! -e $HOME/.dotfiles_update ] && touch $HOME/.dotfiles_update
  # Initialize for when we have no GNU date available
  last_check=0
  time_now=0

  # Darwin uses BSD, check for gdate, else use date
  if [[ $(uname) = "Darwin" && -n $(which gdate) ]]; then
    last_login=$(gdate -r ~/.dotfiles_update +%s)
    time_now=$(gdate +%s)
  else
    # Ensure this is GNU grep
    if [ -n "$(date --version 2> /dev/null | grep GNU)" ]; then
      last_login=$(date -r ~/.dotfiles_update +%s)
      time_now=$(date +%s)
    fi
  fi

  time_since_check=$((time_now - last_login))

  if [ "$time_since_check" -ge "$UPDATE_THRESHOLD" ]; then
    echo $time_since_check
  else
    echo 0
  fi
}

update() {
  # Record that we've update
  touch $HOME/.dotfiles_update

  # Update dotfiles repo
  cd ~/.dotfiles/

  echo "Checking for updates..."
  git fetch --quiet origin
  if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/master)" ]; then
    echo "--> outdated."
    git pull
    ./install.sh
  else
    echo "--> nothing to do."
  fi

  cd - &> /dev/null
}

check=$(check_for_updates)
if [[ $check -gt 0 ]]; then
    echo "Dotfiles might be out of date."
    update
fi

