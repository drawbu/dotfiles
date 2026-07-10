{
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  networking.hostName = "maine";
  system.stateVersion = "22.11";

  home-manager.users.clement =
    { ... }:
    {
      imports = [ ../../home/clement/linux.nix ];
      home.stateVersion = config.system.stateVersion;
    };

  hardware = {
    graphics.enable = true;
    nvidia = {
      nvidiaSettings = true;
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb.layout = lib.mkForce "us_qwerty-fr";
  };

  boot = {
    loader = {
      timeout = -1;
      grub.useOSProber = true;
    };
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  };

  zramSwap.enable = true;
}
