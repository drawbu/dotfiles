{pkgs, ...}:
{
  home = {
    packages = with pkgs; [protonup];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
