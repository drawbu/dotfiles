{
  config,
  lib,
  pkgs,
  ...
}:
{
  # multiline 1password field, consumed verbatim as an env file:
  #   RCON_PASSWORD  (shared by the server and its backup sidecar)
  services.onepassword-secrets.secrets.minecraftEnv = {
    reference = "op://deploy/minecraft/env";
    services = [
      "podman-gtnh"
      "podman-gtnh-backup"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft          0750 1000 1000 - -"
    "d /var/lib/minecraft/gregtech 0750 1000 1000 - -"
    "d /var/lib/minecraft/backups  0750 1000 1000 - -"
  ];

  virtualisation.oci-containers.containers = {
    gtnh = {
      image = "itzg/minecraft-server:java25";
      environment = {
        TZ = config.time.timeZone;
        EULA = "TRUE";
        TYPE = "GTNH";
        GTNH_PACK_VERSION = "2.8.4";
        MEMORY = "6G";

        USE_AIKAR_FLAGS = "true";
        JVM_XX_OPTS = "-XX:-DontCompileHugeMethods -XX:ReservedCodeCacheSize=400M";
        MAX_TICK_TIME = "315360000000"; # worldgen
        VIEW_DISTANCE = "6";
      };
      environmentFiles = [ config.services.onepassword-secrets.secretPaths.minecraftEnv ];
      volumes = [ "/var/lib/minecraft/gregtech:/data" ];
      ports = [ "25565:25565" ];
      networks = [ "minecraft" ];
      extraOptions = [ "--stop-timeout=90" ];
    };

    gtnh-backup = {
      image = "itzg/mc-backup:2026.7.3";
      dependsOn = [ "gtnh" ];
      environment = {
        TZ = config.time.timeZone;
        RCON_HOST = "gtnh";
        RCON_RETRIES = "-1";
        CRON_SCHEDULE = "0 4 * * *";
        TAR_COMPRESS_METHOD = "zstd";
        PRUNE_BACKUPS_DAYS = "7";
      };
      environmentFiles = [ config.services.onepassword-secrets.secretPaths.minecraftEnv ];
      volumes = [
        "/var/lib/minecraft/gregtech:/data:ro"
        "/var/lib/minecraft/backups:/backups"
      ];
      networks = [ "minecraft" ];
    };
  };

  mod.podman.networks = [ "minecraft" ];

  systemd.services = {
    podman-gtnh = {
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      serviceConfig = {
        RestartSec = 10;
        CPUWeight = 1000;
      };
    };

    podman-gtnh-backup.serviceConfig.CPUWeight = 50;

    # 1.7.10 modded leaks across a long uptime
    gtnh-restart = {
      serviceConfig = {
        Type = "oneshot";
        TimeoutStartSec = 300;
        ExecStart = "${lib.getExe' pkgs.systemd "systemctl"} restart podman-gtnh.service";
      };
    };
  };

  systemd.timers.gtnh-restart = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "*-*-* 05:00:00 UTC";
  };
}
