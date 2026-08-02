{
  config,
  lib,
  pkgs,
  ...
}:
let
  # %{http_code} is quoted because curl renders it as the literal `000` on a
  # transport-level failure, and `000` is not a valid JSON number.
  writeOut = ''{"code":"%{http_code}","latency":%{time_total}}'';

  # curl still writes the document on those failures, it just also exits
  # non-zero, and command_line discards the whole update on a non-zero exit.
  probe =
    host:
    lib.concatStringsSep " " [
      (lib.getExe pkgs.curl)
      "--silent --location --max-time 10 --output /dev/null"
      "--write-out ${lib.escapeShellArg writeOut}"
      "https://${host}"
      "|| true"
    ];

  probes = import ./probes.nix lib;
in
{
  # multiline 1password field, a YAML mapping consumed as secrets.yaml:
  #   riven_api_key      (same value as RIVEN_API_KEY in op://deploy/riven/env)
  #   jellyfin_api_key   (Jellyfin -> Dashboard -> API Keys)
  services.onepassword-secrets.secrets.homeAssistantSecrets = {
    reference = "op://deploy/home-assistant/secrets";
    path = "${config.services.home-assistant.configDir}/secrets.yaml";
    owner = "hass";
    group = "hass";
    mode = "0400";
    services = [ "home-assistant" ];
  };

  # opnix writes the secret before home-assistant.service creates its
  # StateDirectory, so the config dir has to already exist at that point.
  systemd.tmpfiles.rules = [
    "d ${config.services.home-assistant.configDir} 0700 hass hass - -"
  ];

  services.home-assistant.config = {
    command_line =
      map (p: {
        sensor = {
          name = "${p.host} probe";
          unique_id = "probe_${p.id}";
          command = probe p.host;
          command_timeout = 15;
          scan_interval = 120;
          value_template = "{{ value_json.code | int(0) }}";
          json_attributes = [ "latency" ];
        };
      }) probes
      ++ [
        {
          sensor = {
            name = "Failed units";
            unique_id = "systemd_failed_units";
            command = "${lib.getExe' pkgs.systemd "systemctl"} --failed --no-legend --plain | ${lib.getExe' pkgs.coreutils "wc"} -l";
            scan_interval = 300;
            state_class = "measurement";
            icon = "mdi:alert-circle-outline";
          };
        }
      ];

    template = [
      {
        binary_sensor = map (p: {
          name = "${p.host} online";
          unique_id = "probe_${p.id}_online";
          device_class = "connectivity";
          state = "{% set code = states('sensor.${p.id}_probe') | int(0) %}{{ 200 <= code and code < 400 }}";
        }) probes;
        sensor = map (p: {
          name = "${p.host} latency";
          unique_id = "probe_${p.id}_latency";
          device_class = "duration";
          unit_of_measurement = "ms";
          state_class = "measurement";
          # code 0 means the request never completed, so there is no latency to
          # record; without this the statistics take a 0ms sample on every miss.
          availability = "{{ states('sensor.${p.id}_probe') | int(0) > 0 }}";
          state = "{{ (state_attr('sensor.${p.id}_probe', 'latency') | float(0) * 1000) | round(1) }}";
        }) probes;
      }
    ];

    rest = [
      {
        resource = "http://127.0.0.1:8080/api/v1/stats";
        headers."x-api-key" = "!secret riven_api_key";
        scan_interval = 300;
        sensor = [
          {
            name = "Riven items";
            unique_id = "riven_items";
            state_class = "measurement";
            value_template = "{{ value_json.total_items }}";
            icon = "mdi:filmstrip-box-multiple";
          }
          {
            name = "Riven movies";
            unique_id = "riven_movies";
            state_class = "measurement";
            value_template = "{{ value_json.total_movies }}";
            icon = "mdi:movie-open";
          }
          {
            name = "Riven episodes";
            unique_id = "riven_episodes";
            state_class = "measurement";
            value_template = "{{ value_json.total_episodes }}";
            icon = "mdi:television-classic";
          }
          {
            name = "Riven incomplete";
            unique_id = "riven_incomplete";
            state_class = "measurement";
            value_template = "{{ value_json.incomplete_items }}";
            icon = "mdi:progress-alert";
          }
        ];
      }
      {
        resource = "http://127.0.0.1:8096/Items/Counts";
        headers."X-Emby-Token" = "!secret jellyfin_api_key";
        scan_interval = 300;
        sensor = [
          {
            name = "Jellyfin movies";
            unique_id = "jellyfin_movies";
            state_class = "measurement";
            value_template = "{{ value_json.MovieCount }}";
            icon = "mdi:movie-open";
          }
          {
            name = "Jellyfin series";
            unique_id = "jellyfin_series";
            state_class = "measurement";
            value_template = "{{ value_json.SeriesCount }}";
            icon = "mdi:television-classic";
          }
          {
            name = "Jellyfin episodes";
            unique_id = "jellyfin_episodes";
            state_class = "measurement";
            value_template = "{{ value_json.EpisodeCount }}";
            icon = "mdi:playlist-play";
          }
        ];
      }
      {
        resource = "http://127.0.0.1:8096/Sessions";
        headers."X-Emby-Token" = "!secret jellyfin_api_key";
        scan_interval = 60;
        sensor = [
          {
            # /Sessions lists idle clients too, only NowPlayingItem ones stream
            name = "Jellyfin active streams";
            unique_id = "jellyfin_active_streams";
            state_class = "measurement";
            value_template = "{{ value_json | selectattr('NowPlayingItem', 'defined') | list | count }}";
            icon = "mdi:play-network";
          }
        ];
      }
    ];
  };
}
