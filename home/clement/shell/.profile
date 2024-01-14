# Wakatime
export ZSH_WAKATIME_PROJECT_DETECTION=true

# Load my scripts
export PATH="$HOME/scripts:$PATH"

# Change bat theme
if [ -x "$(command -v bat)" ]; then
    export BAT_THEME="TwoDark"
fi

# NeoVim
if [ -x "$(command -v nvim)" ]; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    alias vim="nvim"
fi

# GitHub GPG Key
export GPG_TTY=$(tty)

# Rust
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

alias lz="lazygit"
alias portainer="docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest"
alias v="nvim ."
alias t="tmux new-session \; split-window -h"
alias epidock="docker run -it --rm -v \$(pwd):/home/project -w /home/project epitechcontent/epitest-docker:latest /bin/bash"
