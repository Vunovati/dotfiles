#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

TERM="xterm-256color" # Fixes color issues
eval `dircolors /home/evlaada/dotfiles/colors/dircolors.256dark`
export TERM=screen-256color       # for a tmux -2 session (also for screen)

alias tmux="TERM=screen-256color-bce tmux"
. ~/aliases.zsh

