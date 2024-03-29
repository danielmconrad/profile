#!/bin/zsh

# Homeshick
if [[ "$(uname)" == "Darwin" ]]; then
  export HOMESHICK_DIR="$(brew --prefix)/opt/homeshick"
  source "$(brew --prefix)/opt/homeshick/homeshick.sh"
fi

# Oh My ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"
plugins=(git ssh-agent)
autoload -Uz compinit && compinit

# - Make
zstyle ':completion:*:*:make:*' tag-order 'targets'

# - SSH
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

source $ZSH/oh-my-zsh.sh

# Editor
export EDITOR="vim"
if [[ "$(uname)" == "Darwin" ]]; then
  export EDITOR="code --wait"
fi

# Prompt & Cursor
setopt promptsubst
PS1=$'%{\e(0%}${(r:$COLUMNS::q:)}%{\e(B%}'$PS1
echo -ne '\e[5 q'

# Bindings
autoload -U select-word-style select-word-style bash
bindkey "^[[1;9C" forward-word
bindkey "^[[1;9D" backward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

# Utilities
source "$HOME/.con/.aliases"
