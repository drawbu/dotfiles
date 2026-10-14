{ config, ... }:
{
  imports = [
    ./dashboard.nix
    ./host.nix
    ./monitoring.nix
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "isal"
      "default_config"
      "rest"
      "met"
      "mcp_server"
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
      history = { };
      recorder = { };
      logbook = { };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" ];
      };
    };
  };

  services.caddy.virtualHosts."home-assistant.drawbu.dev" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.home-assistant.config.http.server_port}
      import cloudflare
    '';
  };
}
