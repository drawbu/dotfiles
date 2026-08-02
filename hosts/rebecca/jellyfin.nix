{
  config,
  lib,
  pkgs,
  ...
}:
let
  library = "/mnt/library";
in
{
  # multiline 1password field, consumed verbatim as an env file:
  #   RIVEN_API_KEY, BACKEND_API_KEY  (same value, riven and its frontend)
  #   AUTH_SECRET                     (frontend session signing)
  #   RIVEN_DOWNLOADERS_REAL_DEBRID_API_KEY
  #   RIVEN_DOWNLOADERS_ALL_DEBRID_API_KEY
  #   RIVEN_UPDATERS_JELLYFIN_API_KEY
  services.onepassword-secrets.secrets.rivenEnv = {
    reference = "op://deploy/riven/env";
    services = [
      "podman-riven"
      "podman-riven-frontend"
    ];
  };

  users.groups.media.gid = 990;
  users.users.jellyfin.extraGroups = [ "media" ];

  # podman does not create bind-mount sources, unlike docker
  systemd.tmpfiles.rules = [
    "d /var/lib/riven          0750 1000 ${toString config.users.groups.media.gid} - -"
    "d /var/lib/riven/data     0750 1000 ${toString config.users.groups.media.gid} - -"
    "d /var/lib/riven-frontend 0700 root root - -"
    "d ${library}              0775 root media - -"
  ];

  virtualisation.oci-containers.containers = {
    riven-db = {
      image = "postgres:16-alpine";
      environment = {
        POSTGRES_DB = "riven";
        POSTGRES_USER = "riven";
        POSTGRES_PASSWORD = "riven";
        PGDATA = "/var/lib/postgresql/data/pgdata";
      };
      volumes = [ "riven-db:/var/lib/postgresql/data" ];
      networks = [ "jellyfin" ];
    };

    riven = {
      image = "ghcr.io/rivenmedia/riven:sha-ae94fea";
      dependsOn = [ "riven-db" ];
      environment = {
        TZ = config.time.timeZone;
        PUID = "1000";
        PGID = toString config.users.groups.media.gid;
        RIVEN_FORCE_ENV = "true";
        RIVEN_DATABASE_HOST = "postgresql+psycopg2://riven:riven@riven-db/riven";

        RIVEN_FILESYSTEM_MOUNT_PATH = "/mount";
        # the default cache_dir is /dev/shm, which is RAM and caps out at 15G
        RIVEN_FILESYSTEM_CACHE_DIR = "/riven/data/cache";
        RIVEN_FILESYSTEM_CACHE_MAX_SIZE_MB = "51200";

        RIVEN_SCRAPING_TORRENTIO_ENABLED = "true";
        RIVEN_SCRAPING_RARBG_ENABLED = "true";

        RIVEN_UPDATERS_LIBRARY_PATH = library;
        RIVEN_UPDATERS_JELLYFIN_ENABLED = "true";
        RIVEN_UPDATERS_JELLYFIN_URL = "http://host.containers.internal:8096";

        # all-debrid + real-debrid for fallback in case of keyword-filters blocks
        RIVEN_DOWNLOADERS_REAL_DEBRID_ENABLED = "true";
        RIVEN_DOWNLOADERS_ALL_DEBRID_ENABLED = "true";
      };
      environmentFiles = [ config.services.onepassword-secrets.secretPaths.rivenEnv ];
      volumes = [
        "/var/lib/riven/data:/riven/data"
        "${library}:/mount:rshared"
      ];
      ports = [ "8080:8080" ]; # needed by home-assistant
      networks = [ "jellyfin" ];
      extraOptions = [
        "--cap-add=SYS_ADMIN"
        "--device=/dev/fuse"
        "--shm-size=1g"
      ];
    };

    riven-frontend = {
      image = "ghcr.io/rivenmedia/riven-frontend:sha-3c92981";
      dependsOn = [ "riven" ];
      environment = {
        TZ = config.time.timeZone;
        ORIGIN = "https://riven.drawbu.dev";
        BACKEND_URL = "http://riven:8080";
        DATABASE_URL = "/riven/data/riven.db";
      };
      environmentFiles = [ config.services.onepassword-secrets.secretPaths.rivenEnv ];
      volumes = [ "/var/lib/riven-frontend:/riven/data" ];
      ports = [ "3000:3000" ];
      networks = [ "jellyfin" ];
    };
  };

  mod.podman.networks = [ "jellyfin" ];

  systemd.services = {
    jellyfin = {
      after = [ "podman-riven.service" ];
      wants = [ "podman-riven.service" ];
    };

    # riven builds the vfs inside the container and propagates it out via rshared,
    # so the mount outlives the container that served it and podman then refuses
    # to bind a stale endpoint. propagation also needs the bind source to be a
    # shared mount point, which a plain directory is not.
    podman-riven.serviceConfig.ExecStartPre = lib.mkAfter [
      "${pkgs.writeShellScript "riven-mount-prep" ''
        ${lib.getExe' pkgs.util-linux "umount"} --recursive --lazy ${library} 2>/dev/null || true
        ${lib.getExe' pkgs.util-linux "mount"} --bind ${library} ${library}
        ${lib.getExe' pkgs.util-linux "mount"} --make-rshared ${library}
      ''}"
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.caddy.virtualHosts = {
    "jellyfin.drawbu.dev".extraConfig = ''
      reverse_proxy 127.0.0.1:8096
      import cloudflare
    '';
    "riven.drawbu.dev".extraConfig = ''
      reverse_proxy 127.0.0.1:3000
      import cloudflare
    '';
  };
}
