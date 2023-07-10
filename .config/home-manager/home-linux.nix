{ config, pkgs, ... }: {

  imports = [
    ./packages
    ./packages/games.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "clement";
    homeDirectory = "/home/clement";

    stateVersion = "23.05";

    packages = with pkgs; [
      picom
      qtile
      firefox
      kitty
      flameshot
      xfce.thunar

      # unfree
      jetbrains-toolbox
    ];
  };
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
