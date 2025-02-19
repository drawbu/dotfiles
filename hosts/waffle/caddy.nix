{ pkgs, ... }:
{
  services.caddy = {
    enable = true;
    package = pkgs.unstable.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20250214163716-188b4850c0f2" ];
      hash = "sha256-wi0Q6BkSymf6buKW/AI1JsDkwCG/KH4n/gq9na5qInk=";
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
