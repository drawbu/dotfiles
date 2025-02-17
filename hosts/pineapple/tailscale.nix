{ config, ... }:
let
  tailnet_url = "tailnet.drawbu.dev";
in
{
  services.tailscale.enable = true;

  services.headscale = {
    enable = true;
    settings = {
      dns.base_domain = "local";
      server_url = "https://${tailnet_url}";
    };
  };

  services.caddy = {
    enable = true;
    email = "letsencrypt@drawbu.dev";
    virtualHosts = {
      "${tailnet_url}" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.headscale.port}
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
