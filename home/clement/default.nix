# 'clement' user home-manager config for NixOS & generic linux
{pkgs, ...}: let
  username = "clement";
in {
  imports = [
    ./qtile
    ./rofi
    ./git
    ./eww
    ./vim
    ./shell
    ./hypr
    ./dev
    ./fonts.nix
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
    ./distrobox.nix
    ./login.nix
    ./gaming.nix
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
      xsel
      xclip

      wl-clipboard
      #wl-clipboard-x11
      todo
      comma
      nix-index
      legacy.spotify-tui
      nurl
      unzip
      unar

      # ↓ softwares
      feh
      thunderbird-bin
      aseprite
      zathura
      croc
      wireguard-tools
      beeper
      ida
      vesktop
      discord
      ungoogled-chromium
      libreoffice-qt6-fresh
      teams-for-linux
      spotify
      obsidian
      vlc
      obs-studio
      filelight

      prismlauncher
      heroic
    ];

    file = {
      "assets".source = ../../assets;
      ".config/nix/nix.conf".text = "experimental-features = nix-command flakes";
      ".config/nixpkgs/config.nix".text = /*nix*/ ''
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
      git = true;
      icons = true;
      extraOptions = ["--group-directories-first"];
    };

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };
  };
}
