{ pkgs, ... }:
{
  imports = [ ./dark.nix ] ++ (pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ ./fixwifi.nix ]);
}
