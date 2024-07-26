{pkgs, ...}: {
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

      # ↓ kanata
      "input"
      "uinput"
    ];
    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF clement2104.boillot@gmail.com''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH9KSzBv3mfRAq7tOOU6/J9htV/+UTwro8q/JkO97HwO clement2104.boillot@gmail.com''
    ];
    createHome = true;
  };
}
