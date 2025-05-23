# My config for NixOS on my home PC
# The name: pain-de-mie
{ config, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  networking.hostName = "pain-de-mie";

  system.stateVersion = "22.11";
  home-manager.users.clement.home.stateVersion = config.system.stateVersion;

  # Yeah I have Windows
  boot.loader.grub.useOSProber = true;

  # nvidia, fuck you
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
    ${pkgs.lib.getExe pkgs.xorg.xrandr} --output DVI-D-0 --right-of HDMI-0
    ${pkgs.lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --primary
  '';
}
