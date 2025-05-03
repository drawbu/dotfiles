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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILu5dP9F77dUgxHpu7drGx/cMpYPRXw0SjsTOr3sLPBZ" # 1password
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHm0udbjVeJed9Bll/gVvOaiHTQdwAp63sbolXXJSLTMAAAABHNzaDo=" # yubikey
    ];
    createHome = true;
  };
}
