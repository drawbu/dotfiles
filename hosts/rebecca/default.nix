{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./home-assistant
    ./atuin.nix
    ./caddy.nix
    ./jellyfin.nix
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rebecca";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.bluetooth.enable = true;

  system.stateVersion = "24.05";
  home-manager.users.clement.home.stateVersion = config.system.stateVersion;

  # Containers here are long-lived, so keep more than the shared week of roots.
  programs.nh.clean.extraArgs = lib.mkForce "--keep-since 30d";
  nix.optimise.dates = [ "03:45" ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  console.keyMap = "fr";

  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  users.users.clement.extraGroups = [ "podman" ];

  # Kept out of home-manager so root has them too.
  environment.systemPackages = with pkgs; [
    git
    lazygit
  ];
  environment.shellAliases.lz = "lazygit";

  hardware.enableRedistributableFirmware = true;
  boot = {
    blacklistedKernelModules = [ "i915" ];
    kernelParams = [ "nomodeset" ];
  };

  services.onepassword-secrets = {
    enable = true;

    # sudo opnix token set
    # sudo chmod 640 /etc/opnix-token
    # sudo chown root:onepassword-secrets /etc/opnix-token
    tokenFile = "/etc/opnix-token";
  };
}
