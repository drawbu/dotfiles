{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports =
    [
      ./vim
      ./shell
      ./git.nix
      ./dev
      ./tmux.nix
      ./btop.nix
      ./gh.nix
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ ./linux.nix ];

  programs.home-manager.enable = true;

  home = {
    username = "clement";
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isLinux then
        "/home/${config.home.username}"
      else if pkgs.stdenv.hostPlatform.isDarwin then
        "/Users/${config.home.username}"
      else
        "";

    packages = with pkgs; [
      # ↓ cli & tui
      neofetch
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
      temurin-bin
      croc
      wireguard-tools
      ollama
      ncdu
      zip
      unstable.gitoxide
      genact
    ];

    file = {
      "assets".source = ../../assets;
      ".config/nixpkgs/config.nix".text = "{ allowUnfree = true; allowUnsupportedSystem = true; }";
    };
  };
}
