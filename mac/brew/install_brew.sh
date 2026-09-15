#!/bin/bash

echo "Installing Homebrew ..."
which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Run brew update ..."
brew update

echo "Ok. Run brew upgrade ..."
brew upgrade

brew bundle --file="$(dirname "$0")/.Brewfile"

brew cleanup
