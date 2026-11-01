{ config, finputs, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [
        "ventoy-1.1.12"
      ];
    };
    overlays = [
      (
        final: _:
        let
          cfg = {
            inherit (config.nixpkgs) config;
            inherit (final.stdenv.hostPlatform) system;
          };
        in
        {
          unstable = import finputs.nixpkgs_unstable cfg;
          legacy = import finputs.nixpkgs_legacy cfg;
          master = import finputs.nixpkgs_master cfg;

          llm = finputs.llm-agents.packages.${cfg.system};
        }
      )

      finputs.hyprqtile.overlays.default
      (final: prev: {
        extra = {
          inherit (finputs.nix-alien.packages.${final.stdenv.hostPlatform.system}) nix-alien;
          jj = finputs.jj.packages.${final.stdenv.hostPlatform.system}.jujutsu;
          depsrc = finputs.depsrc.packages.${final.stdenv.hostPlatform.system}.default;
        };
      })
    ];
  };
}
