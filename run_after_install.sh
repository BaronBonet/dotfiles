#!/bin/bash

# fzf for ctrl+r
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes  | ~/.fzf/install 

# Diff so fancy
brew install diff-so-fancy

# bat for nice cat highlighting
brew install bat
