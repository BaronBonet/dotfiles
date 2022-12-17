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
	curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
	tar xzf nvim-macos.tar.gz
	./nvim-macos/bin/nvim

        
	# TODO: would be nice if these were managed by chmozi
	# Packer plugin manager
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
		 ~/.config/.local/share/nvim/site/pack/packer/start/packer.nvim

	# For greping within nvim
	brew install ripgrep
fi
