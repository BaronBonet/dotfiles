#!/bin/bash

brew_install() {
	printf "\nInstalling $1"
	if brew list $1 &>/dev/null; then
		printf "\n${1} is already installed\n"
	else
		brew install $1 && printf "\n$1 is installed\n"
	fi
}

# fzf for ctrl+r
folder="~/.fzf"
if ! git clone --depth 1 https://github.com/junegunn/fzf.git "${folder}" 2>/dev/null && [ -d "${folder}" ]; then
	echo "Failed to clone fzf because directory ${fzfDirectory} exists"
else
	yes | ~/.fzf/install
fi

# This is abusing the purpose of run_after_install but works for now for installing these packages on a mac.
# TODO: get this working for a linux environment
which -s brew
if [[ $? != 0 ]]; then
	# Install Homebrew
	printf "Brew is not installed, installing brew \n"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	echo "Brew is available, attempting to install packages after upgrading brew"
	brew update
	# Diff so fancy
	brew_install "diff-so-fancy"

	# bat for nice cat highlighting
	brew_install "bat"

	# NVim
	brew_install "nvim"

	# For greping within nvim
	brew_install "ripgrep"

	# for linting dockerfiles
	brew_install "hadolint"

	# For nice output of json
	brew_install "jq"
fi
