# My config for NixOS on a VPS Contabo
# The name: croissant
{ ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./nixos/hardware/hardware-croissant.nix
    ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "croissant";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF clement2104.boillot@gmail.com''
  ];
}
