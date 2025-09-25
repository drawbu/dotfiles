{ ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "us_qwerty-fr";
    displayManager.startx.enable = true;
  };
}
