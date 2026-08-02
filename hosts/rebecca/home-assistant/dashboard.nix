{ lib, ... }:
let
  probes = import ./probes.nix lib;

  # only exists once the systemmonitor entry is created in the UI
  systemMonitor = key: "sensor.system_monitor_${key}";
in
{
  services.home-assistant.lovelaceConfig = {
    title = "rebecca";
    views = [
      {
        title = "Overview";
        path = "overview";
        icon = "mdi:heart-pulse";
        cards = [
          {
            type = "entities";
            title = "Sites";
            state_color = true;
            entities = map (p: {
              entity = "binary_sensor.${p.id}_online";
              name = p.host;
            }) probes;
          }
          {
            type = "history-graph";
            title = "Latency";
            hours_to_show = 24;
            entities = map (p: {
              entity = "sensor.${p.id}_latency";
              name = p.host;
            }) probes;
          }
          {
            type = "entities";
            title = "Host";
            entities = [
              { entity = "sensor.failed_units"; }
              {
                entity = systemMonitor "last_boot";
                name = "Last boot";
              }
              {
                entity = systemMonitor "load_15m";
                name = "Load (15 min)";
              }
            ];
          }
          {
            type = "weather-forecast";
            entity = "weather.forecast_home";
            forecast_type = "daily";
            show_current = true;
          }
        ];
      }

      {
        title = "Media";
        path = "media";
        icon = "mdi:filmstrip";
        cards = [
          {
            type = "entities";
            title = "Riven";
            entities = [
              "sensor.riven_items"
              "sensor.riven_movies"
              "sensor.riven_episodes"
              "sensor.riven_incomplete"
            ];
          }
          {
            type = "entities";
            title = "Jellyfin";
            entities = [
              "sensor.jellyfin_movies"
              "sensor.jellyfin_series"
              "sensor.jellyfin_episodes"
              "sensor.jellyfin_active_streams"
            ];
          }
          {
            type = "statistics-graph";
            title = "Library growth";
            days_to_show = 90;
            stat_types = [ "max" ];
            chart_type = "line";
            entities = [
              "sensor.riven_items"
              "sensor.jellyfin_episodes"
              "sensor.jellyfin_movies"
            ];
          }
          {
            type = "history-graph";
            title = "Streams";
            hours_to_show = 168;
            entities = [ "sensor.jellyfin_active_streams" ];
          }
        ];
      }

      {
        title = "System";
        path = "system";
        icon = "mdi:server";
        cards = [
          {
            type = "gauge";
            entity = systemMonitor "processor_use";
            name = "CPU";
            needle = true;
            severity = {
              green = 0;
              yellow = 70;
              red = 90;
            };
          }
          {
            type = "gauge";
            entity = systemMonitor "memory_usage";
            name = "Memory";
            needle = true;
            severity = {
              green = 0;
              yellow = 75;
              red = 90;
            };
          }
          {
            type = "entities";
            title = "Disks";
            entities = [
              {
                entity = systemMonitor "disk_usage";
                name = "/";
              }
              {
                entity = systemMonitor "disk_usage_mnt_library";
                name = "/mnt/library";
              }
            ];
          }
          {
            type = "statistics-graph";
            title = "Load";
            days_to_show = 7;
            stat_types = [
              "mean"
              "max"
            ];
            entities = [
              (systemMonitor "load_1m")
              (systemMonitor "load_15m")
            ];
          }
          {
            type = "history-graph";
            title = "Memory";
            hours_to_show = 168;
            entities = [ (systemMonitor "memory_usage") ];
          }
        ];
      }
    ];
  };
}
