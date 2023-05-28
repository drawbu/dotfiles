# Homebrew stuff
if [[ "$OSTYPE" == "darwin"* ]]; then
    export LC_ALL=en_US.UTF-8

    # brew command-not-found
    HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
    if [ -f "$HB_CNF_HANDLER" ]; then
        source "$HB_CNF_HANDLER";
    fi

    # Set gcc to gcc-13, instead of the default clang
    if [ -x "$(command -v gcc-13)" ]; then
        alias gcc="gcc-13"
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
export PATH="$HOME/assets/scripts:$PATH"

# Fix PATH
export PATH="$HOME/.local/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# if os is arch linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
fi

# Replace ls with exa or colorls
if [ -x "$(command -v exa)" ]; then
    alias ls="exa --icons --group-directories-first --git --color=always"
    alias tree="exa --icons --group-directories-first --git --color=always --tree"
elif [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
    alias tree="exa --icons --group-directories-first --git --color=always --tree"
fi

# bat
if [ -x "$(command -v bat)" ]; then
    alias cat="bat"
    alias old-cat="/bin/cat"
fi

# NeoVim
if [ -x "$(command -v nvim)" ]; then
    alias vim="nvim"
    alias vi="nvim"
    export EDITOR="nvim"
    export VISUAL="nvim"
fi

# GitHub GPG Key
export GPG_TTY=$(tty)
