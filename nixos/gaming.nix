{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mod.profiles.gaming.enable {
    environment.systemPackages = [ pkgs.mangohud ];

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      gamescope.args = [ "--mangoapp" ];

      gamemode = {
        enable = true;
        settings = {
          general.renice = 10;

          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
    };
  };
}
