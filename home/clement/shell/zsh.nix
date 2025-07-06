{ pkgs, lib, ... }:
{
  xdg.configFile."starship.toml".source = ./starship.toml;

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;

      enableBashIntegration = false;
      enableFishIntegration = false;
      enableIonIntegration = false;
      enableNushellIntegration = false;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh =
      {
        enable = true;
        initContent = ''
          _run_here() {
            cmd="$1"
            shift

            if [ "$#" -eq 0 ]; then
              /usr/bin/env "$cmd" .
            else
              /usr/bin/env "$cmd" "$@"
            fi
          }

          code() { _run_here code "$@" }
          v()    { _run_here nvim "$@" }
          hx()   { _run_here hx "$@" }

          [ -f "$HOME/.config/op/plugins.sh" ] && . "$HOME/.config/op/plugins.sh"
        '';
        enableCompletion = false;

        sessionVariables = {
          ZSH_DISABLE_COMPFIX = true;
          ZSH_WAKATIME_PROJECT_DETECTION = true;
          GIT_AUTO_FETCH_INTERVAL = 300; # in seconds
        };

        history = {
          extended = true;
          share = true;
          append = true; # TODO: New in 24.11
          size = 100000; # Don't save too much in memory
          save = 100000000;
        };

        shellAliases = {
          "cd" = "z";
        };

        plugins = [
          {
            name = "wakatime";
            src = pkgs.fetchFromGitHub {
              owner = "sobolevn";
              repo = "wakatime-zsh-plugin";
              rev = "69c6028b0c8f72e2afcfa5135b1af29afb49764a";
              hash = "sha256-pA1VOkzbHQjmcI2skzB/OP5pXn8CFUz5Ok/GLC6KKXQ=";
            };
          }
          {
            name = "zsh-autosuggestions";
            src = pkgs.zsh-autosuggestions;
            file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
          }
          {
            name = "zsh-nix-shell";
            src = pkgs.zsh-nix-shell;
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
          }
          {
            name = "zsh-fzf-tab";
            src = pkgs.zsh-fzf-tab;
            file = "share/fzf-tab/fzf-tab.plugin.zsh";
          }
          {
            name = "F-Sy-H";
            src = pkgs.zsh-f-sy-h;
            file = "share/zsh/site-functions/F-Sy-H.plugin.zsh";
          }
        ];

        oh-my-zsh = {
          enable = true;
          plugins = [
            "copyfile"
            "direnv"
            "history"
            "sudo"
            "zoxide"
            "podman"
            "rust"
            "kubectl"
            "yarn"
            "1password"
          ];
        };
      }

      // (lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
        loginExtra = ''
          systemctl --user import-environment PATH
        '';
      });
  };
}
