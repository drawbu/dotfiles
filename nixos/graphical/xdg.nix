{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mod.profiles.desktop.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      xdgOpenUsePortal = true;
      config.common.default = [ "gnome" ];
    };
  };
}
