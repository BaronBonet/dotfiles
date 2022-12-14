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
