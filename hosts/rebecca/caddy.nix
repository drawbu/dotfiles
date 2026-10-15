{ pkgs, ... }:
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-xRJ5evsAJ2akg47j3Bt6YDXJOgX88B/rKNP50KSVyNY=";
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
