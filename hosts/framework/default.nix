{ lib, ... }:
{
  imports = [
    ./hardware.nix
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  networking.hostName = "framework";
  system.stateVersion = "24.11";

  home-manager.users.clement = {
    wayland.windowManager.hyprland.settings = {
      monitor = lib.mkForce ",highres,auto-up,1.5";
      xwayland.force_zero_scaling = true;
    };

    home = {
      pointerCursor.size = lib.mkForce 24;
      sessionVariables = {
        GDK_SCALE = 1.5;
        # XCURSOR_SIZE = lib.mkForce 24;
      };
    };
  };



  boot.loader.grub.useOSProber = true;

  zramSwap.enable = true;

  services.fwupd.enable = true;
}
