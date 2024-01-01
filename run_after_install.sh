#!/bin/bash

# Function to install Homebrew packages
brew_install() {
	printf "\nInstalling $1"
	if brew list $1 &>/dev/null; then
		printf "\n${1} is already installed\n"
	else
		brew install $1 && printf "\n$1 is installed\n"
	fi
}

# Clone and install fzf
folder="$HOME/.fzf"
if [ ! -d "${folder}" ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git "${folder}"
	"${folder}/install" --all
else
	echo "fzf is already installed"
fi

# Determine OS and install packages
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "Installing packages for Ubuntu"

	sudo apt update
	sudo apt install -y bat ripgrep jq neovim zsh build-essential diff-so-fancy
	wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
	export PATH=$PATH:/usr/local/go/bin

elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Installing packages for macOS"

	# Install Homebrew if not installed
	if ! command -v brew &>/dev/null; then
		echo "Installing Homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	brew update
	brew_install "diff-so-fancy"
	brew_install "bat"
	brew_install "nvim"
	brew_install "ripgrep"
	brew_install "jq"

else
	echo "Unsupported OS"
fi
