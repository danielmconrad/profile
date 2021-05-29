#!/bin/zsh

# MacOS Specific
if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="$PATH:$(brew --prefix)/sbin"
  export PATH="$PATH:$(brew --prefix)/bin"

  export LDFLAGS="-L$(brew --prefix)/opt/zlib/lib"
  export CPPFLAGS="-I$(brew --prefix)opt/zlib/include"
fi
