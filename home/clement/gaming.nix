{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      protonup
      prismlauncher
      heroic
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
