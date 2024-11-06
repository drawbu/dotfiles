{ finputs, ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
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
}
