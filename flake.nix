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

    hyprland.url = "github:hyprwm/Hyprland/v0.36.0";
    hyprland-plugins = {
      url = "github:hyprwm/Hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, ... } @ inputs:
    let
      cfg = {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      pkgs = import inputs.nixpkgs (cfg // {
        overlays = [
          (_: _: { unstable = import inputs.nixpkgs_unstable cfg; })
          (_: _: { legacy = import inputs.nixpkgs_legacy cfg; })
        ];
      });

      extraArgs = {
        inherit pkgs;
        ecsls = inputs.ecsls.packages.${cfg.system}.default;
        hyprland = inputs.hyprland.packages.${cfg.system};
        hyprland-plugins = inputs.hyprland-plugins.packages.${cfg.system};
        nix-alien = inputs.nix-alien.packages.${cfg.system}.nix-alien;
      };

      hardware = inputs.nixos-hardware.nixosModules;

      defaultConfig = {
        system = cfg.system;
        specialArgs = extraArgs;
        modules = [
          inputs.home-manager.nixosModules.home-manager
          { home-manager.extraSpecialArgs = extraArgs; }
        ];
      };
    in
    {
      formatter.${cfg.system} = pkgs.nixpkgs-fmt;

      homeConfigurations = {
        "clement" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/clement ];
        };
      };


      nixosConfigurations = {
        "pain-de-mie" = inputs.nixpkgs.lib.nixosSystem (defaultConfig // {
          modules = defaultConfig.modules ++ [
            ./pain-de-mie.nix
            # hardware.common-gpu-nvidia
            hardware.common-cpu-intel
            hardware.common-pc
            hardware.common-pc-ssd
            hardware.common-pc-hdd
          ];
        });
        "pancake" = inputs.nixpkgs.lib.nixosSystem (defaultConfig // {
          modules = defaultConfig.modules ++ [
            ./pancake.nix
            hardware.common-gpu-intel
            hardware.common-cpu-intel
            hardware.common-pc-laptop
            hardware.common-pc-laptop-ssd
          ];
        });
      };
    };
}
