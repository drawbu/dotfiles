{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./tailscale.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "pineapple";

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11";

  nix = {
    settings.trusted-users = [ "@wheel" ];
    optimise.automatic = true;
    gc.automatic = true;
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.clement = {
    isNormalUser = true;
    description = "clement";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmBhcZtmRfwnZJSQ9vxBecGlXDzQbWeCcvfRAcEK9FO"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICieMi8TQag5eoIJXFQbXic8YCeRMdpIw/8d8KeuxSD7"
    ];
    createHome = false;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    tmux
  ];

  services.caddy = {
    enable = true;
    email = "letsencrypt@drawbu.dev";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
