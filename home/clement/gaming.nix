{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      protonup
      prismlauncher
      heroic
      lutris
      unstable.r2modman
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
