#! /bin/zsh
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

export TERM="xterm-256color"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/dotfiles/prezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/dotfiles/prezto/init.zsh"
fi

# Customize to your needs...

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
DEFAULT_USER=$USER

# Kitty Terminal

KITTY_CONFIG_DIRECTORY="${HOME}/.kitty.conf"

autoload -Uz compinit
compinit

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

export LESS='-g -i -M -R -S -w -z-4'

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

source /usr/local/share/zsh/site-functions/pyenv.zsh

# GOPATH
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
