{ config, pkgs, ... }: {

  imports = [
    ./packages
    ./dotfiles.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "clement";
    homeDirectory = "/Users/clement";

    stateVersion = "22.11";
  };
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
