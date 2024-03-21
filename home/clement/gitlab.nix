{pkgs, ...}: {
  systemd.user.services.gitlab-runner = {
    Unit = {
      Description = "Gitlab runner";
      After = ["network.target"];
    };

    Install = {
      WantedBy = ["multi-user.target"];
    };

    Service = {
      ExecStart = "${pkgs.gitlab-runner}/bin/gitlab-runner run";
      Restart = "always";
      RestartSec = 3;
    };
  };
}
