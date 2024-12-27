{ pkgs, ... }:
{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "isal"
      "mobile_app"
      "default_config"

      "ffmpeg"
      "sensor"
      "history"
      "recorder"
      "history_stats"
      "logbook"
      "analytics"
      "analytics_insights"

      "freebox"
      "esphome"
      "homekit"
      "homekit_controller"
      "hue"
      "tradfri"
      "weatherkit"
      "met"
      "bring"
      "plex"
      "sonarr"
    ];
    extraPackages =
      p: with p; [
        zlib-ng
        pyatv # apple_tv
        python-otbr-api
      ];
    customComponents = [
      (pkgs.buildHomeAssistantComponent rec {
        owner = "Amateur-God";
        domain = "technitiumdns";
        version = "2.3.0";
        propagatedBuildInputs = with pkgs.python312Packages; [ aiohttp ];
        src = pkgs.fetchFromGitHub {
          owner = "Amateur-God";
          repo = "home-assistant-technitiumdns";
          rev = "v${version}";
          hash = "sha256-WzuBYT+BDYHQx8PqhsgZrE5xCgTdKrSLF3N8Zdv94wo=";
        };
      })
    ];
    configWritable = true;
    config = {
      # default_config = {}; # TODO: fix
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "Europe/Paris";
      };
      isal = { };
      mobile_app = { };
      ffmpeg = { };
      sensor = { };
      history = { };
      recorder = { };
      logbook = { };
      analytics = { };
    };
  };

  networking.firewall.allowedTCPPorts = [ 21064 ]; # homekit
}