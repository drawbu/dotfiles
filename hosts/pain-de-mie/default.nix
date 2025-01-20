# My config for NixOS on my home PC
# The name: pain-de-mie
{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  networking.hostName = "pain-de-mie";
  system.stateVersion = "22.11";

  # Yeah I have Windows
  boot.loader.grub.useOSProber = true;

  # Git signing
  home-manager.users.clement.programs.git.signing = {
    key = "CFAE6BC61FF97205";
    signByDefault = true;
  };

  # nvidia, fuck you
  hardware = {
    graphics.enable = true;
    nvidia = {
      nvidiaSettings = true;
      open = false;
      modesetting.enable = true;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.lib.getExe pkgs.xorg.xrandr} --output DVI-D-0 --right-of HDMI-0
    ${pkgs.lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --primary
  '';
}
