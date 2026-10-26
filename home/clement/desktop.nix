{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zathura = {
    enable = lib.mkDefault config.mod.profiles.desktop.enable;
    options.selection-clipboard = "clipboard";
  };

  home.packages = lib.optionals config.mod.profiles.desktop.enable (
    with pkgs;
    [
      chiri
      discord
      (if stdenv.isDarwin then libreoffice-bin else libreoffice-qt6-fresh)
      libresprite
      spotify
      teams-for-linux
      thunderbird
      (if stdenv.isDarwin then vlc-bin else vlc)
    ]
  );
}
