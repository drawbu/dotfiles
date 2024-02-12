{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./zsh.nix
  ];

  home = {
    file = {
      ".local/bin/fixwifi" =
        let
          nmcli = "${pkgs.networkmanager}/bin/nmcli";
        in {
          executable = true;
          text = ''
            #!${pkgs.runtimeShell}

            ssid="$1"
            if [ -z "$ssid" ]; then
              echo "Usage: fixwifi <ssid>"
              exit 1
            fi
            while [ -z "$((${nmcli} dev wifi rescan && ${nmcli} dev wifi list) | grep "$ssid")" ]; do
              echo "Waiting for $ssid to be available..."
              sleep 1
            done
            echo "Connecting to $ssid..."
            ${nmcli} dev wifi connect "$ssid"
          '';
        };

      ".local/bin/run_gnome" = {
        executable = true;
        text = ''
          #!${pkgs.runtimeShell}

          export DISPLAY=:0
          export XDG_SESSION_TYPE=wayland
          ${pkgs.dbus}/bin/dbus-run-session ${pkgs.gnome.gnome-session}/bin/gnome-session
        '';
      };

      ".config/starship.toml".source = ./starship.toml;

      ".shell-extra".text = ''
        export PATH="$HOME/.local/bin:$PATH"

        # WakaTime
        export ZSH_WAKATIME_PROJECT_DETECTION=true

        # Rust
        export CARGO_NET_GIT_FETCH_WITH_CLI=true
        export PATH="$HOME/.cargo/bin:$PATH"
      '';
    };

    shellAliases = {
      lz="lazygit";
      portainer="docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest";
      v="nvim .";
      t="tmux new-session \; split-window -h";
      epidock="docker run -it --rm -v \$(pwd):/home/project -w /home/project epitechcontent/epitest-docker:latest /bin/bash";
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
    };
  };

}
