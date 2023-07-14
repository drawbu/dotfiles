{
  description = "Home Manager configuration of gabriel";

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

          modules = [ ./.config/home-manager/home-linux.nix ];
        };
      };
      nixosConfigurations = {
        "NixAtchu-Fix" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            # System
            ./.config/nixos
            ./.config/nixos/hardware-configuration-fix.nix

            # Home
            home-manager.nixosModules.home-manager
            {
              home-manager.users.gabriel = import ./.config/home-manager/home-linux.nix;
            }
          ];
        };

        "NixAtchu-Portable" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            # System
            ./.config/nixos
            ./.config/nixos/hardware-configuration-portable.nix

            # Home
            home-manager.nixosModules.home-manager
            {
              home-manager.users.gabriel = import ./.config/home-manager/home-linux.nix;
            }
          ];
        };
      };
    };
}
