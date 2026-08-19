{ pkgs, ... }:
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-PWadA5qr/gR2qDcT8l8u1Xku7LM2HIfWTLOkzezCYy0=";
    };
    email = "letsencrypt@drawbu.dev";
    extraConfig = ''
      (cloudflare) {
        tls {
          dns cloudflare {$API_KEY}
        }
      }
    '';
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = [ "/etc/caddy/.env" ];
}
