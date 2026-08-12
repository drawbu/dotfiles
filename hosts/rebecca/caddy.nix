{ pkgs, ... }:
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-7GoH8YLCoPmPExQxoga2FHB58zQDoZVf1BBwkVi0SsQ=";
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
