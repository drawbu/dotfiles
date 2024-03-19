{pkgs, ...}: {
  home.packages = [
    (pkgs.catppuccin-gtk.override {
      accents = ["peach"];
      size = "compact";
      tweaks = ["rimless"];
      variant = "mocha";
    })

    (pkgs.catppuccin-gtk.override {
      accents = ["peach"];
      size = "compact";
      tweaks = ["rimless"];
      variant = "latte";
    })
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
    platformTheme = "gtk";
  };
}
