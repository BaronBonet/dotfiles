# Dotfiles

## Starting a new machine

- [Create and add an sshkey](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [Add this sshkey to github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Now run this one liner, as show on [chezmoi.io](https://www.chezmoi.io/)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply BaronBonet
```

This should copy all my dotfiles to their respective locations, and run install scripts.

### Install scripts?

<https://www.chezmoi.io/user-guide/machines/macos/#use-brew-bundle-to-manage-your-brews-and-casks>

## Working with chezmoi

For any file managed by chezmoi you can use the following commands to interact with them:

- `ch diff <file>` to see the changes between the current file and the chezmoi managed file
- `ch add <file>` to add the file to chezmoi

To apply the changes from the managed files from chezmoi to your local files use:

- `ch diff` to see the changes that will be applied
- `ch apply` to apply the changes

## Getting started

Dotfiles are managed using [chezmoi](https://www.chezmoi.io/).

To initialize the dotfiles repo:

``
chezmoi init --apply <git@github.com>:BaronBonet/dotfiles.git

````

This should create a `~/.config` folder with all of my dotfiles, along with a few other files in the home directory e.g. `~/.zshenv`

You'll have to manually source the `.zshrc` the first time.

```bash
source ~/.config/zsh/.zshrc
````

## Hints

Keep in mind external packages are being managed by chezmoi so they may need to be refreshed.

- `chezmoi --refresh-externals apply`

These packages are in `~/.config/.local/share/chezmoi/.chezmoiexternal.toml`

## Packages

Most packages are currently managed with brew. They are install in the `run_after_install.sh` or are managed by chezmoi, located in the `.chezmoiexternal.toml`

### Tmux

Managed using [TPM](https://github.com/tmux-plugins/tpm) you have to install the plugins with `prefix i.e. Ctrl+a` + `I` when you 1st use tmux.

### Nvim

Using [lazvim](https://www.lazyvim.org/)
