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
    ./helix.nix
    ./gh.nix
    ./jujutsu.nix
    ./wallpapers
    ./fonts.nix
    ./waybar.nix
    ./swayidle.nix
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
      unstable.ollama-rocm
      ncdu
      zip
      genact
      dust
      dig
      sox
    ];
  };

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; allowUnsupportedSystem = true; }";
}
