{ lib, ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;

    flags = [
      "--disable-ctrl-r"
      "--disable-up-arrow"
      "--disable-ai"
    ];

    # atuin rewrites config.toml after every command unless the file is ours.
    forceOverwriteSettings = true;
    settings = {
      sync_address = "https://atuin.drawbu.dev";
      sync_frequency = "5m";
      update_check = false;
    };
  };

  # Must land after fzf's own integration, which binds ^R to its widget.
  programs.zsh.initContent = lib.mkAfter ''
    atuin-history-widget() {
      setopt localoptions pipefail
      local selected
      selected=$(
        atuin search --cmd-only --print0 \
          | fzf --read0 --scheme=history --height="''${FZF_TMUX_HEIGHT:-40%}" --query="$LBUFFER"
      ) || { zle reset-prompt; return }
      BUFFER=$selected
      CURSOR=''${#BUFFER}
      zle reset-prompt
    }
    zle -N atuin-history-widget
    bindkey -M emacs '^R' atuin-history-widget
    bindkey -M vicmd '^R' atuin-history-widget
    bindkey -M viins '^R' atuin-history-widget
  '';
}
