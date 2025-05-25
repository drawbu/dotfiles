{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../nixos/overlay.nix
    ./vim
    ./shell
    ./git.nix
    ./dev
    ./tmux.nix
    ./btop.nix
    ./gh.nix
    ./wallpapers
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
      croc
      wireguard-tools
      ollama
      ncdu
      zip
      genact
      dust
    ];
  };

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; allowUnsupportedSystem = true; }";
}
