# 'clement' user home-manager config for NixOS & generic linux
{ pkgs, graphical, config, ... }:
let
  username = "clement";
in
{
  imports =
    [
      ./vim
      ./shell
      ./dev
      ./git.nix
      ./tmux.nix
      ./btop.nix
      ./gh.nix
      ./distrobox.nix
    ]
    ++ pkgs.lib.optionals graphical [
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

  programs.home-manager.enable = true;

  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    "/var/lib/flatpak/exports/share"
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "23.05";

    packages =
      (with pkgs; [
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
        spotify-player
        nurl
        unzip
        unar
        nmap
      ])
      ++ pkgs.lib.optionals graphical (
        with pkgs;
        [
          feh
          thunderbird-bin
          aseprite
          zathura
          croc
          wireguard-tools
          beeper
          unstable.vesktop
          discord
          ungoogled-chromium
          libreoffice-qt6-fresh
          teams-for-linux
          spotify
          obsidian
          vlc
          obs-studio
          filelight
          gnome-font-viewer
          file-roller
          nautilus
          eog
          slack
          tic-80
          orca-slicer
          bambu-studio
          tor-browser
          appimage-run
          arduino-ide
          pavucontrol
          warp
          resources
        ]
      );

    file = {
      "assets".source = ../../assets;
      ".config/nixpkgs/config.nix".text = "{ allowUnfree = true; allowUnsupportedSystem = true; }";
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

    swaync.enable = true;
  };

  programs = {
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [ "--group-directories-first" ];
    };

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };
  };
}
