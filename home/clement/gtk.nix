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

    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme.overrideAttrs (old: {
        version = "unstable-2024-10-02";
        src = pkgs.fetchFromGitHub {
          owner = "NeoWaita";
          repo = "NeoWaita";
          rev = "5b986c9e823e2453b90de81683b8e04cd74f82fd";
          hash = "sha256-W/gKs7RKdB5ZJoxs2kF/z7eojOedJP7dWqqOQLAZsCo=";
        };
        buildInputs = [ pkgs.adwaita-icon-theme ];
      });
    };

    theme.name = "catppuccin-mocha-peach-compact+rimless";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
