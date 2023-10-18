{ pkgs, ... }:
let
  lock = "${pkgs.i3lock}/bin/i3lock -c 000000 -fe";
in
{
  home.file."lock" = {
    text = lock;
    executable = true;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = lock;
    inactiveInterval = 60;
  };
}
