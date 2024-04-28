# 'clement' user home-manager config for NixOS & generic linux
{pkgs, ...}: let
  username = "clement";
  code = pkgs.writeShellScriptBin "code" ''
    code="${pkgs.unstable.vscode}/bin/code"
    if [ "$#" -eq 0 ]; then
      exec $code .
    else
      exec $code "$@"
    fi
  '';
in {
  imports = [
    ./qtile
    ./rofi
    ./git
    ./eww
    ./vim
    ./shell
    ./hypr
    ./gtk.nix
    ./firefox.nix
    ./cursor.nix
    ./tmux.nix
    ./dunst.nix
    ./kitty.nix
    ./btop.nix
    ./gitlab.nix
    ./gh.nix
    ./lockscreen.nix
    ./flatpak.nix
    ./picom.nix
    ./mimeapps.nix
    ./editorconfig.nix
    ./distrobox.nix
    ./login.nix
  ];

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "23.05";

    packages = with pkgs; [
      # ↓ ricing
      eww

      # ↓ cli & tui
      direnv
      wakatime
      btop
      neofetch
      ookla-speedtest
      wget
      banana-vera
      lazygit
      entr
      xsel
      xclip
      wl-clipboard
      #wl-clipboard-x11
      todo
      man-pages
      man-pages-posix
      stdman
      tldr
      linux-manual
      comma
      jq
      nix-index
      spotify-tui
      nurl
      unzip
      unar
      unstable.nh # TODO: use program.nh on 24.05

      # ↓ softwares
      unstable.obsidian
      spotify
      code
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm
      jetbrains.datagrip
      feh
      thunderbird-bin
      vlc
      chromium
      aseprite
      teams-for-linux
      zathura
      godot_4
      croc
      wireguard-tools
      unstable.beeper
      libreoffice
      (pkgs.callPackage ./notflix.nix {})
      unstable.vesktop

      # ↓ games
      prismlauncher
      heroic

      # ↓ fonts
      jetbrains-mono
      nerdfonts
    ];

    file = {
      "assets".source = ../../assets;
      ".config/nix/nix.conf".text = "experimental-features = nix-command flakes";
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; allowUnsupportedSystem = true; }
      '';
    };
  };

  services = {
    flameshot = {
      enable = true;
      settings.General = {
        savePath = "/home/${username}/Downloads";
        showStartupLaunchMessage = false;
      };
    };

    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableSshSupport = true;
    };

    spotifyd = {
      enable = true;
      settings.global = {
        username = "clement2104.boillot@gmail.com";
        password_cmd = "gpg -r clement2104.boillot@gmail.com -q --decrypt .spotify.txt.gpg 2>/dev/null";
        use_mpris = true;
      };
    };

    blueman-applet.enable = true;
  };

  programs = {
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
      extraOptions = [
        "--group-directories-first"
      ];
    };

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };
  };
}
