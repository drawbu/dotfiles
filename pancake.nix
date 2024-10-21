# My config for NixOS on my laptop
# The name: pancake
{ pkgs, ... }:
{
  imports = [
    ./nixos/hardware/hardware-pancake.nix
    ./nixos
    ./nixos/users/clement.nix
  ];

  networking.hostName = "pancake";
  system.stateVersion = "23.05";

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Git signing
  home-manager.users.clement.programs.git = {
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    extraConfig.gpg.format = "ssh";
  };

  services = {
    thermald.enable = true; # thermal daemon
    power-profiles-daemon.enable = false; # disable power thing from Gnome
    fprintd.enable = true;

    # idk intel hardware is borken
    xserver.videoDrivers = [ "modesettings" ];

    # Allows for updating firmware via `fwupdmgr`.
    fwupd.enable = true;
  };

  hardware.enableAllFirmware = true;
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  # Hardware acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  networking.firewall.allowedUDPPorts = [ 6969 ];
  networking.firewall.allowedTCPPorts = [ 6969 ];

  services.tlp.settings = {
    PCIE_ASPM_ON_AC = "performance";
    PCIE_ASPM_ON_BAT = "default";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  zramSwap.enable = true;
}
