# 'clement' user home-manager config for NixOS & generic linux
{ pkgs, unstable, ... }:
let
  username = "clement";
in
{
  imports = [
    ./nvim
    ./qtile
    ./rofi
    ./git
    ./eww
    ./gtk.nix
    ./firefox.nix
    ./cursor.nix
    ./zsh.nix
    ./discord.nix
    ./tmux.nix
    ./dunst.nix
    ./kitty.nix
    ./btop.nix
    ./gh.nix
    ./vim.nix
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
      i3lock

      # ↓ cli & tui
      direnv
      bat
      exa
      wakatime
      btop
      neofetch
      speedtest-cli
      wget
      unstable.banana-vera
      lazygit

      # ↓ softwares
      obsidian
      spotify
      unstable.vscode
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm
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

    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -c 000000 -fe";
      inactiveInterval = 5;
    };
  };
}
