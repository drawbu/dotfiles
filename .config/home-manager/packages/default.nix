{ pkgs, ... }: {
  # The packages compatible with macOS and Linux

  home.packages = with pkgs; [
    # cli & tui
    direnv
    neovim
    bat
    exa
    wakatime
    htop
    neofetch
    tmux
    speedtest-cli

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
}
