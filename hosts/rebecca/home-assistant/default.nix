{ config, ... }:
{
  imports = [
    ./dashboard.nix
    ./monitoring.nix
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "isal"
      "mobile_app"
      "default_config"

      "ffmpeg"
      "sensor"
      "history"
      "history_stats"
      "logbook"
      "recorder"
      "analytics"
      "analytics_insights"

      "rest"

      "met"

      "esphome"
      "homekit"
      "homekit_controller"
    ];
    extraPackages =
      p: with p; [
        zlib-ng
        python-otbr-api # thread, pulled in by default_config
      ];
    config = {
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = config.time.timeZone;
      };
      isal = { };
      mobile_app = { };
      ffmpeg = { };
      sensor = { };
      history = { };
      recorder = { };
      logbook = { };
      analytics = { };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 21064 ]; # homekit

  services.caddy.virtualHosts."home-assistant.drawbu.dev" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.home-assistant.config.http.server_port}
      import cloudflare
    '';
  };
}
