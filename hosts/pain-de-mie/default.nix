{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  networking.hostName = "pain-de-mie";

  system.stateVersion = "22.11";
  home-manager.users.clement =
    { ... }:
    {
      imports = [ ../../home/clement/linux.nix ];
      home.stateVersion = config.system.stateVersion;
    };

  boot.loader.grub.useOSProber = true;

  hardware = {
    graphics.enable = true;
    nvidia = {
      nvidiaSettings = true;
      open = false;
      modesetting.enable = true;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.setupCommands = ''
    ${lib.getExe pkgs.xorg.xrandr} --output DVI-D-0 --right-of HDMI-0
    ${lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --primary
  '';
}
