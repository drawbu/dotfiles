{pkgs, ...}: {
  home.packages = with pkgs; [
    (catppuccin-gtk.override {
      accents = ["peach"];
      size = "compact";
      tweaks = ["rimless"];
      variant = "mocha";
    })

    (catppuccin-gtk.override {
      accents = ["peach"];
      size = "compact";
      tweaks = ["rimless"];
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

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme.name = "Catppuccin-Mocha-Compact-Peach-Dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
