{ pkgs, ... }:
{
  # Plex
  services.plex = {
    enable = true;
    openFirewall = true;
    extraScanners = with pkgs; [
      sonarr
      radarr
    ];
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
  };
}
