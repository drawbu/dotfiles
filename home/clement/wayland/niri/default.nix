{ pkgs, ... }:
{
  home.packages = with pkgs; [ xwayland-satellite ];
  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
