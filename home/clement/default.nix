{
  config,
  finputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    finputs.opnix.homeManagerModules.default
    ./btop.nix
    ./dev
    ./fonts.nix
    ./gh.nix
    ./git.nix
    ./helix.nix
    ./jujutsu.nix
    ./profiles.nix
    ./shell
    ./vim
    ./wallpapers
    ./yank.nix
  ];

  programs.home-manager.enable = true;

  programs.onepassword-secrets = {
    enable = true;
    tokenFile = "${config.xdg.configHome}/opnix/token";
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d";
    };
    flake = lib.mkDefault "${config.home.homeDirectory}/Developer/dotfiles";
  };

  home = {
    username = "clement";
    homeDirectory =
      if pkgs.stdenv.isLinux then
        "/home/${config.home.username}"
      else if pkgs.stdenv.isDarwin then
        "/Users/${config.home.username}"
      else
        throw "mmmh no home directory";

    packages = with pkgs; [
      cowsay
      fastfetch
      ookla-speedtest
      wget
      #wl-clipboard-x11
      nurl
      unzip
      unar
      nmap
      croc
      wireguard-tools
      ncdu
      zip
      genact
      dust
      dig
      unstable.zmx
    ];
  };

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; allowUnsupportedSystem = true; }";
}
