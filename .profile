# Homebrew stuff
if [[ "$OSTYPE" == "darwin"* ]]; then
    # brew command-not-found
    HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
    if [ -f "$HB_CNF_HANDLER" ]; then
        source "$HB_CNF_HANDLER";
    fi

    # Set gcc to gcc-12, instead of the default clang
    if [ -x "$(command -v gcc-12)" ]; then
        alias gcc="gcc-12"
    fi
fi

# Wakatime
export ZSH_WAKATIME_PROJECT_DETECTION=true

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Load my scripts
export PATH="$HOME/scripts:$PATH"

# Fix PATH
export PATH="$HOME/.local/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# colorls
if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
fi

# bat
if [ -x "$(command -v bat)" ]; then
    alias cat="bat"
    alias old-cat="/bin/cat"
fi

# GitHub GPG Key
export GPG_TTY=$(tty)
