{ pkgs, ... }:
let
  minegrub = pkgs.fetchFromGitHub {
    owner = "Lxtharia";
    repo = "minegrub-theme";
    rev = "v2.0.0";
    hash = "sha256-HZnVr9NtierP22pMy8C/BeZJDpBkKixROG0JaCAq5Y8=";
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
        theme = "${minegrub}/minegrub";
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
