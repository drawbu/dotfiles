{ pkgs, ... }: {
  # The packages compatible with macOS and Linux

  home.packages = with pkgs; [
      direnv
      zsh

      # unfree
      discord

      # fonts
      jetbrains-mono
      nerdfonts

      # local packages
      (pkgs.callPackage packages/vera.nix { })
  ];
}