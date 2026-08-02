# `id` mirrors homeassistant.util.slugify: HA derives the entity_id from an
# entity's `name`, and monitoring.nix and dashboard.nix have to agree on it.
lib:
map
  (host: {
    inherit host;
    id = lib.replaceStrings [ "." "-" ] [ "_" "_" ] host;
  })
  [
    "drawbu.dev"
    "riven.drawbu.dev"
    "jellyfin.drawbu.dev"
    "reflog.sh"
  ]
