#!/bin/bash

if ! command -v brew &>/dev/null; then
	echo 'Brew is not installed, installing brew'
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	echo "Brew is available, upgrading brew"
	brew update
fi
