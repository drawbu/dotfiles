{ lib, ... }:
{
  options.mod.profiles.desktop.enable = lib.mkEnableOption "desktop workstation profile";
}
