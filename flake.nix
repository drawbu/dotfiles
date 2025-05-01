{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs_legacy.url = "nixpkgs/nixos-24.11";
    nixpkgs_legacy'.url = "nixpkgs/nixos-24.05";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-alien.url = "github:thiagokokada/nix-alien";
    # ecsls.url = "github:Sigmapitech/ecsls";
    hyprqtile.url = "github:drawbu/hyprqtile";
  };

  outputs =
    { self, ... }@inputs:
    let
      nixpkgsFor =
        system:
        import inputs.nixpkgs (
          let
            cfg = {
              inherit system;
              config.allowUnfree = true;
              config.android_sdk.accept_license = true;
            };
          in
          cfg
          // {
            overlays = [
              (final: prev: {
                unstable = import inputs.nixpkgs_unstable cfg;
                legacy = import inputs.nixpkgs_legacy cfg;
                legacy' = import inputs.nixpkgs_legacy' cfg;

                # inherit (inputs.ecsls.packages.${system}) ecsls;
                inherit (inputs.nix-alien.packages.${system}) nix-alien;
                inherit (inputs.hyprqtile.packages.${system}) hyprqtile;
                nix-direnv = prev.nix-direnv.override { enableFlakes = true; };
              })
            ];
          }
        );

      hardware = inputs.nixos-hardware.nixosModules;

      specialArgs' = config: {
        pkgs = nixpkgsFor config;
        finputs = inputs;
        graphical = false;
      };

      defaultNixOS =
        {
          system,
          args ? { },
          override ? (_: { }),
        }:
        let
          systemCfg = rec {
            inherit system;
            specialArgs = (specialArgs' system) // args;
            modules = [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  extraSpecialArgs = specialArgs;
                  backupFileExtension = "backup";
                  verbose = true;
                };
              }
            ];
          };
        in
        systemCfg // (override systemCfg);
    in
    {
      formatter = inputs.nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ] (system: nixpkgsFor system).nixfmt-rfc-style;

      hydraJobs = {
        nixos = inputs.nixpkgs.lib.mapAttrs (
          name: config: config.config.system.build.toplevel
        ) self.nixosConfigurations;
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
          system = "aarch64-darwin";
          specialArgs = specialArgs' system;
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
          system = "x86_64-linux";
          args.graphical = true;
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
          system = "x86_64-linux";
          args.graphical = true;
          override = cfg: {
            modules = cfg.modules ++ [
              ./hosts/pancake
              hardware.dell-xps-13-9315
            ];
          };
        });
        "framework" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          system = "x86_64-linux";
          args.graphical = true;
          override = cfg: {
            modules = cfg.modules ++ [
              ./hosts/framework
              hardware.framework-amd-ai-300-series
            ];
          };
        });

        # Home server
        "waffle" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          system = "x86_64-linux";
          args.graphical = false;
          override = cfg: { modules = cfg.modules ++ [ ./hosts/waffle ]; };
        });

        # Headscale server
        "pineapple" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          system = "x86_64-linux";
          args.graphical = false;
          override = cfg: { modules = cfg.modules ++ [ ./hosts/pineapple ]; };
        });
      };
    };
}
