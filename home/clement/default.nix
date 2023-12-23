# 'clement' user home-manager config for NixOS & generic linux
{ pkgs, unstable, pkgs_legacy, ... }:
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
    ./vim
    ./shell/zsh
    ./gtk.nix
    ./firefox.nix
    ./cursor.nix
    ./discord.nix
    ./tmux.nix
    ./dunst.nix
    ./kitty.nix
    ./btop.nix
    ./gh.nix
    ./shell/bash.nix
    ./lockscreen.nix
    ./picom.nix
    ./mimeapps.nix
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
      wakatime
      btop
      neofetch
      ookla-speedtest
      wget
      banana-vera
      lazygit

      # ↓ softwares
      pkgs_legacy.obsidian
      spotify
      unstable.vscode
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm
      feh
      thunderbird-bin
      vlc
      aseprite
      teams-for-linux
      zathura
      godot_4
      croc
      wireguard-tools

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

  services.flameshot = {
    enable = true;
    settings.General = {
      savePath = "/home/${username}/Downloads";
      showStartupLaunchMessage = false;
    };
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    git = true;
    icons = true;
    extraOptions = [
      "--group-directories-first"
    ];
  };
}
