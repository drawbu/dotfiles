{ ... }:
{
  services.xserver = {
    enable = false;
    xkb.layout = "us_qwerty-fr";
  };

  services.greetd.enable = true;
  programs.regreet.enable = true;

  services.displayManager.gdm.enable = false;

  programs.niri.enable = true;

  # NixOS otherwise injects a stripped PATH via Environment= on the niri.service
  # unit which shadows the imported user-manager PATH. Disabling the default
  # lets niri inherit the full PATH set up by niri-session.
  systemd.user.services.niri.enableDefaultPath = false;
}
