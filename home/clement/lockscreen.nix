{ pkgs, ... }:
let
  lock = "${pkgs.i3lock}/bin/i3lock -c 000000 -fe -i ${./../../assets/wallpapers/diner.png}";
in
{
  home.file."scripts/lock" = {
    text = lock;
    executable = true;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "sh ~/scripts/lock";
    inactiveInterval = 60;
  };
}
