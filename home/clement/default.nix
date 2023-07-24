# 'clement' user home-manager config for NixOS & generic linux
{ pkgs, unstable, ... }: {
  imports = [
    ../packages/nvim.nix
  ];

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home = {
    username = "clement";
    homeDirectory = "/home/clement";

    stateVersion = "23.05";

    packages = with pkgs; [
      # ↓ ricing
      picom
      qtile
      eww
      dunst

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

      # ↓ softwares
      jetbrains-toolbox
      discord
      obsidian
      spotify
      vscode
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm
      firefox
      kitty
      flameshot
      feh
      thunderbird
      vlc

      # ↓ games
      prismlauncher

      # ↓ fonts
      jetbrains-mono
      nerdfonts
    ];
  };

  programs.zsh = {
    enable = true;
    dotDir = ".nix-zsh";
    initExtra = ''
      source ~/.zshrc
      '';
  };
}
