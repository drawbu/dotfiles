{ pkgs, ... }:
{
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Catppuccin-Macchiato-Dark";
      package = pkgs.catppuccin-cursors.macchiatoDark;
    };
  };
} 
