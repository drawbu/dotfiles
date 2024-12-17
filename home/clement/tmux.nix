{pkgs, ...}: let
  vimTmuxNavigator = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pluginName = src.repo;
    version = "unstable-2024-02-05";

    src = pkgs.fetchFromGitHub {
      owner = "alexghergh";
      repo = "nvim-tmux-navigation";
      rev = "4898c98702954439233fdaf764c39636681e2861";
      hash = "sha256-CxAgQSbOrg/SsQXupwCv8cyZXIB7tkWO+Y6FDtoR8xk=";
    };
  };
in {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    secureSocket = true;

    plugins = with pkgs.tmuxPlugins; [
      {plugin = sensible;}
      {
        plugin = vimTmuxNavigator;
        extraConfig /*bash*/ = ''
          bind-key -T copy-mode-vi 'C-h' select-pane -L
          bind-key -T copy-mode-vi 'C-j' select-pane -D
          bind-key -T copy-mode-vi 'C-k' select-pane -U
          bind-key -T copy-mode-vi 'C-l' select-pane -R
          bind-key -T copy-mode-vi 'C-\' select-pane -l
          bind-key -T copy-mode-vi 'C-Space' select-pane -t:.+
        '';
      }
      {
        plugin = catppuccin;
        extraConfig = /*bash*/ ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_date_time ""
          set -g @catppuccin_user "off"
          set -g @catppuccin_host "on"
        '';
      }
    ];
    extraConfig = /*bash*/ ''
      # Fix terminal features
      if-shell -b '[ "$(echo "$CURRENT_TERMINAL")" = kitty ]' \
          "set -g default-terminal 'xterm-kitty'"

      # Open panes & windows in $PWD
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Disable status bar when there's only one window.
      set -g status off
      set-hook -g after-new-window      'if "[ #{session_windows} -gt 1 ]" "set status on"'
      set-hook -g after-kill-pane       'if "[ #{session_windows} -lt 2 ]" "set status off"'
      set-hook -g pane-exited           'if "[ #{session_windows} -lt 2 ]" "set status off"'
      set-hook -g window-layout-changed 'if "[ #{session_windows} -lt 2 ]" "set status off"'
    '';
  };
}
