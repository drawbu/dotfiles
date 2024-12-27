{...}: {
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager.startx.enable = true;
  };
}
