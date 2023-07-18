{ config, pkgs, ... }: {

  imports = [
    ./packages
  ];

  programs.home-manager.enable = true;

  home = {
    username = "clement";
    homeDirectory = "/Users/clement";

    stateVersion = "23.05";

    packages = with pkgs; [
      libreoffice-bin
    ];
  };
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
