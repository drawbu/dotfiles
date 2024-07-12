{
  finputs,
  config,
  ...
}: {
  imports = [finputs.nix-flatpak.homeManagerModules.nix-flatpak];

  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    "/var/lib/flatpak/exports/share"
  ];

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
    "org.gnome.SimpleScan"
  ];
}
