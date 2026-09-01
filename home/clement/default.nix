{ config, pkgs, ... }:
{
  imports = [
    ../../nixos/nixpkgs.nix
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
      todo
      comma
      nix-index
      spotify-player
      nurl
      unzip
      unar
      nmap
      croc
      wireguard-tools
      unstable.ollama-rocm
      ncdu
      zip
      genact
      dust
      dig
      sox
      unstable.zmx
    ];
  };

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; allowUnsupportedSystem = true; }";
}
