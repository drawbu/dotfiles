{pkgs, ...}: {
  home.packages = with pkgs; [xcb-util-cursor];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "catppuccin-mocha-light-cursors";
    package = pkgs.catppuccin-cursors.mochaLight;
    size = 16;
  };

  gtk.cursorTheme = {
    name = "catppuccin-mocha-light-cursors";
    package = pkgs.catppuccin-cursors.mochaLight;
  };
}
