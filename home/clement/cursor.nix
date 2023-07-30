{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Catppuccin-Macchiato-Dark-Cursors";
    package = pkgs.catppuccin-cursors.macchiatoDark;
    size = 24;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Catppuccin-Macchiato-Dark";
      package = pkgs.catppuccin-cursors.macchiatoDark;
    };
  };
} 
