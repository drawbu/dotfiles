{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./firefox.nix
  ];

  config = lib.mkIf (config.mod.profiles.desktop.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [
      (callPackage ./helium.nix { })
    ];
  };
}
