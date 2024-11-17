{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./home-assistant.nix
    ./plex.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "waffle";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";

  nix.settings.trusted-users = [ "@wheel" ];

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
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

  # SSH server
  services.openssh.enable = true;

  # Don't forget to set a password with ‘passwd’.
  users.users.clement = {
    isNormalUser = true;
    description = "clement";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmBhcZtmRfwnZJSQ9vxBecGlXDzQbWeCcvfRAcEK9FO"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICieMi8TQag5eoIJXFQbXic8YCeRMdpIw/8d8KeuxSD7"
    ];
    createHome = false;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    lazygit
    wget
    neofetch
    tmux
  ];
  environment.shellAliases.lz = "lazygit";

  services.technitium-dns-server = {
    enable = true;
    package = pkgs.unstable.technitium-dns-server;
    openFirewall = true;
  };
}
