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

alias lz="lazygit"
alias portainer="docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest"
alias v="nvim ."

export TERM=xterm-256color
