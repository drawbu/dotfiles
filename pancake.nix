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
  
  # Git signing
  home-manager.users.clement.programs.git.signing = {
    key = "6e7293f5e7427602";
    signByDefault = true;
  };

  services = {
    thermald.enable = true;
    upower.enable = true;

    # idk intel hardware is borken
    xserver.videoDrivers = [ "modesetting" ];
  };

  # Hardware acceleration
  hardware.opengl.enable = true;
}
