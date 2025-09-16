{
  finputs,
  config,
  lib,
  ...
}:
let
  inherit (finputs) self;
in
{
  nix = {
    gc.automatic = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      trusted-substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
      ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    optimise.automatic = true;

    # TODO
    # channel.enable = false;

    nixPath = [
      "nixpkgs=${finputs.nixpkgs}"
      "legacy=${finputs.nixpkgs_legacy}"
      "unstable=${finputs.nixpkgs_unstable}"
    ];
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d";
    };
  };

  # Add src/ to $out
  system.extraSystemBuilderCmds = "ln -s ${self.sourceInfo.outPath} $out/src";
  # Add git version to nixos label
  system.nixos.label = lib.concatStringsSep "-" (
    (lib.sort (x: y: x < y) config.system.nixos.tags)
    ++ [ "${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}" ]
  );
}
