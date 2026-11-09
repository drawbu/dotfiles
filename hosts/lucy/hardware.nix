{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usbhid"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  boot.initrd.luks.devices."luks-3314f31f-5753-4e88-af5e-c4299470260f".device =
    "/dev/disk/by-uuid/3314f31f-5753-4e88-af5e-c4299470260f";

  fileSystems =
    let
      btrfs = subvol: {
        device = "/dev/disk/by-label/lucy";
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
        device = "/dev/disk/by-uuid/B7A8-EFC4";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 48 * 1024;
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
