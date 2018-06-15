#!/bin/bash

set -e

YELLOw='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

main (){
  install_git
  install_profile
  install_node
  install_ruby
}

install_git() {
  sudo apt-get install git
}

install_profile() {
  installing "Profile"
  git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
  printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc

  homeshick clone -f -b git@github.com:danmconrad/profile.git
  homeshick link profile
  touch ~/.bashrc

  if grep -q ".conrad-profile" "$HOME/.bashrc"; then
    log "Bash Profile already sources .conrad-profile"
  else
    log "Sourcing .conrad-profile in .bashrc"
    printf '\nsource "$HOME/.conrad-profile"' >> $HOME/.bashrc
  fi
}

install_node() {
  installing "Node"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

  nvm install carbon
  nvm alias default carbon
}

install_ruby() {
  installing "Ruby"
  sudo apt-get install rbenv ruby-build
  eval "$(rbenv init -)"

  rbenv install 2.4.0
  rbenv global 2.4.0
  gem install bundler foreman --no-ri --no-rdoc
  eval "$(rbenv init -)"
}

installing() {
  printf "${YELLOw}[PROFILE]${NC} $1\n"
}
log() {
  printf "${BLUE}[PROFILE]${NC} $1\n"
}

main
