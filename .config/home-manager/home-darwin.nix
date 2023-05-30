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

    packages = with pkgs; [
      libreoffice-bin
    ];
  };
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
