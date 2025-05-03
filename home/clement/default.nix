{
  pkgs,
  lib,
  graphical,
  config,
  ...
}:
{
  imports =
    [
      ./vim
      ./shell
      ./git.nix
      ./dev
      ./tmux.nix
      ./btop.nix
      ./gh.nix
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      [
        ./distrobox.nix
      ]
      ++ lib.optionals graphical [
        ./rofi
        ./hypr
        ./kanata
        ./fonts.nix
        ./gtk.nix
        ./firefox.nix
        ./cursor.nix
        ./kitty.nix
        ./mimeapps.nix
        ./login.nix
        ./gaming.nix
        ./ghostty.nix
      ]
    );

  programs.home-manager.enable = true;

  home = {
    stateVersion = "23.05";

    packages =
      with pkgs;
      [
        # ↓ cli & tui
        neofetch
        ookla-speedtest
        wget
        #wl-clipboard-x11
        todo
        comma
        nix-index
        spotify-player
        nurl
        unzip
        unar
        nmap
        temurin-bin
        croc
        wireguard-tools
        ollama
        ncdu
        zip
        unstable.gitoxide
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
        [ ]
        ++ lib.optionals graphical [
          ventoy-full
          xsel
          xclip
          libnotify
          wl-clipboard
          # yubikey-manager-qt
          pods
          feh
          thunderbird-bin
          libresprite
          zathura
          beeper
          unstable.vesktop
          discord
          ungoogled-chromium
          brave
          libreoffice-qt6-fresh
          teams-for-linux
          spotify
          obsidian
          vlc
          obs-studio
          gnome-font-viewer
          file-roller
          nautilus
          eog
          slack
          # tic-80
          orca-slicer
          bambu-studio
          tor-browser
          appimage-run
          arduino-ide
          pavucontrol
          pwvucontrol
          warp
          resources
          filezilla
          figma-linux
          legacy'.figma-agent
          hexchat
          polychromatic
          superTuxKart
        ]
      );

    file = {
      "assets".source = ../../assets;
      ".config/nixpkgs/config.nix".text = "{ allowUnfree = true; allowUnsupportedSystem = true; }";
    };
  };
}
// lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
  home.sessionVariables = {
    XCURSOR_SIZE = 16;
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    "/var/lib/flatpak/exports/share"
  ];

  services = {
    flameshot = {
      enable = true;
      settings.General = {
        savePath = "/home/clement/Downloads";
        showStartupLaunchMessage = false;
      };
    };

    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableSshSupport = true;
    };

    blueman-applet.enable = true;

    swaync.enable = true;
  };
}
