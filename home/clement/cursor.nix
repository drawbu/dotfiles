{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xcb-util-cursor
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Catppuccin-Mocha-Light-Cursors";
    package = pkgs.catppuccin-cursors.mochaLight;
    size = 24;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Catppuccin-Mocha-Light";
      package = pkgs.catppuccin-cursors.mochaLight;
    };
  };
} 
