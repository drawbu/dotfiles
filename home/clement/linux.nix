{
  config,
  finputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [
    ./cursor.nix
    ./distrobox.nix
    ./firefox.nix
    ./gaming.nix
    ./ghostty.nix
    ./gtk.nix
    ./kanata
    ./kitty.nix
    ./mimeapps.nix
    ./niri
    ./soloist
    ./swayidle.nix
    ./waybar.nix
    ./zathura.nix
  ];

  home = {
    sessionVariables.DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
    packages = with pkgs; [
      door-knocker
      ventoy-full
      xsel
      xclip
      libnotify
      wl-clipboard
      yubioath-flutter
      pods
      feh
      thunderbird
      libresprite
      beeper
      discord
      libreoffice-qt6-fresh
      teams-for-linux
      spotify
      obsidian
      vlc
      obs-studio
      gnome-font-viewer
      file-roller
      nautilus
      # segfaults otherwise https://github.com/NixOS/nixpkgs/pull/557126
      # (unstable.orca-slicer.overrideAttrs (old: {
      #   buildInputs = lib.remove pkgs.unstable.gcc-unwrapped old.buildInputs;
      # }))
      (unstable.bambu-studio.override {
        withNvidiaGLWorkaround = lib.elem "nvidia" osConfig.services.xserver.videoDrivers;
      })
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
      supertuxkart
      calibre
      gitbutler
      gnome-disk-utility
      kdePackages.filelight
      rpi-imager
      gcr
      stremio-linux-shell
      loupe
      mullvad-browser
      chiri
      freecad
      inkscape
      cine

      wl-clipboard
      kooha
      librepods
      awww
      playerctl

      (callPackage ./helium.nix { })
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
      entries =
        let
          onepassword-silent = pkgs.runCommand "1password-silent-autostart" { } ''
            mkdir -p $out/share/applications
            sed 's|^Exec=1password |Exec=1password --silent |' \
              ${pkgs._1password-gui}/share/applications/1password.desktop \
              > $out/share/applications/1password.desktop
          '';
        in
        [ "${onepassword-silent}/share/applications/1password.desktop" ];
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
    swayosd.enable = true;
  };

  programs = {
    vicinae = {
      enable = true;
      systemd.enable = true;
    };
    swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
    };
  };
}
