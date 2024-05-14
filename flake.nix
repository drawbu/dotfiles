{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs_legacy.url = "nixpkgs/nixos-23.05";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-alien.url = "github:thiagokokada/nix-alien";
    ecsls.url = "github:Sigmapitech/ecsls";
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.4.1";

    hyprland.url = "github:hyprwm/Hyprland/v0.40.0";
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
          (_: _: {
            unstable = import inputs.nixpkgs_unstable cfg;
            legacy = import inputs.nixpkgs_legacy cfg;
            hyprpkgs = import inputs.hyprland.inputs.nixpkgs cfg;
          })
        ];
      }
    );

    specialArgs = {
      inherit pkgs;
      finputs = inputs;
      hyprland = inputs.hyprland.packages.${cfg.system};
      inherit (inputs.ecsls.packages.${cfg.system}) ecsls;
      inherit (inputs.nix-alien.packages.${cfg.system}) nix-alien;
    };

    hardware = inputs.nixos-hardware.nixosModules;

    defaultConfig = {
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

    homeConfigurations = {
      "clement" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home/clement];
      };
    };

    nixosConfigurations = {
      "pain-de-mie" = inputs.nixpkgs.lib.nixosSystem (
        defaultConfig
        // {
          modules =
            defaultConfig.modules
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
        defaultConfig
        // {
          modules =
            defaultConfig.modules
            ++ [
              ./pancake.nix
              hardware.common-gpu-intel
              hardware.common-cpu-intel
              hardware.common-pc-laptop
              hardware.common-pc-laptop-ssd
            ];
        }
      );
    };
  };
}
