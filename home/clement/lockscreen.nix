{ pkgs, ... }:
let
  lock = "${pkgs.i3lock}/bin/i3lock -c 000000 -fe -i ${./../../assets/wallpapers/diner.png}";
in
{
  home.file.".local/bin/lock" = {
    text = lock;
    executable = true;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "sh ~/.local/bin/lock";
    inactiveInterval = 60;
  };
}
