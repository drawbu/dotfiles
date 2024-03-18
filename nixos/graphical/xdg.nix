{
  pkgs,
  hyprland,
  ...
}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      hyprland.xdg-desktop-portal-hyprland
    ];
  };
}
