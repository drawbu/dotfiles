{ ... }:
{
  services.xserver = {
    enable = true;
    layout = "fr";
    libinput.enable = true;

    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        catppuccin
        typing-extensions
      ];
    };
    desktopManager.gnome.enable = true;
    displayManager.startx.enable = true;
  };

}
