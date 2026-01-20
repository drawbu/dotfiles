{ pkgs, ... }:
{
  home = {
    packages = with pkgs.unstable; [
      protonup-ng
      prismlauncher
      lunar-client
      heroic
      lutris
      r2modman
      dwarf-fortress
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
