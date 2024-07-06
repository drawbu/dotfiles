{
  pkgs,
  config,
  ...
}: {
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

    zsh = {
      enable = true;
      initExtra = ''
        source ${config.home.homeDirectory}/.shell-extra
        source <(nh completions --shell zsh)

        code() {
          if [ "$#" -eq 0 ]; then
            /usr/bin/env code .
          else
            /usr/bin/env code "$@"
          fi
        }

        v() {
          if [ "$#" -eq 0 ]; then
            /usr/bin/env nvim .
          else
            /usr/bin/env nvim "$@"
          fi
        }
      '';
      enableCompletion = false;

      sessionVariables = {
        ZSH_DISABLE_COMPFIX = true;
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

      loginExtra = ''
        systemctl --user import-environment PATH
      '';

      oh-my-zsh = {
        enable = true;
        package = pkgs.oh-my-zsh;
        plugins = [
          "copyfile"
          "direnv"
          "history"
          "sudo"
          "zoxide"
          "podman"
          "rust"
        ];
      };
    };
  };
}
