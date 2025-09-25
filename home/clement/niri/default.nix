{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xwayland-satellite
    swaylock
    playerctl
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
