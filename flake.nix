{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs_legacy.url = "nixpkgs/nixos-24.05";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-alien.url = "github:thiagokokada/nix-alien";
    # ecsls.url = "github:Sigmapitech/ecsls";
    hyprqtile.url = "github:drawbu/hyprqtile";
    ghostty.url = "github:ghostty-org/ghostty/v1.0.0";
  };

  outputs =
    { ... }@inputs:
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
              legacy = import inputs.nixpkgs_legacy cfg;

              # Softwares
              # inherit (inputs.ecsls.packages.${cfg.system}) ecsls;
              inherit (inputs.nix-alien.packages.${cfg.system}) nix-alien;
              inherit (inputs.hyprqtile.packages.${cfg.system}) hyprqtile;
              nix-direnv = prev.nix-direnv.override { enableFlakes = true; };
              inherit (inputs.ghostty.packages.${cfg.system}) ghostty;
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
          args.graphical = true;
          override = cfg: {
            modules = cfg.modules ++ [
              ./hosts/pancake
              hardware.dell-xps-13-9315
            ];
          };
        });

        # Home server
        "waffle" = inputs.nixpkgs.lib.nixosSystem (defaultNixOS {
          args.graphical = false;
          override = cfg: { modules = cfg.modules ++ [ ./hosts/waffle ]; };
        });
      };
    };
}
