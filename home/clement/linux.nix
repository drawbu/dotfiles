{
  config,
  pkgs,
  lib,
  graphical,
  ...
}:
{
  imports =
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
    ];

  home = {
    sessionVariables = {
      XCURSOR_SIZE = 16;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };
    packages =
      with pkgs;
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
      ];
  };

  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    "/var/lib/flatpak/exports/share"
  ];

  services = {
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
