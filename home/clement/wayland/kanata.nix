{ lib, pkgs, ... }:
let
  configFile = pkgs.writeText "config.kdb" ''
    ;; Kanata config for caps to esc+ctrl

    (defsrc
      caps
    )

    (defalias
      escctrl (tap-hold 200 200 esc lctrl)
    )

    (deflayer base
      @escctrl
    )

  '';
in
{
  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.kanata} -c ${configFile}";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
