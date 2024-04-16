{pkgs, ...}: let
  minegrub = pkgs.fetchFromGitHub {
    owner = "Lxtharia";
    repo = "minegrub-world-sel-theme";
    rev = "4fd49ce76c6ed5077676326aeb99d69db480575e";
    hash = "sha256-59fehgaYd4zz2A0A90qMtnKtPBGqW4Njk8niYPL2E0o=";
  };
in {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080x32";
        theme = "${minegrub}/minegrub-world-selection";
      };
    };

    consoleLogLevel = 0;
  };
}
