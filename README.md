# Dotfiles


## Getting started

Dotfiles are managed using [chezmoi](https://www.chezmoi.io/).

To initialize the dotfiles repo:

```bash
chezmoi init --apply git@github.com:BaronBonet/dotfiles.git
```

This should create a `~/.config` folder with all of my dotfiles, along with a few other files in the home directory e.g. `~/.zshenv`

You'll have to manually source the `.zshrc` the first time.

```bash
source ~/.config/zsh/.zshrc
```

## Hints

Keep in mind external packages are being managed by chezmoi so they may need to be refreshed.

- `chezmoi --refresh-externals apply`

These packages are in `~/.config/.local/share/chezmoi/.chezmoiexternal.toml`


## Packages

Most packages are currently managed with brew. They are install in the `run_after_install.sh` or are managed by chezmoi, located in the `.chezmoiexternal.toml`

### Tmux

Managed using [TPM](https://github.com/tmux-plugins/tpm) you have to install the plugins with `prefix i.e. Ctrl+a` + `I` when you 1st use tmux. 

### Nvim
Inspired by a few different repositories [thePrimeagen](https://github.com/ThePrimeagen/init.lua) 
and [josean-dev](https://github.com/josean-dev/dev-environment-files).

Packages are managed by [packer](https://github.com/wbthomason/packer.nvim) and installed automatically by opening `.config/nvim/lua/eric/plugins-setup.lua` as saving it `:w`.


