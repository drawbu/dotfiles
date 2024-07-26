{pkgs, ...}: {
  environment.systemPackages = with pkgs.libsForQt5.qt5; [
    qtgraphicaleffects
    qtquickcontrols2
    qtsvg
  ];
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager.startx.enable = true;
  };
}
