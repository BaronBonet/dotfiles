#!/bin/bash

~/.tmux/plugins/tpm/scripts/install_plugins.sh
# Install tms for convenient tmux session
if ! command -v tms >/dev/null 2>&1; then
	echo "Installing tms for tmux session management"
	cargo install tmux-sessionizer
fi
