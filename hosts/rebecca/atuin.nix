{
  services.atuin = {
    enable = true;
    # openRegistration = true;
  };

  services.caddy.virtualHosts."atuin.drawbu.dev".extraConfig = ''
    reverse_proxy 127.0.0.1:8888
    import cloudflare
  '';
}
