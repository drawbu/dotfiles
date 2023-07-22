{
  description = "Home Manager configuration of clement";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs_unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixpkgs_unstable, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
      unstable = import nixpkgs_unstable {inherit system;};
    in {
      homeConfigurations = {
        "linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";

          modules = [ ./home/clement ];
        };
      };
      nixosConfigurations = {
        "pain-de-mie" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";


          modules = [
            ./pain-de-mie.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit unstable; };
            }
          ];
        };
        "pancake" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./pancake.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
