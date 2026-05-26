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

  hardware = {
    graphics.enable = true;
    nvidia = {
      nvidiaSettings = true;
      open = false;
      modesetting.enable = true;
    };
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb.layout = lib.mkForce "us_qwerty-fr";
    displayManager.setupCommands = ''
      ${lib.getExe pkgs.xorg.xrandr} --output DVI-D-0 --right-of HDMI-0
      ${lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --primary
    '';
  };

  boot.loader.grub = {
    useOSProber = true;
    timeout = -1;
  };

  zramSwap.enable = true;
}
