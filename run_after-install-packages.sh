#!/bin/bash

# TODO: This is run every time we do a `ch apply`, it would be nicer to break it apart so parts of it only run when needed
# https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#install-packages-with-scripts
# NOTE: Can use  $(chezmoi source-path) to go to chemozi root

if ! command -v brew &>/dev/null; then
	echo 'Brew is not installed, installing brew'
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	echo "Brew is available, upgrading brew"
	brew update
fi

# Install & update brew packages
brew bundle --file=~/.config/Brewfile

# Source tmux plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install debugpy for python debugging in neovim
install_debugpy() {
	echo "configuring python virtual environment for debugpy"
	mkdir -p "$HOME/.virtualenvs"

	cd "$HOME/.virtualenvs" || {
		echo "Failed to change directory to ~/.virtualenvs"
		return 1
	}

	if command -v python >/dev/null 2>&1; then
		python -m venv debugpy
	else
		echo "Python is not installed or not in the PATH"
		return 1
	fi

	if [ -d "debugpy" ]; then
		debugpy/bin/python -m pip install debugpy
	else
		echo "Failed to create virtual environment for debugpy"
		return 1
	fi
}

if [ -d "$HOME/.asdf" ]; then
	echo "asdf already exists, skipping clone"
else
	# Check for latest here: https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
fi

# Function to conditionally install a language
conditionally_install_language() {
	local lang=$1
	if ! asdf plugin-list | grep -q "$lang"; then
		asdf plugin-add "$lang"
	fi

	echo "Checking if $lang is managed by asdf"
	local lang_versions
	lang_versions=$(asdf list "$lang")

	if [[ "$lang_versions" == "" ]]; then
		echo "$lang is not managed by asdf, installing global version of $lang with asdf"
		echo "Fetching available $lang versions..."

		available_versions=$(asdf list-all "$lang" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$')

		echo "Select a version to install (e.g. 187, the number next to the $lang version):"
		select version in "${available_versions[@]}"; do
			if [ "$version" != "" ]; then
				echo "Installing $lang $version"
				asdf install "$lang" "$version"
				asdf global "$lang" "$version"
				break
			else
				echo "Invalid selection. Please try again."
			fi
		done

		manage_tool_version "$lang" "$version"

		if [ "$lang" == "python" ]; then
			echo "Installing neovim for Python"
			pip install neovim
			# Install poetry for Python project management
			curl -sSL https://install.python-poetry.org | python3 -

			install_debugpy || echo "Installing debugpy failed"
    # TODO: it would be better to have this be a seperate script that always runs when somethign changes
		elif [ "$lang" == "ruby" ]; then
			echo "Installing bundler for Ruby"
			gem install bundler
			gem install rubocop
			gem install neovim
		fi

		return 1
	else
		echo "$lang is already managed by asdf, continuing"
		return 0
	fi
}

manage_tool_version() {
	local lang=$1
	local version=$2
	local tool_versions_file=~/.tool-versions

	check_tool_version() {
		grep -E "^$lang [0-9]+\.[0-9]+\.[0-9]+$" "$tool_versions_file"
	}

	[ ! -f "$tool_versions_file" ] && echo "Creating $tool_versions_file..." && touch "$tool_versions_file"

	local current_version
	current_version=$(check_tool_version)

	update_tool_version() {
		if [ "$current_version" != "" ]; then
			sed -i '' "s/^$lang [0-9]\+\.[0-9]\+\.[0-9]\+\$/$lang $version/" "$tool_versions_file"
		else
			echo "$lang $version" >>"$tool_versions_file"
		fi
	}

	if [ "$current_version" != "" ]; then
		echo "Current $lang version in .tool-versions: $current_version"
		read -pr "Do want to overwrite it with $lang $version? (y/n): " confirm
		if [ "$confirm" = "y" ]; then
			update_tool_version
			echo "$lang version updated to $version in .tool-versions."
		else
			echo "No changes made to .tool-versions."
		fi
	else
		update_tool_version
		echo "$lang version $version added to .tool-versions."
	fi
}

conditionally_install_language python || echo "Conditionally installing Python failed"
conditionally_install_language ruby || echo "Conditionally installing Ruby failed"

# Install tms for convenient tmux session
if ! command -v tms >/dev/null 2>&1; then
	echo "Installing tms for tmux session management"
	cargo install tmux-sessionizer
fi
