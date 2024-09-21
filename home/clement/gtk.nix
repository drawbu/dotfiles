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
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme.overrideAttrs (old: {
        version = "unstable-2024-09-19";
        src = pkgs.fetchFromGitHub {
          owner = "MoreWaita-Dev";
          repo = "MoreWaita";
          rev = "cc79d82f74034fb0cad6fe50d7fc5dee755546ba";
          hash = "sha256-NkvrjeaIhx4aw0PC56fCxj0R+ZNKVEAhFPhzLEWGhh0=";
        };
        buildInputs = [pkgs.gnome.adwaita-icon-theme];
      });
    };

    theme.name = "Catppuccin-Mocha-Compact-Peach-Dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
