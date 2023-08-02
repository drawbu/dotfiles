# My config for NixOS on a VPS Contabo
# The name: croissant
{ pkgs, ... }: {
  imports = [
    ./nixos/hardware/hardware-croissant.nix
    ./nixos
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking = {
    hostName = "croissant";
    domain = "";
  };

  services.openssh.enable = true;

  home-manager.users.clement = import ./home/clement;
  users.users = {
    clement = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "docker" "networkmanager" "libvirtd" "wheel" ];
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF clement2104.boillot@gmail.com''
      ];
    };

    root = {
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF clement2104.boillot@gmail.com''
      ];
    };
  };
}
