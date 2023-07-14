{ config, pkgs, ... }: {

  imports = [
    ./packages/games.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "gabriel";
    homeDirectory = "/home/gabriel";

    stateVersion = "23.05";

    packages = with pkgs; [
      picom
      qtile
      firefox
      kitty
      flameshot
      xfce.thunar

      # unfree
      jetbrains-toolbox
      # cli & tui
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

      # softwares
      discord
      obsidian
      spotify
      vscode
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm

      # fonts
      jetbrains-mono
      nerdfonts
    ];
  };
    
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      initExtra = ''
        source ~/.zshrc
      '';
    };
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
