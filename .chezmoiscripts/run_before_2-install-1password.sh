#!/bin/sh
# exit immediately if 1Password CLI (op) is already in $PATH
type op >/dev/null 2>&1 && exit
echo "Installing 1Password CLI..."
brew install --cask 1password
brew install 1password-cli
if ! command -v op >/dev/null 2>&1; then
	echo "1Password CLI installation failed."
	exit 1
fi
echo "1Password CLI installed successfully. Version: $(op --version)"
echo "Please complete the following steps in the 1Password desktop app, also found https://developer.1password.com/docs/cli/get-started:"
echo "1. Open and unlock the 1Password app."
echo "2. Click your account or collection at the top of the sidebar."
echo "3. Navigate to Settings > Developer."
echo "4. Select 'Integrate with 1Password CLI', also use the SSH agent, no need to copy the command since it's already in our .ssh/config file."
echo "5. If you want to authenticate 1Password CLI with your fingerprint, turn on Touch ID in the app."
echo "Press Enter to continue after completing these steps."
read -r
echo "Verifying 1Password CLI integration..."
if op vault list >/dev/null 2>&1; then
	echo "1Password CLI integration successful."
else
	echo "1Password CLI integration failed. Please ensure you have completed the steps correctly."
	exit 1
fi
