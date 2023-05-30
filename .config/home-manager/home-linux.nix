{ config, pkgs, ... }: {

  imports = [
    ./packages
    ./dotfiles.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "clement";
    homeDirectory = "/home/clement";

    stateVersion = "22.11";

    packages = with pkgs; [
      picom
      qtile
      firefox
      kitty

      # unfree
      jetbrains-toolbox
    ];
  };
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
