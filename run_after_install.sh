#!/bin/bash

# fzf for ctrl+r to fuzzy find search history
folder="$HOME/.fzf"
if ! git clone --depth 1 https://github.com/junegunn/fzf.git "${folder}" 2>/dev/null && [ -d "${folder}" ]; then
	echo "Failed to clone fzf because fzf directory exists"
else
	yes | ~/.fzf/install
fi

which -s brew
if ! $?; then
	# Install Homebrew
	printf "Brew is not installed, installing brew \n"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	echo "Brew is available, attempting to install packages after upgrading brew"
	brew update
	brew tap Homebrew/bundle
	brew bundle
fi
