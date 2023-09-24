# 'clement' user home-manager config for NixOS & generic linux
{ pkgs, unstable, ... }:
let
  username = "clement";
in
{
  imports = [
    ./nvim
    ./gtk.nix
    ./firefox.nix
    ./cursor.nix
    ./qtile.nix
    ./zsh.nix
    ./discord.nix
    ./rofi
    ../../.config
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
      bat
      exa
      wakatime
      btop
      neofetch
      tmux
      speedtest-cli
      wget
      git
      unstable.banana-vera
      lazygit

      # ↓ softwares
      obsidian
      spotify
      vscode
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm
      kitty
      feh
      thunderbird-bin
      vlc
      aseprite

      # ↓ games
      prismlauncher
      heroic

      # ↓ fonts
      jetbrains-mono
      nerdfonts
    ];

    file = {
      "assets".source = ../../assets;
      ".gitconfig".source = ../../.gitconfig;
      ".xinitrc".source = ../../.xinitrc;
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

    picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      opacityRules = [
        "95:class_g = 'kitty'"
        "95:class_g = 'thunderbird'"
        "95:class_g = 'Thunar'"
        "95:class_g = 'Spotify'"
        "95:class_g = 'obsidian'"
      ];
    };
  };
}
