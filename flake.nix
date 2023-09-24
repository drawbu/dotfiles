{
  description = "Home Manager configuration of clement";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs
    , home-manager
    , nixpkgs_unstable
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
      hm = {
        extraSpecialArgs = { inherit unstable pkgs; };
      };
    in
    {
      formatter.${cfg.system} = pkgs.nixpkgs-fmt;

      homeConfigurations = {
        "linux" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/clement ];
        };
      };
      nixosConfigurations = {
        "pain-de-mie" = nixpkgs.lib.nixosSystem {
          system = cfg.system;
          modules = [
            ./pain-de-mie.nix
            home-manager.nixosModules.home-manager
            { home-manager = hm; }
          ];
        };
        "pancake" = nixpkgs.lib.nixosSystem {
          system = cfg.system;
          modules = [
            ./pancake.nix
            home-manager.nixosModules.home-manager
            { home-manager = hm; }
          ];
        };
        "croissant" = nixpkgs.lib.nixosSystem {
          system = cfg.system;
          modules = [
            ./croissant.nix
            home-manager.nixosModules.home-manager
            { home-manager = hm; }
          ];
        };
      };
    };
}
