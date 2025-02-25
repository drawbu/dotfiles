{ pkgs, ... }:
{
  home-manager.users.clement = import ../../home/clement;

  users.users.clement = {
    isNormalUser = true;
    initialPassword = "hello";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "libvirtd"
      "openrazer"

      # ↓ kanata
      "input"
      "uinput"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmBhcZtmRfwnZJSQ9vxBecGlXDzQbWeCcvfRAcEK9FO"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICieMi8TQag5eoIJXFQbXic8YCeRMdpIw/8d8KeuxSD7"
    ];
    createHome = true;
  };
}
