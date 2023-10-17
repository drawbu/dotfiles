{ pkgs, ... }:
let
  joshMDotfiles  = pkgs.fetchFromGitHub {
    owner = "JoshM-Yoru";
    repo = "dotfiles";
    rev = "288925e761d7c81c6a91ea585d0abfe327e0935c";
    hash = "sha256-mU4/cz7HFHeIH+Sny8sBmEkpHYz3aGDG0oZj4s7LVlI=";
  };
in
{
  home = {
    file = {
      ".config/hypr/hyprland.conf".source = ./hyprland.conf;
      ".config/waybar".source = "${joshMDotfiles}/waybar";
      ".config/wofi".source = "${joshMDotfiles}/wofi";
    };
    packages = with pkgs; [
      hyprland
      wofi
      waybar
      swaybg
      swaylock
    ];
  };
}
