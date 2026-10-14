{ config, lib, ... }:
let
  probes = import ./probes.nix { inherit config lib; };

  # mobile_app names each notify action after the slugified device name
  devices = [
    "iphone_de_clement"
    "ipad_de_clement"
  ];

  notify =
    message:
    map (device: {
      action = "notify.mobile_app_${device}";
      data = {
        title = "rebecca";
        inherit message;
      };
    }) devices;

  # skips the jump from unknown/unavailable after a restart
  increased = "{{ trigger.from_state.state | is_number and trigger.to_state.state | int > trigger.from_state.state | int }}";

  delta = "{{ trigger.to_state.state | int - trigger.from_state.state | int }}";
in
{
  services.home-assistant.config.automation = [
    {
      alias = "Notify on failed units";
      triggers = [
        {
          trigger = "numeric_state";
          entity_id = "sensor.failed_units";
          above = 0;
          for.minutes = 5;
        }
      ];
      actions = notify "failed: {{ state_attr('sensor.failed_units', 'units') | join(', ') }}";
    }

    {
      alias = "Notify when a site goes down";
      triggers = map (p: {
        trigger = "state";
        entity_id = "binary_sensor.${p.id}_online";
        from = "on";
        to = "off";
        for.minutes = 5;
        id = p.host;
      }) probes;
      actions = notify "{{ trigger.id }} is down";
    }

    {
      alias = "Notify when a site recovers";
      triggers = map (p: {
        trigger = "state";
        entity_id = "binary_sensor.${p.id}_online";
        from = "off";
        to = "on";
        id = p.host;
      }) probes;
      # only after an outage long enough to have been notified
      conditions = [
        {
          condition = "template";
          value_template = "{{ now() - trigger.from_state.last_changed > timedelta(minutes=5) }}";
        }
      ];
      actions = notify "{{ trigger.id }} is back";
    }

    {
      alias = "Notify when a disk fills up";
      triggers = [
        {
          trigger = "numeric_state";
          entity_id = [
            "sensor.root_disk"
            "sensor.boot_disk"
          ];
          above = 90;
        }
      ];
      actions = notify "{{ trigger.to_state.name | lower }} at {{ trigger.to_state.state }}%";
    }

    {
      alias = "Notify on new Jellyfin items";
      triggers = [
        {
          trigger = "state";
          entity_id = [
            "sensor.jellyfin_movies"
            "sensor.jellyfin_episodes"
          ];
        }
      ];
      conditions = [
        {
          condition = "template";
          value_template = increased;
        }
      ];
      actions = notify "${delta} new {{ 'movie(s)' if trigger.entity_id.endswith('movies') else 'episode(s)' }} in Jellyfin";
    }
  ];
}
