{
  config,
  lib,
  pkgs,
  ...
}:
let
  herdr-core = pkgs.unstable.callPackage ./herdr-core.nix { };
  herdr-desktop = pkgs.unstable.callPackage ./herdr-desktop.nix { inherit herdr-core; };
in
{
  home.packages =
    lib.optionals pkgs.stdenv.isLinux [
      herdr-core
    ]
    ++ (lib.optionals config.mod.profiles.desktop.enable [ herdr-desktop ]);
}
