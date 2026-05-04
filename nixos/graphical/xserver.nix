{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "us_qwerty-fr";
  };

  services.displayManager.gdm = {
    enable = true;
    settings.default_session.command = "${config.programs.niri.package}/bin/niri-session";
  };

  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };

  # NixOS otherwise injects a stripped PATH via Environment= on the niri.service
  # unit which shadows the imported user-manager PATH. Disabling the default
  # lets niri inherit the full PATH set up by niri-session.
  systemd.user.services.niri.enableDefaultPath = false;
}
