# My config for NixOS on my laptop
# The name: pancake
{ ... }:
{
  imports = [
    ./nixos/hardware/hardware-pancake.nix
    ./nixos
    ./nixos/graphical
    ./nixos/users/clement.nix
  ];

  networking.hostName = "pancake";
  system.stateVersion = "23.05";

  # Git signing
  home-manager.users.clement.programs.git.signing = {
    key = "005280E9B819AECF";
    signByDefault = true;
  };

  services = {
    thermald.enable = true; # thermal daemon
    power-profiles-daemon.enable = false; # disable power thing from Gnome
    fprintd.enable = true;

    # idk intel hardware is borken
    xserver.videoDrivers = [ "intel" ];
  };

  # Hardware acceleration
  hardware.opengl.enable = true;

}
