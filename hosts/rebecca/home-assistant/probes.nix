# `id` mirrors homeassistant.util.slugify: HA derives the entity_id from an
# entity's `name`, and host.nix and dashboard.nix have to agree on it.
{ config, lib }:
map (host: {
  inherit host;
  id = lib.replaceStrings [ "." "-" ] [ "_" "_" ] host;
}) (lib.attrNames config.services.caddy.virtualHosts)
