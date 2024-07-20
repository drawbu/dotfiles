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
    ida.url = "github:bbjubjub2494/nixpkgs/idafree";
    ecsls.url = "github:Sigmapitech/ecsls";
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.4.1";
    hyprqtile.url = "github:drawbu/hyprqtile";
  };

  outputs = {self, ...} @ inputs: let
    cfg = {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };

    pkgs = import inputs.nixpkgs (
      cfg
      // {
        overlays = [
          (_: super: {
            # Other nixpkgs
            unstable = import inputs.nixpkgs_unstable cfg;
            legacy = import inputs.nixpkgs_legacy cfg;

            # Softwares
            ida = (import inputs.ida cfg).ida-free;
            inherit (inputs.ecsls.packages.${cfg.system}) ecsls;
            inherit (inputs.nix-alien.packages.${cfg.system}) nix-alien;
            inherit (inputs.hyprqtile.packages.${cfg.system}) hyprqtile;
            nix-direnv = super.nix-direnv.override {enableFlakes = true;};
          })
        ];
      }
    );

    hardware = inputs.nixos-hardware.nixosModules;

    defaultConfig = args: let
      specialArgs =
        {
          inherit pkgs;
          finputs = inputs;
          graphical = pkgs.lib.mkDefault false;
        }
        // args;
    in {
      inherit (cfg) system;
      inherit specialArgs;
      modules = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
        inputs.home-manager.nixosModules.home-manager
        {home-manager.extraSpecialArgs = specialArgs;}
      ];
    };
  in {
    formatter.${cfg.system} = pkgs.alejandra;

    nixosConfigurations = {
      "pain-de-mie" = inputs.nixpkgs.lib.nixosSystem (
        let
          def = defaultConfig {graphical = true;};
        in
          def
          // {
            modules =
              def.modules
              ++ [
                ./pain-de-mie.nix
                # hardware.common-gpu-nvidia
                hardware.common-cpu-intel
                hardware.common-pc
                hardware.common-pc-ssd
                hardware.common-pc-hdd
              ];
          }
      );
      "pancake" = inputs.nixpkgs.lib.nixosSystem (
        let
          def = defaultConfig {graphical = true;};
        in
          def
          // {
            modules =
              def.modules
              ++ [
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
