{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs_legacy.url = "nixpkgs/nixos-23.11";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs_unstable_small.url = "nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-alien.url = "github:thiagokokada/nix-alien";
    # ecsls.url = "github:Sigmapitech/ecsls";
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.4.1";
    hyprqtile.url = "github:drawbu/hyprqtile";
  };

  outputs =
    { self, ... }@inputs:
    let
      cfg = {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      pkgs = import inputs.nixpkgs (
        cfg
        // {
          overlays = [
            (final: prev: {
              # Other nixpkgs
              unstable = import inputs.nixpkgs_unstable cfg;
              unstable_small = import inputs.nixpkgs_unstable_small cfg;
              legacy = import inputs.nixpkgs_legacy cfg;

              # Softwares
              # inherit (inputs.ecsls.packages.${cfg.system}) ecsls;
              inherit (inputs.nix-alien.packages.${cfg.system}) nix-alien;
              inherit (inputs.hyprqtile.packages.${cfg.system}) hyprqtile;
              nix-direnv = prev.nix-direnv.override { enableFlakes = true; };
            })
          ];
        }
      );

      hardware = inputs.nixos-hardware.nixosModules;

      specialArgs = {
        inherit pkgs;
        finputs = inputs;
        graphical = false;
      };

      defaultNixOS =
        {
          args ? { },
          override ? (_: { }),
        }:
        let
          completeArgs = specialArgs // args;
          system = {
            inherit (cfg) system;
            specialArgs = completeArgs;
            modules = [
              inputs.nix-flatpak.nixosModules.nix-flatpak
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  extraSpecialArgs = completeArgs;
                  backupFileExtension = "backup";
                };
              }
            ];
          };
        in
        system // (override system);
    in
    {
      formatter.${cfg.system} = pkgs.nixfmt-rfc-style;

      homeConfigurations = {
        "home-generic" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          backupFileExtension = "backup";
          modules = [ ./home/clement ];
        };
      };

      nixosConfigurations = {
        # Home PC
        "pain-de-mie" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args.graphical = true;
          override = cfg: {
            modules = cfg.modules ++ [
              ./pain-de-mie.nix
              # hardware.common-gpu-nvidia
              hardware.common-cpu-intel
              hardware.common-pc
              hardware.common-pc-ssd
            ];
          };
        });

        # Laptop
        "pancake" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args.graphical = true;
          override = cfg: {
            modules = cfg.modules ++ [
              ./pancake.nix
              hardware.dell-xps-13-9315
            ];
          };
        });

        # Home server
        "waffle" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args.graphical = false;
          override = cfg: { modules = cfg.modules ++ [ ./waffle.nix ]; };
        });
      };
    };
}
