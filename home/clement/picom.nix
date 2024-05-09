{pkgs, ...}: {
  services.picom = {
    enable = true;
    backend = "glx";
    package = pkgs.picom.overrideAttrs (old: {
      pname = "picom-FT-Labs";
      version = "2023-09-30";

      src = pkgs.fetchFromGitHub {
        owner = "FT-Labs";
        repo = "picom";
        rev = "98e842e83b5b873c03b13ee835a14ead73359b9d";
        hash = "sha256-dB8DaCPWPoZlyaNaO5A38fpPVzFT6/8tqJ+5B2aYmnI=";
      };

      buildInputs =
        old.buildInputs
        ++ [
          pkgs.xorg.xcbutil
          pkgs.pcre2
        ];
    });
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
