#!/bin/bash

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
