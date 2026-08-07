{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mod.profiles.gaming.enable {
    home.packages =
      (with pkgs; [
        prismlauncher
        lunar-client
        (heroic.override {
          extraPkgs =
            pkgs': with pkgs'; [
              gamescope
              gamemode
            ];
        })
        dwarf-fortress
        r2modman
      ])
      ++ (with pkgs.unstable; [
        protonup-ng
      ]);

    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
