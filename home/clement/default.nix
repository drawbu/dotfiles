# 'clement' user home-manager config for NixOS & generic linux
{ pkgs, unstable, ... }: {
  imports = [
    ./nvim.nix
    ./gtk.nix
    ./firefox.nix
    ./cursor.nix
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
      lazygit

      # ↓ softwares
      discord
      discocss
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
      rofi
      heroic

      # ↓ games
      prismlauncher

      # ↓ fonts
      jetbrains-mono
      nerdfonts

      # ↓ misc
      brightnessctl
      xcb-util-cursor
      pamixer
      libnotify
      upower
      playerctl
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
