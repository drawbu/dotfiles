{ ... }:
{
  services.home-assistant.lovelaceConfig = {
    title = "rebecca";
    views = [
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
            entities = [ "sensor.jellyfin_active_streams" ];
          }
        ];
      }
    ];
  };
}
