{pkgs, ...}: {
  environment.systemPackages = with pkgs.libsForQt5.qt5; [
    qtgraphicaleffects
    qtquickcontrols2
    qtsvg
  ];
  services.xserver = {
    enable = true;
    layout = "fr";
    libinput.enable = true;
    displayManager.startx.enable = true;
  };
}
