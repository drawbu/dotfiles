{
  config,
  finputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ finputs.yank.homeModules.default ];

  services.yank = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    settings.clipboard = config.mod.profiles.desktop.enable;
  };
}
