#!/bin/bash

set -eufo pipefail

# Dock
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock tilesize -int 64
defaults write com.apple.dock autohide -int 1

killall Dock
