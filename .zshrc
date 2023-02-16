export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="duellj"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

plugins=(
  git
  brew
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-wakatime
)

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
