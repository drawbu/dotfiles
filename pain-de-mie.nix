# My config for NixOS on my PC
# The name: pain-de-mie
{ pkgs, ... }:
{
  imports = [
    ./nixos
    ./nixos/hardware/hardware-pain-de-mie.nix
  ];

  home-manager.users.clement = import ./home/clement;
  users.users.clement = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "docker" "networkmanager" "libvirtd" "wheel" ];
  };

  hardware.opengl.enable = true;

  networking = {
    hostName = "pain-de-mie";
    networkmanager.enable = true;
  };

  # nvidia, fuck you
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    libinput.enable = true;
    windowManager.qtile.enable = true;
  };
}
