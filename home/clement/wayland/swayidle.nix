{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.mod.idle.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Whether the session dims, locks and suspends on its own once idle, and
      locks before suspending. The manual lock keybind works either way.
    '';
  };

  config.services.swayidle = {
    enable = true;
    events = {
      "before-sleep" =
        lib.mkIf config.mod.idle.enable "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
      "lock" =
        "${lib.getExe config.programs.swaylock.package} -f --screenshots --effect-blur 12x7 --ring-color ffffff --key-hl-color 222222";
    };
    timeouts = lib.optionals config.mod.idle.enable [
      {
        timeout = 150;
        command = "${lib.getExe pkgs.brightnessctl} -s set 10%";
        resumeCommand = "${lib.getExe pkgs.brightnessctl} -r";
      }
      {
        timeout = 600;
        command = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
      }
      {
        timeout = 630;
        command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
      }
    ];
  };
}
