{ ... }:
{
  services.jellyfin.enable = true;

  services.caddy.virtualHosts."jellyfin.drawbu.dev".extraConfig = ''
    reverse_proxy 127.0.0.1:8096
    import cloudflare
  '';
}
