{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  package = pkgs.callPackage ./package.nix { };
in
{
  programs.onepassword-secrets.secrets.soloistApiKey = {
    path = ".config/soloist/api-key";
    reference = "op://nixos/Soloist/token";
  };

  home.packages = [ package ];

  systemd.user.services.soloist = {
    Unit = {
      Description = "Spotify Soloist";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = pkgs.writeShellScript "soloist" ''
        exec ${lib.getExe package} \
          --device-name ${lib.escapeShellArg osConfig.networking.hostName} \
          --api-key "$(<${config.programs.onepassword-secrets.secretPaths.soloistApiKey})"
      '';
      Restart = "always";
      RestartSec = 5;
    };
  };
}
