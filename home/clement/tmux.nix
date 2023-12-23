{ pkgs, ... }:
let
  tmuxNvim = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux.nvim";
    version = "unstable-2023-10-28";
    src = pkgs.fetchFromGitHub {
      owner = "aserowy";
      repo = "tmux.nvim";
      rev = "ea67d59721eb7e12144ce2963452e869bfd60526";
      hash = "sha256-/2flPlSrXDcNYS5HJjf8RbrgmysHmNVYYVv8z3TLFwg=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    secureSocket = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      tmuxNvim
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_date_time ""
          set -g @catppuccin_user "off"
          set -g @catppuccin_host "on"
        '';
      }
    ];
    extraConfig = ''
      # Open panes in current directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
