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
alias cours="cd \"/Users/clement/Library/Mobile Documents/com~apple~CloudDocs/Cours\""

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

# Termbin https://github.com/solusipse/fiche
alias tbc="nc termbin.com 9999 | pbcopy"

# Function to analyse all file with banana by Sigmanifient the GOAT
function cs() {
    start_time=$(date +%s%3N)
    norm_dir="$HOME/scripts/banana-coding-style-checker/vera"

    echo "Running norm in $(pwd)"
    files=$(find $(pwd)        \
        -type f                \
        -not -path "*/.git/*"  \
        -not -path "*/.idea/*" \
        -not -path "bonus/*"   \
        -not -path "tests/*"   \
        -not -path "/*build/*" \
    )

    echo "Checking $(echo $files | wc -w) files"
    output=$(vera++                           \
        --profile epitech                     \
        --root $norm_dir                      \
        -d $(echo $files | tr '\n' ' ')       \
    )

    if [ -z "$output" ]; then
        echo "No issue found :D"
    else
        escaped_path=$(echo $(pwd) | sed 's/\//\\\//g')
        echo "$output" | sed "s/$escaped_path\///g"
        echo "Found $(echo "$output" | grep -c "$") issues"
    fi
    end_time=$(date +%s%3N)
    echo "Ran in $(expr $end_time - $start_time)ms"
}
