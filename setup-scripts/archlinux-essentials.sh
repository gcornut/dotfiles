#!/bin/sh
set -e

echo "Update packages..."
yaourt -Syua --noconfirm

echo "Installing miscs..."
yaourt -S --noconfirm \
       make \
       python python2 \
       vim \
       jq \
       tldr-cpp-client

echo "Installing zsh..."
yaourt -S --noconfirm zsh 
chsh -s /bin/zsh

echo "Installing emacs & cask..."
yaourt -S --noconfirm emacs cask
cd ~/.emacs.d/
make
cd -
