{ pkgs, fetchFromGitHub, ... }:
let
  grub_catppuccin = fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
    hash = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
  };
in
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080x32";
        useOSProber = true;
        theme = "${grub_catppuccin}/src/catppuccin-mocha-grub-theme";
      };
    };

    plymouth = {
      enable = true;
      themePackages = with pkgs; [
        nixos-bgrt-plymouth
      ];
      theme = "nixos-bgrt";
    };
  };
}
