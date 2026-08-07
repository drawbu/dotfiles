{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mod.profiles.gaming.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

      gamemode = {
        enable = true;
        settings.custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
