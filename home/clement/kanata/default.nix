{pkgs, ...}: {
  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.lib.getExe pkgs.kanata} -c ${./config.kbd}";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
