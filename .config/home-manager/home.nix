{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "clement";
  home.homeDirectory = "/home/clement";

  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    direnv
    picom
    qtile
    firefox
    zsh

    # unfree
    discord
    jetbrains-toolbox

    # fonts
    jetbrains-mono
    nerdfonts
  ];
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Symlink the dotfiles
  home.file = {
    ".zshrc".source = ../../.zshrc;
    ".gitconfig".source = ../../.gitconfig;
    "assets".source = ../../assets;

    # dont work. don't know why
    # ".ohmyzsh".source = ../../.ohmyzsh;
    # ".config".source = ../../.config;
  };
}
