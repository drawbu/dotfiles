# My config for NixOS on my PC
# The name: pancake
{ pkgs, ... }:
{
  imports = [
    ./nixos/hardware/hardware-pancake.nix
    ./nixos
  ];

  users.users.clement = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "docker" "networkmanager" "libvirtd" "wheel" ];
  };

  home-manager.users.clement = import ./home/clement;

  networking = {
    hostName = "pancake";
    networkmanager.enable = true;
  };

  services = {
    printing.enable = true;
    thermald.enable = true;
    upower.enable = true;

    xserver = {
      videoDrivers = [ "intel" ];
      libinput.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  boot = {
    kernelModules = [ "kvm-intel" "i915" ];
    kernelParams = [
      "i915.force_probe=46aa"
      "i915.enable_psr=0"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = { # Hardware acceleration
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
