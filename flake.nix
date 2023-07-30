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

  outputs = { nixpkgs, home-manager, nixpkgs_unstable, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs_unstable { inherit system; };
      hm = {
        extraSpecialArgs = { inherit unstable; };
      };
    in {
      homeConfigurations = {
        "linux" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/clement ];
        };
      };
      nixosConfigurations = {
        "pain-de-mie" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./pain-de-mie.nix
            home-manager.nixosModules.home-manager { home-manager = hm; }
          ];
        };
        "pancake" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./pancake.nix
            home-manager.nixosModules.home-manager { home-manager = hm; }
          ];
        };
      };
    };
}
