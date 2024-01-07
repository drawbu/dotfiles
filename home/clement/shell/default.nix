{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./zsh.nix
  ];

  home.file = {
    "scripts/fixwifi" =
      let
        nmcli = "${pkgs.networkmanager}/bin/nmcli";
      in {
        text = ''
          #!${pkgs.runtimeShell}

          ssid="$1"
          if [ -z "$ssid" ]; then
            echo "Usage: fixwifi <ssid>"
            exit 1
          fi
          ${nmcli} dev wifi rescan
          ${nmcli} dev wifi list
          ${nmcli} dev wifi connect "$ssid"
        '';
        executable = true;
      };
  };

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        add_newline = false;
        format = ''
          $username @ $directory$git_branch$git_metrics(- ($cmd_duration )($status))
          $os$character
        '';
        right_format = ''
          $c$cmake$go$haskell$java$lua$nodejs$python$rust$package
        '';
        os.disabled = false;
        username = {
          show_always = true;
          format = "[$user]($style)";
        };
        status = {
          disabled = false;
          symbol = "[x](bold red)";
        };
        directory.style = "blue";
        character = {
          success_symbol = "[>](purple)";
          error_symbol = "[X](red)";
          vimcmd_symbol = "[<](green)";
        };
        cmd_duration.format = "[$duration]($style)";
        git_metrics = {
          disabled = false;
          format = "(\\[([+$added]($added_style) )([-$deleted]($deleted_style))\\] )";
        };
      };
    };
  };

}
