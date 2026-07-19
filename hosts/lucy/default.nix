{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  networking.hostName = "lucy";
  system.stateVersion = "26.05";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Graphical boot splash + clean LUKS passphrase prompt. Plymouth's
  # systemd-ask-password integration relies on the systemd-based initrd.
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
  boot.kernelParams = [ "quiet" ];

  home-manager.users.clement =
    { pkgs, ... }:
    {
      imports = [ ../../home/clement/linux.nix ];
      home = {
        stateVersion = config.system.stateVersion;
        # pointerCursor.size = lib.mkForce 16;
        packages = with pkgs; [ framework-tool ];
      };
    };

  environment.sessionVariables = {
    GDK_SCALE = "1"; # GDK 3 does not support fractional scaling; really should be 1.5
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
  };

  services.xserver.xkb.layout = lib.mkForce "us_qwerty-fr";
  hardware.framework.laptop13.audioEnhancement.enable = true;
  boot.loader.grub.useOSProber = true;

  zramSwap.enable = true;
  services.fwupd.enable = true;
  programs.nh.clean.enable = lib.mkForce false;

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
}
