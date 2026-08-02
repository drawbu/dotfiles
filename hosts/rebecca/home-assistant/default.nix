{ config, pkgs, ... }:
{
  imports = [
    ./monitoring.nix
    ./dashboard.nix
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

      "mqtt" # bambu_lab manifest dependency
    ];
    extraPackages =
      p: with p; [
        zlib-ng
        python-otbr-api # thread, pulled in by default_config
      ];
    customComponents = [
      # cloudscraper and curl_cffi are imported behind a try/except and only
      # reached by Bambu Cloud auth, so LAN mode needs neither packaged.
      (pkgs.buildHomeAssistantComponent rec {
        owner = "greghesp";
        domain = "bambu_lab";
        version = "2.2.22";
        propagatedBuildInputs = [ config.services.home-assistant.package.python3Packages.beautifulsoup4 ];
        src = pkgs.fetchFromGitHub {
          owner = "greghesp";
          repo = "ha-bambulab";
          tag = "v${version}";
          hash = "sha256-JRJ+tfllDuMrtz+5VQL2l5nkhJQXRoNvsvFnrReSZHE=";
        };
      })
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
