export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="drawbu"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

plugins=(
  git
  brew
  wakatime
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-autocomplete
)

# powerline10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
