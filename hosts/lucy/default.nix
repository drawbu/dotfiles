{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../nixos
    ../../nixos/users/clement.nix
    ./hardware.nix
  ];

  networking.hostName = "lucy";
  system.stateVersion = "26.05";

  # 7.4 carries the mt7925 MLO roaming and reset fixes.
  boot.kernelPackages = pkgs.linuxPackages_testing;
  assertions = [
    {
      assertion = lib.versionOlder pkgs.linuxPackages_latest.kernel.version "7.4";
      message = "linuxPackages_latest reached 7.4: move lucy back to it.";
    }
  ];

  home-manager.users.clement = {
    imports = [ ../../home/clement/linux.nix ];
    home.stateVersion = config.system.stateVersion;
    programs.nh.clean.enable = false;
  };

  environment.sessionVariables = {
    GDK_SCALE = "1"; # GDK 3 does not support fractional scaling; really should be 1.5
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
  };

  hardware.framework.laptop13.audioEnhancement.enable = true;

  programs.gamescope.args = [
    "-W"
    "2880"
    "-H"
    "1920"
    "-r"
    "120"
    "-F"
    "fsr"
  ];

  # simpledrm claims card0 before amdgpu binds, so the iGPU is card1.
  programs.gamemode.settings.gpu = {
    apply_gpu_optimisations = "accept-responsibility";
    gpu_device = 1;
    amd_performance_level = "high";
  };

  boot.loader.grub.useOSProber = true;

  zramSwap.enable = true;

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
}
