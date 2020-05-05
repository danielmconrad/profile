#!/bin/sh

set -e

YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

main (){
  sudo echo ""

  section "Prerequisites"
  set_macos_defaults
  install_homebrew
  install_profile
  install_shell

  section "Apps with Config"
  install_git
  install_code
  install_iterm2
  install_spectacle

  section "Other Apps"
  install vim
  install_cask balenaetcher
  install_cask dashlane
  install_cask discord
  install_cask docker
  install_cask google-chrome
  install_cask imageoptim
  install_cask licecap
  install_cask signal
  install_cask slack
  install_cask spotify
  install_cask tableplus

  section "Clean Up"
  brew doctor
  zsh -c "autoload -U compaudit && compaudit | xargs chmod g-w,o-w"

  section "Finished!"
}

set_macos_defaults() {
  defaults write com.apple.screencapture location ~/Downloads
  defaults write com.apple.screencapture show-thumbnail -bool FALSE
  defaults write com.apple.dock mru-spaces -bool FALSE
  defaults write com.apple.dock show-recents -bool FALSE

  echo $(xcode-select --install 2>/dev/null)
}

install_homebrew() {
  if hash brew 2>/dev/null; then
    return
  fi

  CI=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_profile() {
  echo "Removing profile"
  rm -rf ~/.homesick/repos/profile

  install homeshick

  homeshick clone -f -b danielmconrad/profile
  homeshick pull profile
  homeshick link profile

  touch ~/.zprofile
  touch ~/.zshrc

  if grep -q ".con/.zprofile" "$HOME/.zprofile"; then
    log ".zprofile already sources .con/.zprofile"
  else
    log "Sourcing .con/.zprofile in .zprofile"
    echo 'source "$HOME/.con/.zprofile"\n' | cat - "$HOME/.zprofile" > temp && mv temp "$HOME/.zprofile"
  fi

  if grep -q ".con/.zshrc" "$HOME/.zshrc"; then
    log ".zshrc already sources .con/.zshrc"
  else
    log "Sourcing .con/.zshrc in .zshrc"
    echo 'source "$HOME/.con/.zshrc"\n' | cat - "$HOME/.zshrc" > temp && mv temp "$HOME/.zshrc"
  fi
}

install_shell() {
  install zsh

  rm -rf ~/.oh-my-zsh

  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) 2>/dev/null"

  cd ~/.oh-my-zsh
  git reset --hard HEAD

  sudo chsh -s "$(brew --prefix)/bin/zsh"

  mv ~/.zshrc ~/.zshrc.oh-my-zsh-defaults
  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
}

install_git() {
  install git
  git config --global user.name "Daniel Conrad"
  git config --global user.email daniel.m.conrad@gmail.com
}

install_code() {
  install_cask visual-studio-code
  mkdir -p ~/Library/Application\ Support/Code/User/
  yes | cp -rf ~/.homesick/repos/profile/configs/code/settings.json ~/Library/Application\ Support/Code/User/settings.json
}

install_spectacle() {
  install_cask spectacle
  mkdir -p ~/Library/Application\ Support/Spectacle/
  yes | cp -rf ~/.homesick/repos/profile/configs/spectacle/Shortcuts.json ~/Library/Application\ Support/Spectacle/Shortcuts.json
}

install_iterm2() {
  install_cask iterm2
  yes | cp -rf ~/.homesick/repos/profile/configs/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
}

install() {
  brew uninstall $1 || echo "$1 uninstalled"
  brew install -f $1
}

install_cask() {
  brew cask uninstall $1 || echo "$1 uninstalled"
  brew cask install -f $1
}

section() {
  echo
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  printf "${YELLOW}[PROFILE]${NC} $1\n"
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo
}

log() {
  printf "${BLUE}[PROFILE]${NC} $1\n"
}

main
