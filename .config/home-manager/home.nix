{ config, pkgs, ... }:

{

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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
