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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    hyprland-plugins = {
      url = "github:hyprwm/Hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, ... } @ inputs:
    let
      cfg = {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
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
        hyprland = inputs.hyprland.packages.${cfg.system}.default;
        hyprland-plugins = inputs.hyprland-plugins.packages.${cfg.system};
      };
      hm = {
        extraSpecialArgs = extraArgs;
      };
      hardware = inputs.nixos-hardware.nixosModules;
    in
    {
      formatter.${cfg.system} = pkgs.nixpkgs-fmt;

      nixosConfigurations = {
        "pain-de-mie" = inputs.nixpkgs.lib.nixosSystem {
          system = cfg.system;
          specialArgs = extraArgs;
          modules = [
            ./pain-de-mie.nix
            inputs.home-manager.nixosModules.home-manager
            { home-manager = hm; }
            # nixos-hardware.nixosModules.common-gpu-nvidia
            hardware.common-cpu-intel
            hardware.common-pc
            hardware.common-pc-ssd
            hardware.common-pc-hdd
          ];
        };
        "pancake" = inputs.nixpkgs.lib.nixosSystem {
          system = cfg.system;
          specialArgs = extraArgs;
          modules = [
            ./pancake.nix
            inputs.home-manager.nixosModules.home-manager
            { home-manager = hm; }
            hardware.common-gpu-intel
            hardware.common-cpu-intel
            hardware.common-pc-laptop
            hardware.common-pc-laptop-ssd
          ];
        };
      };
    };
}
