{ pkgs, ... }:
let
  adi1090x_rofi = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "d6906d91b591066783eb5b7b8fcc1e12cba48356";
    hash = "sha256-PGK4/+HY1nWHin5N5s2HNBT4bBkUjKXvMRTfocfprCE=";
  };
in
{
  home = {
    packages = with pkgs; [ rofi ];
    file = {
      ".config/rofi/config.rasi".source = ./config.rasi;
      ".config/rofi/applets".source = "${adi1090x_rofi}/files/applets";
      ".config/rofi/colors".source = "${adi1090x_rofi}/files/colors";
      ".config/rofi/images".source = "${adi1090x_rofi}/files/images";
      ".config/rofi/launchers".source = "${adi1090x_rofi}/files/launchers";
      ".config/rofi/powermenu".source = "${adi1090x_rofi}/files/powermenu";
      ".config/rofi/scripts".source = "${adi1090x_rofi}/files/scripts";
    };
  };
}
