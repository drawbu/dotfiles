{
  description = "Home Manager configuration of clement";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
    in {
      homeConfigurations = {
        "linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";

          modules = [ ./.config/nix/home-manager/clement.nix ];
        };
      };
      nixosConfigurations = {
        "pain-de-mie" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            # System
            ./.config/nix/pain-de-mie.nix

            # Home
            home-manager.nixosModules.home-manager
            {
              home-manager.users.clement = import ./.config/nix/home-manager/clement.nix;
            }
          ];
        };
      };
    };
}
