{ config, pkgs, ... }: {

  imports = [
    ./packages.nix
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
