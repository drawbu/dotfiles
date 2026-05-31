{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (catppuccin-gtk.override {
      accents = [ "peach" ];
      size = "compact";
      tweaks = [ "rimless" ];
      variant = "mocha";
    })

    (catppuccin-gtk.override {
      accents = [ "peach" ];
      size = "compact";
      tweaks = [ "rimless" ];
      variant = "latte";
    })

    glib # gsettings
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
    theme.name = "catppuccin-mocha-peach-compact+rimless";
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
