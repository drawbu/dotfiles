# My aliases
alias dev="cd $HOME/Developer"
alias cours="cd \"$HOME/Library/Mobile Documents/com~apple~CloudDocs/Cours\""

# Homebrew stuff
if [[ "$OSTYPE" == "darwin"* ]]; then
    # brew command-not-found
    HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
    if [ -f "$HB_CNF_HANDLER" ]; then
        source "$HB_CNF_HANDLER";
    fi

    # brew icon sketchybar
    function brew() {
        command brew "$@" 

        if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
            sketchybar --trigger brew_update
        fi
    }
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Wakatime
export ZSH_WAKATIME_PROJECT_DETECTION=true

# Load my scripts
export PATH="$PATH:$HOME/scripts"

# Minecraft fix on arch
export LC_ALL=C; unset LANGUAGE

# colorls
if command -v colorls &> /dev/null
then
    alias ls="colorls"
fi
