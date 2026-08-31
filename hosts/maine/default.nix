{ config, lib, ... }:
{
  imports = [
    ../../nixos
    ../../nixos/users/clement.nix
    ./hardware.nix
  ];

  networking.hostName = "maine";
  system.stateVersion = "22.11";

  home-manager.users.clement = {
    imports = [ ../../home/clement/linux.nix ];
    home.stateVersion = config.system.stateVersion;
  };

  hardware.nvidia = {
    open = true;
    powerManagement.enable = true;
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb.layout = lib.mkForce "us_qwerty-fr";
  };

  programs.gamescope.args = [
    "-W"
    "1920"
    "-H"
    "1080"
  ];

  boot.loader = {
    timeout = -1;
    grub.useOSProber = true;
  };

  zramSwap.enable = true;
}
