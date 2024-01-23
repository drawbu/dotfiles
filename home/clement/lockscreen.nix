{ pkgs, ... }:
{
  home.file.".local/share/lock/wallpaper.jpg" = {
    source = ./../../assets/wallpapers/hallway-banbooru.jpg;
    onChange = ''
      ${pkgs.betterlockscreen}/bin/betterlockscreen --update ~/.local/share/lock/wallpaper.jpg
    '';
  };

  services.betterlockscreen = {
    enable = true;
    inactiveInterval = 60;
  };
}
