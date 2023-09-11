ZSH_THEME="drawbu"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

# powerline10k
source $HOME/assets/.p10k.zsh

# Load oh my zsh if not loaded
if [[ -z "$ZSH" ]]; then
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
  ZSH_CUSTOM=$HOME/.config/omz
  source $ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme

  source $ZSH/oh-my-zsh.sh
  export ZSH="$HOME/.oh-my-zsh"
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load custom shell config for any shell
source $HOME/assets/.profile
