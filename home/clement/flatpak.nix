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
    "dev.vencord.Vesktop"
    "com.discordapp.Discord"
    "org.prismlauncher.PrismLauncher"
    "com.github.IsmaelMartinez.teams_for_linux"
    "com.spotify.Client"
    "com.heroicgameslauncher.hgl"
    "md.obsidian.Obsidian"
    "io.github.ungoogled_software.ungoogled_chromium"
    "org.libreoffice.LibreOffice"
    "org.videolan.VLC"
    "com.obsproject.Studio"
    "com.github.tchx84.Flatseal"
    "org.kde.filelight"
    "org.gnome.SimpleScan"
  ];
}
