{ finputs, config, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [ "ventoy-1.1.05" ];
    };
    overlays = [
      (
        final: _:
        let
          cfg = {
            inherit (config.nixpkgs) config;
            inherit (final) system;
          };
        in
        {
          unstable = import finputs.nixpkgs_unstable cfg;
          legacy = import finputs.nixpkgs_legacy cfg;
          legacy' = import finputs.nixpkgs_legacy' cfg;
        }
      )

      finputs.hyprqtile.overlays.default
      (final: prev: {
        nix-direnv = prev.nix-direnv.override { enableFlakes = true; };

        extra = {
          inherit (finputs.nix-alien.packages.${final.system}) nix-alien;
          inherit (finputs.ghostty.packages.${final.system}) ghostty;
          jj = finputs.jj.packages.${final.system}.jujutsu;
        };
      })
    ];
  };
}
