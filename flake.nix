{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs_legacy.url = "nixpkgs/nixos-24.11";
    nixpkgs_legacy'.url = "nixpkgs/nixos-24.05";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-alien.url = "github:thiagokokada/nix-alien";
    hyprqtile.url = "github:drawbu/hyprqtile";
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
            modules =
              [
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
        macos = inputs.nix-darwin.lib.darwinSystem rec {
          specialArgs = specialArgs';
          modules = [
            ./hosts/macos
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.verbose = true;
            }
          ];
        };
      };

      nixosConfigurations = {
        # Home PC
        "pain-de-mie" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args = {
            graphical = true;
            home-manager = true;
          };
          override = cfg: {
            modules = cfg.modules ++ [
              ./hosts/pain-de-mie
              # hardware.common-gpu-nvidia
              hardware.common-cpu-intel
              hardware.common-pc
              hardware.common-pc-ssd
            ];
          };
        });

        # Laptop
        "pancake" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args = {
            graphical = true;
            home-manager = true;
          };
          override = cfg: {
            modules = cfg.modules ++ [
              ./hosts/pancake
              hardware.dell-xps-13-9315
            ];
          };
        });
        "framework" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args = {
            graphical = true;
            home-manager = true;
          };
          override = cfg: {
            modules = cfg.modules ++ [
              ./hosts/framework
              hardware.framework-amd-ai-300-series
            ];
          };
        });

        # Home server
        "waffle" = inputs.nixpkgs_legacy.lib.nixosSystem (defaultNixOS {
          override = cfg: { modules = cfg.modules ++ [ ./hosts/waffle ]; };
        });

        # Headscale server
        "pineapple" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          override = cfg: { modules = cfg.modules ++ [ ./hosts/pineapple ]; };
        });
      };
    };
}
