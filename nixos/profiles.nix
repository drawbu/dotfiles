{ lib, ... }:
{
  options.mod.profiles = {
    desktop.enable = lib.mkEnableOption "desktop workstation profile";
    gaming.enable = lib.mkEnableOption "gaming profile";
  };
}
