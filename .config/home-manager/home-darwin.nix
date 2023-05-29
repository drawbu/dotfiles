{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "clement";
    homeDirectory = "/Users/clement";

    stateVersion = "22.11";

    packages = with pkgs; [
      direnv
      zsh

      # unfree
      discord

      # fonts
      jetbrains-mono
      nerdfonts

      # local packages
      (pkgs.callPackage packages/vera.nix { })
    ];

    # Symlink the dotfiles
    file = {
      ".zshrc".source = ../../.zshrc;
      ".gitconfig".source = ../../.gitconfig;
      "assets".source = ../../assets;

      # dont work. don't know why
      # ".ohmyzsh".source = ../../.ohmyzsh;
      # ".config".source = ../../.config;
    };
  };
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
