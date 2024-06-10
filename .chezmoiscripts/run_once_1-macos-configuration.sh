#!/bin/bash

set -eufo pipefail

# Dock
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock tilesize -int 32

killall Dock
