{ config, lib, pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "loginctl lock-session";
      }
      {
        event = "lock";
        command = "${lib.getExe config.programs.swaylock.package} -f --screenshots --effect-blur 12x7 --ring-color ffffff --key-hl-color 222222";
      }
    ];
    timeouts = [
      {
        timeout = 150;
        command = "${lib.getExe pkgs.brightnessctl} -s set 10";
        resumeCommand = "${lib.getExe pkgs.brightnessctl} -r";
      }
      {
        timeout = 600;
        command = "loginctl lock-session";
      }
      {
        timeout = 630;
        command = "systemctl suspend";
      }
    ];
  };

}
