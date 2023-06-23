{ pkgs, ... }: {
  # The packages compatible with macOS and Linux

  home.packages = with pkgs; [
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

    # fonts
    jetbrains-mono
    nerdfonts

    # local packages
    (pkgs.callPackage ./vera.nix { })
  ];

  imports = [
    ./neovim.nix
  ];
  
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initExtra = ''
      source ~/.zshrc
    '';
  };
}

