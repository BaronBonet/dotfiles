# Dotfiles


## Getting started

Dotfiles are managed using [chezmoi](https://www.chezmoi.io/).

To initialize the dotfiles repo:

```bash
chezmoi init --apply https://github.com/baronbonet/dotfiles.git
```

This should create a `~/.config` folder with all of my dotfiles (along with a `~/.zshenv` file).

You'll have to manually source the `.zshrc` the first time.

```bash
source ~/.config/zsh/.zshrc
```

## Hints

Keep in mind external packages are being managed by chezmoi so they may need to be refreshed.

- `chezmoi --refresh-externals apply`

These packages are in `~/.config/.local/share/chezmoi/.chezmoiexternal.toml`


## Tmux

Using [TPM](https://github.com/tmux-plugins/tpm) you have to install the plugins with `prefix i.e. Ctrl+a` + `I`

## Nvim

Using Packer, remember to use :PackerSync to install new packages
