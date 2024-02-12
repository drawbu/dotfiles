{ ... }:
let
  colors = import ./colors.nix { };
in
{
  programs.wofi = {
    enable = true;
    settings = {
      allow_markup = true;
      allow_images = true;
    };
    style = ''
      * {
        font-family: "Iosevka Nerd Font";
      }

      window {
        background-color: #${colors.background};
        color = #${colors.foreground};
      }
    '';
  };
}
