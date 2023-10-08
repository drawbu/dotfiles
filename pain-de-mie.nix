# My config for NixOS on my home PC
# The name: pain-de-mie
{ pkgs, ... }:
{
  imports = [
    ./nixos/hardware/hardware-pain-de-mie.nix
    ./nixos
    ./nixos/graphical
    ./nixos/users/clement.nix
  ];

  networking.hostName = "pain-de-mie";

  # Git signing
  home-manager.users.clement.programs.git.signing = {
    key = "CFAE6BC61FF97205";
    signByDefault = true;
  };

  # nvidia, fuck you
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --right-of HDMI-0
    ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --primary
  '';
}
