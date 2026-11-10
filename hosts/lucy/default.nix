{ config, pkgs, ... }:
{
  imports = [
    ../../nixos
    ../../nixos/users/clement.nix
    ./hardware.nix
  ];

  networking.hostName = "lucy";
  system.stateVersion = "26.05";

  # TODO: mt7925 MLO roaming fails the 4-way handshake and resets leave TX
  #       blocked; drop the mainline fixes once on 7.4, the ROC one once
  #       openwrt/mt76#1143 lands.
  boot.kernelPatches =
    let
      mainline = name: id: hash: {
        inherit name;
        patch = pkgs.fetchpatch {
          name = "${name}.patch";
          url = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=${id}";
          inherit hash;
        };
      };
    in
    [
      (mainline "mt7925-mld-link-add" "dd3f17ef69ed6d0085cd94a15b9dec227b4ebfb1"
        "sha256-rZnY+P8DMikjLLe++frlzzdsu1A7G6gDMWxeGckmt+g="
      )
      (mainline "mt7925-reset-drv-pmctrl" "d12a54be2604ecd23a1e9ac863583e34034aadde"
        "sha256-0nhLmepbZpeJesCgo2dnGV/C9rCvH5YV9cQZvY3OXWc="
      )
      (mainline "mt7925-reset-fw-pmctrl" "8d2f5990cd429a2fe5fff05f7acf84d6799d4324"
        "sha256-BCHCRBU48VOfE2vkYJTPc5Q+GhNyvHxNDsCTo02wACM="
      )
      {
        name = "mt7925-join-roc-release";
        patch = pkgs.fetchpatch {
          name = "mt7925-join-roc-release.patch";
          url = "https://github.com/openwrt/mt76/commit/0f6b49e56e2d85297bcdc94dfa8fbb266505883d.patch";
          stripLen = 1;
          extraPrefix = "drivers/net/wireless/mediatek/mt76/";
          hash = "sha256-eixoDhJTI5VXEPII+hwL77kYsnt6seMQvK3iByXcAAA=";
        };
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
