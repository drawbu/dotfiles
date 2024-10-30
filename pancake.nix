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
    power-profiles-daemon.enable = false; # disable power thing from Gnome
    xserver.videoDrivers = [ "modesettings" ];
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
    extraPackages = with pkgs; [
      onevpl-intel-gpu # unstable -> vpl-gpu-rt # Quick Sync Video
      intel-media-driver # Accelerated Video Playback
    ];
  };

  services.fwupd.enable = true;

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
