{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-shana
    ];
    xdgOpenUsePortal = true;

    config = {
      common = {
        default = "gtk";
        "org.freedesktop.impl.portal.FileChooser" = "shana";
      };
    };
  };
}
