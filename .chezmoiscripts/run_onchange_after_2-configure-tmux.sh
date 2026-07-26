#!/bin/bash

set -eufo pipefail

# tpm must be a real git clone: it manages itself and the other plugins with git.
# (It used to be a chezmoi archive external, which made tpm's self-update fail.)
tpm_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"
if [ ! -d "$tpm_dir/.git" ]; then
	rm -rf "$tpm_dir"
	git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"
fi

# tms (tmux-sessionizer) comes from brew on darwin and a chezmoi external on linux
"$tpm_dir/scripts/install_plugins.sh"
