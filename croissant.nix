# My config for NixOS on a VPS Contabo
# The name: croissant
{ ... }: {
  imports = [
    ./nixos/hardware/hardware-croissant.nix
    ./nixos
  ];

  networking.hostName = "croissant";

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
}
