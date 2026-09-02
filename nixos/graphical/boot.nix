{
  config,
  lib,
  pkgs,
  ...
}:
let
  minegrub = pkgs.fetchFromGitHub {
    owner = "Lxtharia";
    repo = "minegrub-world-sel-theme";
    rev = "29bfe180a086454e8cd7a690ed0a0d0ed10446c1";
    hash = "sha256-Hlp081T6HUd4n6CaTf3aousZwBuBly6+0T+Y2d5y+SE=";
  };
in
{
  config = lib.mkIf config.mod.profiles.desktop.enable {
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
  };
}
