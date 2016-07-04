# Install native apps
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

function installcask() {
  brew cask install "${@}" 2> /dev/null
}

installcask google-chrome
installcask dropbox
installcask the-unarchiver
installcask vlc
installcask firefox
installcask bettertouchtool
