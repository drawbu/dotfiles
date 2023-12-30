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

    ecsls.url = "github:Sigmapitech/ecsls";
  };

  outputs =
    { nixpkgs
    , nixpkgs_unstable
    , nixpkgs_legacy
    , home-manager
    , nixos-hardware
    , ecsls
    , ...
    }:
    let
      cfg = {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };
      pkgs = import nixpkgs cfg;
      unstable = import nixpkgs_unstable cfg;
      pkgs_legacy = import nixpkgs_legacy cfg;
      extraArgs = {
        inherit pkgs unstable pkgs_legacy;
        ecsls = ecsls.packages.${cfg.system}.default;
      };
      hm = {
        extraSpecialArgs = extraArgs;
      };
    in
    {
      formatter.${cfg.system} = pkgs.nixpkgs-fmt;

      nixosConfigurations = {
        "pain-de-mie" = nixpkgs.lib.nixosSystem {
          system = cfg.system;
          specialArgs = extraArgs;
          modules = [
            ./pain-de-mie.nix
            home-manager.nixosModules.home-manager
            { home-manager = hm; }
            # nixos-hardware.nixosModules.common-gpu-nvidia
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-pc-hdd
          ];
        };
        "pancake" = nixpkgs.lib.nixosSystem {
          system = cfg.system;
          specialArgs = extraArgs;
          modules = [
            ./pancake.nix
            home-manager.nixosModules.home-manager
            { home-manager = hm; }
            nixos-hardware.nixosModules.common-gpu-intel
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc-laptop
            nixos-hardware.nixosModules.common-pc-laptop-ssd
          ];
        };
      };
    };
}
