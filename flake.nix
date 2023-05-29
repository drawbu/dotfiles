{
  description = "Home Manager configuration of clement";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
    in {
      homeConfigurations = {
        "clement-linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";

          modules = [ ./.config/home-manager/home-linux.nix ];
        };
        "clement-darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";

          modules = [ ./.config/home-manager/home-darwin.nix ];
        };
      };
    };
}
