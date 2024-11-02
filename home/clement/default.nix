# 'clement' user home-manager config for NixOS & generic linux
{ pkgs, graphical, ... }:
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
      ./gitlab.nix
      ./gh.nix
      ./distrobox.nix
    ]
    ++ pkgs.lib.optionals graphical [
      ./qtile
      ./rofi
      ./hypr
      ./eww
      ./kanata
      ./fonts.nix
      ./gtk.nix
      ./firefox.nix
      ./cursor.nix
      ./kitty.nix
      ./lockscreen.nix
      ./flatpak.nix
      ./picom.nix
      ./mimeapps.nix
      ./login.nix
      ./gaming.nix
    ];

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "23.05";

    packages =
      (with pkgs; [
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
        unstable_small.spotify-player
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
          gnome.gnome-font-viewer
          gnome.file-roller
          gnome.nautilus
          gnome.eog
          slack
          tic-80
          orca-slicer
          bambu-studio
        ]
      );

    file = {
      "assets".source = ../../assets;
      ".config/nix/nix.conf".text = "experimental-features = nix-command flakes";
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
      icons = true;
      extraOptions = [ "--group-directories-first" ];
    };

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };
  };
}
