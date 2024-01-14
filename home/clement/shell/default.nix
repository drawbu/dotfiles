{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./zsh.nix
  ];

  home.file = {
    ".local/bin/fixwifi" =
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
    ".config/starship.toml".source = ./starship.toml;
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
    };
  };

}
