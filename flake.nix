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

          modules = [ ./.config/nix/home-manager/home-linux.nix ];
        };
        "macos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";

          modules = [ ./.config/nix/home-manager/home-darwin.nix ];
        };
      };
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            # System
            ./.config/nix/nixos

            # Home
            home-manager.nixosModules.home-manager
            {
              home-manager.users.clement = import ./.config/nix/home-manager/home-linux.nix;
            }
          ];
        };
      };
    };
}
