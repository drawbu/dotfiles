# My config for NixOS on my laptop
# The name: pancake
{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../nixos
    ../../nixos/users/clement.nix
    ./gitlab.nix
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
  # hardware.ipu6 = {
  #   enable = true;
  #   platform = "ipu6ep";
  # };

  # Hardware acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt # Quick Sync Video
      intel-media-driver # Accelerated Video Playback
    ];
  };

  services.fwupd.enable = true;

  networking.firewall.allowedUDPPorts = [ 6969 ];
  networking.firewall.allowedTCPPorts = [ 6969 ];

  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  zramSwap.enable = true;
}
