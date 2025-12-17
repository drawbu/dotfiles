{
  config,
  pkgs,
  lib,
  graphical,
  ...
}:
{
  imports = [
    ./distrobox.nix
  ]
  ++ lib.optionals graphical [
    ./rofi
    ./hypr
    ./kanata
    ./gtk.nix
    ./firefox.nix
    ./cursor.nix
    ./kitty.nix
    ./mimeapps.nix
    ./login.nix
    ./gaming.nix
    ./ghostty.nix
    ./fuzzel.nix
    ./xdg.nix
  ];

  home = {
    sessionVariables = {
      XCURSOR_SIZE = 16;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      NIXOS_OZONE_WL = "1";
      DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
    };
    packages =
      with pkgs;
      [ ]
      ++ lib.optionals graphical [
        door-knocker
        ventoy-full
        xsel
        xclip
        libnotify
        wl-clipboard
        yubioath-flutter
        pods
        feh
        thunderbird-bin
        libresprite
        zathura
        beeper
        unstable.vesktop
        discord
        google-chrome
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
        figma-agent
        hexchat
        superTuxKart
        calibre
        foot
        gitbutler
        gnome-disk-utility
        kdePackages.filelight
        rpi-imager
        gcr
        legacy.stremio
        loupe
      ];
  };

  xdg = {
    systemDirs.data = [
      "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
      "/var/lib/flatpak/exports/share"
    ];
    autostart = {
      enable = true;
      readOnly = true;
      entries = [
        "${pkgs._1password-gui}/share/applications/1password.desktop" # add flag silent
      ];
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableSshSupport = true;
    };

    blueman-applet.enable = true;

    swaync.enable = true;

    gnome-keyring.enable = true;
  };
}
