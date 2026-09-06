{ pkgs, ... }:
let
  catppuccin =
    variant:
    pkgs.catppuccin-gtk.override {
      accents = [ "peach" ];
      size = "compact";
      tweaks = [ "rimless" ];
      inherit variant;
    };
in
{
  home.packages = [
    (catppuccin "latte")

    pkgs.glib # gsettings
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-peach-compact+rimless";
      package = catppuccin "mocha";
    };
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
