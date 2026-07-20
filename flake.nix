{
  inputs = {
    systems.url = "github:nix-systems/default";

    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs_legacy.url = "nixpkgs/nixos-25.11";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs_master.url = "nixpkgs/master";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";

    hyprqtile.url = "github:drawbu/hyprqtile";
    hyprqtile.inputs.nixpkgs.follows = "nixpkgs";

    jj.url = "github:jj-vcs/jj/v0.43.0";
    jj.inputs.nixpkgs.follows = "nixpkgs";
    jj.inputs.flake-utils.inputs.systems.follows = "systems";
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.nixpkgs) lib;

      hardware = inputs.nixos-hardware.nixosModules;

      specialArgs' = {
        finputs = inputs;
      };

      mkHome = extraSpecialArgs: {
        home-manager = {
          inherit extraSpecialArgs;
          backupFileExtension = "backup";
          verbose = true;
        };
      };

      mkHost =
        {
          modules ? [ ],
          desktop ? false,
        }:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = specialArgs';
          modules = [
            ./nixos/nixpkgs.nix
            ./nixos/profiles.nix
            inputs.home-manager.nixosModules.home-manager
            (mkHome specialArgs')
            { mod.profiles.desktop.enable = desktop; }
          ]
          ++ modules;
        };

      eachSystem = lib.genAttrs (import inputs.systems);
      nixpkgs' = fn: eachSystem (system: fn (import inputs.nixpkgs { inherit system; }));
    in
    {
      formatter = nixpkgs' (pkgs: pkgs.nixfmt-tree);

      hydraJobs = {
        nixos = lib.mapAttrs (name: config: config.config.system.build.toplevel) self.nixosConfigurations;
      };

      darwinConfigurations = {
        kiwi = inputs.nix-darwin.lib.darwinSystem rec {
          specialArgs = specialArgs';
          modules = [
            ./hosts/kiwi
            inputs.home-manager.darwinModules.home-manager
            (mkHome specialArgs)
          ];
        };
      };

      nixosConfigurations = {
        "maine" = mkHost {
          desktop = true;
          modules = [
            ./hosts/maine
            # hardware.common-gpu-nvidia
            hardware.common-cpu-intel
            hardware.common-pc
            hardware.common-pc-ssd
          ];
        };

        "lucy" = mkHost {
          desktop = true;
          modules = [
            ./hosts/lucy
            hardware.framework-amd-ai-300-series
          ];
        };

        "rebecca" = mkHost {
          modules = [
            ./hosts/rebecca
            hardware.common-cpu-intel
            hardware.common-pc
            hardware.common-pc-ssd
          ];
        };
      };
    };
}
