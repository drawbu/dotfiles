export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

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

# My aliases
alias dev="cd ~/Developer"
alias cours="cd \"/Users/clement/Library/Mobile Documents/com~apple~CloudDocs/Cours/2022-2023 S1/Informatique\"; source ./venv/bin/activate"

# brew command-not-found
HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
if [ -f "$HB_CNF_HANDLER" ]; then
source "$HB_CNF_HANDLER";
fi

# pnpm
export PNPM_HOME="/Users/clement/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# bun completions
[ -s "/Users/clement/.bun/_bun" ] && source "/Users/clement/.bun/_bun"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Load Angular CLI autocompletion.
source <(ng completion script)

# Wakatime
export ZSH_WAKATIME_PROJECT_DETECTION=true
