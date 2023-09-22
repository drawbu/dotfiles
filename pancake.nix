# My config for NixOS on my laptop
# The name: pancake
{ pkgs, ... }:
{
  imports = [
    ./nixos/hardware/hardware-pancake.nix
    ./nixos
    ./nixos/graphical
  ];

  networking.hostName = "pancake";

  services = {
    thermald.enable = true;
    upower.enable = true;

    xserver.videoDrivers = [ "modesetting" ];
  };

  boot = {
    kernelModules = [ "kvm-intel" "i915" ];
    kernelParams = [
      "i915.force_probe=46aa"
      "i915.enable_psr=1"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      # Hardware acceleration
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
        intel-ocl
      ];
    };
  };
}
