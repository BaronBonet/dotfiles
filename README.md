# Eric's dotfiles

Managed using [chezmoi](https://www.chezmoi.io/). Attempting to keep my dotfiles synced across my personal and work machines.

I wouldn't suggest anyone other than myself use these dot files as is, I've littered my configs (e.g. `.gitconfig`) with personal information. Feel free to browse these files and copy what you like.

## Getting started

Open a terminal and run the modified one liner (taken from [chezmoi.io](https://www.chezmoi.io/)), to clone and apply my dotfiles. Xcode may need to be installed for this to work, it will prompt you to install it if required. If brew in not installed it will also be installed as well, if you're prompted to add anything to your .bashrc file after installing brew be sure to do so.

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/BaronBonet/dotfiles.git
```

This should copy all my dotfiles to their respective locations, and run the [install script](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/) found [here](run_after-install-packages.sh). This script installs brew, all of my brew packages as well as the interpreted languages I'm currently using (Python and Ruby) managed by [asdf](https://asdf-vm.com/).

<!--- [Create and add an sshkey](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)-->
<!--- [Add this sshkey to github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)-->

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

#### 1Password

Open the 1Password desktop app, and login. This is required to use the 1Password cli. Follow the [instruction](https://developer.1password.com/docs/cli/get-started/#step-2-turn-on-the-1password-desktop-app-integration) for integrating with the 1Password desktop app.

Turn on the [1Password SSH agent](https://developer.1password.com/docs/ssh/get-started/#step-3-turn-on-the-1password-ssh-agent), to use 1Password for managing ssh keys.

### Final steps

Because the dotfiles were cloned using `https` instead of `ssh`, you'll need to update git to use ssh. You can do this by running the following command:

```bash
git remote set-url origin git@github.com:BaronBonet/dotfiles.git
```

## Working with chezmoi

For any file managed by chezmoi you can use the following commands to interact with them:

- `ch diff <file>` to see the changes between the current file and the chezmoi managed file
- `ch add <file>` to add the file to chezmoi

To apply the changes from the managed files from chezmoi to your local files use:

- `ch diff` to see the changes that will be applied
- `ch apply` to apply the changes

Regularly run `ch apply` to ensure your managed dot files are not too far behind. It will notify you what it will modify (so what you haven't updated in chemozi). If that's the case then add the file/folder with `ch add`
