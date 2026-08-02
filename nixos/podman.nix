{ config, lib, ... }:
let
  cfg = config.mod.podman;
  containers = lib.attrValues config.virtualisation.oci-containers.containers;

  requested = lib.unique (lib.concatMap (c: c.networks) containers);
  undeclared = lib.subtractLists cfg.networks requested;

  mkNetwork =
    net:
    let
      consumers = map (c: "${c.serviceName}.service") (
        lib.filter (c: lib.elem net c.networks) containers
      );
    in
    lib.nameValuePair "podman-network-${net}" {
      wantedBy = [ "multi-user.target" ];
      before = consumers;
      requiredBy = consumers;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [ config.virtualisation.podman.package ];
      script = "podman network exists ${net} || podman network create ${net}";
    };
in
{
  options.mod.podman.networks = lib.mkOption {
    type = with lib.types; listOf str;
    default = [ ];
    example = [ "media" ];
    description = ''
      Podman networks to create. oci-containers attaches containers to a
      network but never creates one, so each name here gets a oneshot unit
      that the containers using it are ordered after.
    '';
  };

  config = {
    assertions = [
      {
        assertion = undeclared == [ ];
        message = "mod.podman.networks is missing ${lib.concatStringsSep ", " undeclared}";
      }
    ];

    systemd.services = lib.listToAttrs (map mkNetwork cfg.networks);
  };
}
