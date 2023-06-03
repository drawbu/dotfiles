export ZSH="$HOME/.ohmyzsh"

ZSH_THEME="drawbu"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
ZSH_CUSTOM=$HOME/.config/omz

plugins=(
  git
  brew
  direnv
  wakatime
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-autocomplete
  nix-zsh-completions
)

# powerline10k
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
source $ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/assets/.p10k.zsh

source $ZSH/oh-my-zsh.sh
source $HOME/assets/.profile

if [ -x "$(command -v brew)" ]; then
  if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit
    compinit
  fi
fi
