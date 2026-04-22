{ pkgs, ... }:
{
  home = {
    packages =
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

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
