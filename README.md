# Eric's dotfiles

Managed using [chezmoi](https://www.chezmoi.io/). Attempting to keep my dotfiles synced across my personal and work machines (macOS) and my home server (Ubuntu).

I wouldn't suggest anyone other than myself use these dot files as is, I've littered my configs (e.g. `.gitconfig`) with personal information. Feel free to browse these files and copy what you like.

## Getting started

The majority of my dotfiles exist in `~/.config/` in order to get chezmoi to copy itself to the correct location open a terminal and run:

```shell
export XDG_CONFIG_HOME="$HOME/.config"
```

Then run this one liner (taken from [chezmoi.io](https://www.chezmoi.io/)), to clone and apply my dotfiles. Xcode may need to be installed for this to work, it will prompt you to install it if required. If brew in not installed it will also be installed as well, if you're prompted to add anything to your .bashrc file after installing brew be sure to do so.

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply BaronBonet
```

This should copy all my dotfiles to their respective locations, and run the [install script](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/) found here. This script installs brew, all of my brew packages as well as the interpreted languages I'm currently using (Python and Ruby) managed by [asdf](https://asdf-vm.com/).

## Ubuntu home server

The same one-liner works on Ubuntu (tested against 24.04):

```bash
export XDG_CONFIG_HOME="$HOME/.config"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply BaronBonet
```

What happens differently on linux (see `.plans/2026-07-17-linux-support.md` for the design):

- Base packages come from apt (`sudo` password is prompted once); tools apt ships too old
  (neovim, lsd, delta, zoxide, tms, fastfetch, gh, fzf) are downloaded as pinned release
  binaries into `~/.local/bin` by chezmoi externals. Bump versions in `.chezmoidata/packages.yaml`.
- No dev toolchain: brew, asdf, 1Password, and the macOS defaults scripts are darwin-only.
- The login shell is switched to zsh (`chsh` prompts for your password).
- SSH/git auth uses agent forwarding from the Mac — no keys live on the server. Add
  `ForwardAgent yes` to the server's entry in the Mac's `~/.ssh/config.d/`.
- Git commit signing is disabled on linux (1Password's `op-ssh-sign` is mac-only).

### Further setup

There are a number of applications that will require a bit of manual setup.

#### Alacrity - Terminal

Alacrity doesn't want to open the 1st time follow [this guys advice](https://github.com/alacritty/alacritty/issues/6500#issuecomment-1356318595):

1. Right click the [alacrity] icon (on the apple menu) and hit open
2. Click openNuances with installing packages on the dialog that appears

#### Raycast - Better shortcuts

Open raycast, authorize it and go through the initial setup process.

#### Rectangle - Window resizer

Open rectangle, authorize it. The settings should be taken from the ones coped by chezmoi.

#### Github cli

Helpful tools to interact with github via the terminal. Also greatly increases the rate limit for Mason.

```bash
 gh auth login
```

To enable copilot in nvim, when you 1st open nvim run `:Copilot auth` and follow the instructions.

#### tmux

Install tmux plugins with  `prefix` + I

## Working with chezmoi

For any file managed by chezmoi you can use the following commands to interact with them:

- `ch diff <file>` to see the changes between the current file and the chezmoi managed file
- `ch add <file>` to add the file to chezmoi

To apply the changes from the managed files from chezmoi to your local files use:

- `ch diff` to see the changes that will be applied
- `ch apply` to apply the changes

Regularly run `ch apply` to ensure your managed dot files are not too far behind. It will notify you what it will modify (so what you haven't updated in chemozi). If that's the case then add the file/folder with `ch add`

If you want to run all of the scripts in `.chezmoiscripts` then [clear the state of the scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#clear-the-state-of-all-run_onchange_-and-run_once_-scripts) with:

```shell
chezmoi state delete-bucket --bucket=entryState
chezmoi state delete-bucket --bucket=scriptState
```
