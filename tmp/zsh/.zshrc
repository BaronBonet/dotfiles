# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

source "$XDG_CONFIG_HOME/.aliases"

export PATH=/opt/homebrew/bin:$PATH

# ZSH complete
autoload -U compinit; compinit
# https://github.com/zsh-users/zsh-completions
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)



# VIM mode
source "$ZDOTDIR/plugins/vim_mode"

# Change curser
source "$ZDOTDIR/plugins/curser_mode"

# Auto suggestions while typing
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highliting in the shell
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"



# Python
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PATH="$PATH:/Users/ericbonet/.local/bin"
export PATH="$HOME/.poetry/bin:$PATH"
# Allows pre commit to run using zsh
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# Searching up for word
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M vicmd "j" up-line-or-beginning-search
bindkey -M vicmd "k" down-line-or-beginning-search

# Using alias 'l' for ls -la with with Rust package lsd
# https://github.com/Peltoche/lsd

# ZSH Directory stack
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
# and the aliases to use the last 9 directories visited
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index


# Source Power Level 10k
[[ ! -f ~/zsh/.p10k.zsh ]] || source ~/zsh/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
