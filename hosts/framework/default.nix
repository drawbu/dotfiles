{ lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  networking.hostName = "framework";
  system.stateVersion = "24.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager.users.clement =
    { pkgs, ... }:
    {
      imports = [ ../../home/clement/linux.nix ];
      wayland.windowManager.hyprland.settings = {
        monitor = lib.mkForce [
          "eDP-1, highres, 0x0,     1.5, cm, hdr"
          "      ,highres, auto-up, 1"
        ];
        xwayland.force_zero_scaling = true;
      };

      home = {
        stateVersion = "24.11";
        # pointerCursor.size = lib.mkForce 16;
        packages = with pkgs; [ framework-tool ];
        sessionVariables = {
          GDK_SCALE = 1; # GDK 3 does not support fractional scaling; really should be 1.5
          QT_AUTO_SCREEN_SCALE_FACTOR = 1;
          QT_ENABLE_HIGHDPI_SCALING = 1;
        };
      };
    };
  programs.nh.clean.enable = lib.mkForce false;

  hardware.framework.laptop13.audioEnhancement.enable = true;

  boot.loader.grub.useOSProber = true;

  zramSwap.enable = true;

  services.fwupd.enable = true;

  networking.nameservers = [ "1.1.1.1" ];

  systemd.oomd = {
    enable = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "10s";
    };
  };

  services.tailscale.package = pkgs.unstable.tailscale;
}
