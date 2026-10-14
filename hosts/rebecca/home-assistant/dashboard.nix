{ config, lib, ... }:
let
  probes = import ./probes.nix { inherit config lib; };

  heading = text: icon: {
    type = "heading";
    heading = text;
    inherit icon;
  };

  tile =
    entity: name: extra:
    {
      type = "tile";
      inherit entity name;
    }
    // extra;

  gauge = entity: name: tile entity name { features = [ { type = "bar-gauge"; } ]; };

  wide = card: card // { grid_options.columns = "full"; };
in
{
  services.home-assistant.lovelaceConfig = {
    title = "rebecca";
    views = [
      {
        title = "Host";
        path = "host";
        icon = "mdi:server";
        type = "sections";
        max_columns = 3;
        sections = [
          {
            type = "grid";
            cards = [
              (heading "Health" "mdi:heart-pulse")
              (tile "sensor.failed_units" "Failed units" { })
              (tile "sensor.last_deploy" "Last deploy" { })
              (tile "sensor.last_boot" "Last boot" { })
              (wide {
                type = "markdown";
                content = "{% for unit in state_attr('sensor.failed_units', 'units') %}- `{{ unit }}`\n{% endfor %}";
                visibility = [
                  {
                    condition = "numeric_state";
                    entity = "sensor.failed_units";
                    above = 0;
                  }
                ];
              })
            ];
          }

          {
            type = "grid";
            cards = [
              (heading "Resources" "mdi:chip")
              (gauge "sensor.memory_usage" "Memory")
              (tile "sensor.load_1m" "Load" { features = [ { type = "trend-graph"; } ]; })
              (gauge "sensor.root_disk" "/")
              (gauge "sensor.boot_disk" "/boot")
              (wide {
                type = "statistics-graph";
                title = "Load, 7 days";
                days_to_show = 7;
                period = "hour";
                chart_type = "line";
                stat_types = [
                  "mean"
                  "max"
                ];
                entities = [
                  {
                    entity = "sensor.load_15m";
                    name = "15m";
                  }
                ];
              })
            ];
          }

          {
            type = "grid";
            cards = [
              (heading "Sites" "mdi:web")
            ]
            ++ map (p: tile "binary_sensor.${p.id}_online" p.host { }) probes
            ++ [
              (wide {
                type = "history-graph";
                title = "Latency";
                hours_to_show = 24;
                entities = map (p: {
                  entity = "sensor.${p.id}_latency";
                  name = p.host;
                }) probes;
              })
            ];
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
              "sensor.jellyfin_episodes"
              "sensor.jellyfin_movies"
            ];
          }
          {
            type = "history-graph";
            title = "Streams";
            hours_to_show = 168;
            max_y_axis = 5;
            fit_y_data = true;
            entities = [ "sensor.jellyfin_active_streams" ];
          }
        ];
      }
    ];
  };
}
