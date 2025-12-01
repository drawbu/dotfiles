{
  finputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (finputs) self;
in
{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
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
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
  system.systemBuilderCommands = "ln -s ${self.sourceInfo.outPath} $out/src";
  # Add git version to nixos label
  system.nixos.label = lib.concatStringsSep "-" (
    (lib.sort (x: y: x < y) config.system.nixos.tags)
    ++ [ "${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}" ]
  );
}
