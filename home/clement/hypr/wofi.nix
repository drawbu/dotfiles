{...}: let
  colors = import ./colors.nix {theme = "dark";};
in {
  programs.wofi = {
    enable = true;
    settings = {
      allow_markup = true;
      allow_images = true;
    };
    style = ''
      @import "~/theme.css";

      * {
        font-family: "Iosevka Nerd Font";
      }

      window {
        background-color: var(${colors.background.css});
        color = var(${colors.foreground.css});
      }
    '';
  };
}
