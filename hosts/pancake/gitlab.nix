{ config, pkgs, ... }:
{
  services.gitlab-runner = {
    enable = true;
    gracefulTermination = false;

    settings = {
      concurrent = 1;
    };

    clear-docker-cache = {
      enable = true;
      package = pkgs.docker;
    };

    services."nixos/pancake" = {
      description = "Epic runner on pancake";
      executor = "docker";
      dockerImage = "alpine:latest";
      # dockerVolumes = [ "/var/cache/gitlab-runner" ];
      authenticationTokenConfigFile = "${config.home.homeDirectory}/.env.gitlab-runner";
      # cacheDir = "/var/cache/gitlab-runner";
    };
  };
}
