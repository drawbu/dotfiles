{
  inputs = {
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
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.nixpkgs) lib;

      hardware = inputs.nixos-hardware.nixosModules;

      specialArgs' = {
        finputs = inputs;
        graphical = false;
        home-manager = false;
      };

      defaultNixOS =
        {
          args ? { },
          override ? (_: { }),
        }:
        let
          systemCfg = rec {
            specialArgs = specialArgs' // args;
            modules = [
              ./nixos/overlay.nix
            ]
            ++ (lib.optionals specialArgs.home-manager [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  extraSpecialArgs = specialArgs;
                  backupFileExtension = "backup";
                  verbose = true;
                };
              }
            ]);
          };
        in
        systemCfg // (override systemCfg);

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = lib.genAttrs systems;
      nixpkgsFor = system: import inputs.nixpkgs { inherit system; };
      nixpkgsAll = fn: forAllSystems (system: fn (nixpkgsFor system));
    in
    {
      formatter = nixpkgsAll (pkgs: pkgs.nixfmt-tree);

      hydraJobs = {
        nixos = lib.mapAttrs (name: config: config.config.system.build.toplevel) self.nixosConfigurations;
      };

      homeConfigurations = {
        "home-generic" = inputs.home-manager.lib.homeManagerConfiguration rec {
          extraSpecialArgs = specialArgs' "x86_64-linux";
          inherit (extraSpecialArgs) pkgs;
          backupFileExtension = "backup";
          modules = [ ./home/clement ];
        };
      };

      darwinConfigurations = {
        kiwi = inputs.nix-darwin.lib.darwinSystem rec {
          specialArgs = specialArgs';
          modules = [
            ./hosts/kiwi
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              # home-manager.useGlobalPkgs = true;
              # home-manager.useUserPackages = true;
              home-manager.verbose = true;
            }
          ];
        };
      };

      nixosConfigurations = {
        # Home PC
        "maine" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args = {
            graphical = true;
            home-manager = true;
          };
          override = cfg: {
            modules = cfg.modules ++ [
              ./hosts/maine
              # hardware.common-gpu-nvidia
              hardware.common-cpu-intel
              hardware.common-pc
              hardware.common-pc-ssd
            ];
          };
        });

        # Laptop
        "lucy" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args = {
            graphical = true;
            home-manager = true;
          };
          override = cfg: {
            modules = cfg.modules ++ [
              ./hosts/lucy
              hardware.framework-amd-ai-300-series
            ];
          };
        });

        # Home server
        "rebecca" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          override = cfg: { modules = cfg.modules ++ [ ./hosts/rebecca ]; };
        });
      };
    };
}
