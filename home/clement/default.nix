# 'clement' user home-manager config for NixOS & generic linux
{ pkgs, unstable, ... }: {
  imports = [
    ./nvim.nix
    ./gtk.nix
    ./firefox.nix
    ./cursor.nix
    ./qtile.nix
    ./zsh.nix
    ./discord.nix
    ../../.config
  ];

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home.file = {
    "assets".source = ../../assets;
    ".gitconfig".source = ../../.gitconfig;
    ".xinitrc".source = ../../.xinitrc;
  };

  home = {
    username = "clement";
    homeDirectory = "/home/clement";

    stateVersion = "23.05";

    packages = with pkgs; [
      # ↓ ricing
      eww

      # ↓ cli & tui
      direnv
      bat
      exa
      wakatime
      btop
      neofetch
      tmux
      speedtest-cli
      wget
      git
      unstable.banana-vera
      lazygit

      # ↓ softwares
      obsidian
      spotify
      vscode
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm
      kitty
      flameshot
      feh
      thunderbird-bin
      vlc
      aseprite

      # ↓ games
      prismlauncher
      heroic

      # ↓ fonts
      jetbrains-mono
      nerdfonts
    ];
  };
}
