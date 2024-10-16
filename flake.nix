{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs_legacy.url = "nixpkgs/nixos-23.11";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";

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
        args:
        let
          completeArgs = specialArgs // args;
        in
        {
          inherit (cfg) system;
          specialArgs = completeArgs;
          modules = [
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = completeArgs; }
          ];
        };
    in
    {
      formatter.${cfg.system} = pkgs.alejandra;

      homeConfigurations = {
        "home-generic" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [ ./home/clement ];
        };
      };

      nixosConfigurations = {
        "pain-de-mie" = inputs.nixpkgs.lib.nixosSystem (
          let
            def = defaultNixOS { graphical = true; };
          in
          def
          // {
            modules = def.modules ++ [
              ./pain-de-mie.nix
              # hardware.common-gpu-nvidia
              hardware.common-cpu-intel
              hardware.common-pc
              hardware.common-pc-ssd
            ];
          }
        );
        "pancake" = inputs.nixpkgs.lib.nixosSystem (
          let
            def = defaultNixOS { graphical = true; };
          in
          def
          // {
            modules = def.modules ++ [
              ./pancake.nix
              hardware.common-cpu-intel
              hardware.common-pc-laptop
              hardware.common-pc-laptop-ssd
            ];
          }
        );
      };
    };
}
