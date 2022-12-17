#!/bin/bash

# fzf for ctrl+r
folder="~/.fzf"
if ! git clone --depth 1 https://github.com/junegunn/fzf.git "${folder}" 2>/dev/null && [ -d "${folder}" ]; then
    echo "Failed to clone fzf because directory ${fzfDirectory} exists"
else
    yes  | ~/.fzf/install
fi


if ! brew update 2>/dev/null; then
    echo "Something is wrong with brew, perhaps it is not installed or you don't have permission."
else
	# Diff so fancy
	brew install diff-so-fancy

	# bat for nice cat highlighting
	brew install bat

	# NVim
	brew install neovim

	# Plugin manager vim-plug: https://github.com/junegunn/vim-plug
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	echo "Vim plug installed be sure to run ':PlugInstall' next time you use neovim."

	echo "Trying to install coco, you may need to install yarn for this to work"
	cd ~/.config/.local/share/nvim/plugged/coco.nvim && yarn install
fi
