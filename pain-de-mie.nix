# My config for NixOS on my home PC
# The name: pain-de-mie
{ ... }:
{
  imports = [
    ./nixos/hardware/hardware-pain-de-mie.nix
    ./nixos
    ./nixos/graphical
  ];

  networking.hostName = "pain-de-mie";

  # nvidia, fuck you
  hardware.opengl.enable = true;
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    libinput.enable = true;
    windowManager.qtile.enable = true;
  };
}
