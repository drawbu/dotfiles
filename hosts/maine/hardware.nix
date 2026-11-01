{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems =
    let
      btrfs = subvol: {
        device = "/dev/disk/by-label/maine";
        fsType = "btrfs";
        options = [
          "subvol=${subvol}"
          "compress=zstd:1"
          "noatime"
        ];
      };
    in
    {
      "/" = btrfs "@";
      "/home" = btrfs "@home";
      "/nix" = btrfs "@nix";
      "/swap" = btrfs "@swap";

      "/boot" = {
        device = "/dev/disk/by-uuid/12D4-C4CC";
        fsType = "vfat";
      };
    };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024;
    }
  ];

  # powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
