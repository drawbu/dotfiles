{ modulesPath, ... }:
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
  boot.kernelModules = [ "kvm-intel" ];

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

  nixpkgs.hostPlatform = "x86_64-linux";
}
