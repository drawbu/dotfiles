{ config, ... }:
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

  services.home-assistant.config.rest = [
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
}
