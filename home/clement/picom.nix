{pkgs, ...}: {
  services.picom = {
    enable = true;
    backend = "glx";
    package = pkgs.picom;
    vSync = true;
    opacityRules = [
      "95:class_g = 'kitty'"
      "95:class_g = 'thunderbird'"
      "95:class_g = 'Thunar'"
      "95:class_g = 'Spotify'"
      "95:class_g = 'obsidian'"
    ];
    settings = {
      animations = true;
      animation-window-mass = 0.5;
      animation-clamping = true;
      animation-for-open-window = "zoom";
      animation-delta = 10; # Adjust this value
      animation-stiffness = 110; # Adjust this value
      animation-dampening = 20; # Adjust this value
      animation-for-unmap-window = "slide-left";
      animation-for-transient-window = "slide-down";
    };
  };
}
