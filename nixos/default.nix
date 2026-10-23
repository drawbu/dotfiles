{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./gaming.nix
    ./base.nix
    ./graphical
  ];

  time.hardwareClockInLocalTime = true;

  programs = {
    dconf.enable = true;
    virt-manager.enable = config.mod.profiles.desktop.enable;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  services.tailscale.enable = true;

  services.resolved.enable = true;

  virtualisation = {
    libvirtd.enable = config.mod.profiles.desktop.enable;

    docker.enable = false;
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };

  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = true;
    wifi.macAddress = "stable";
    ethernet.macAddress = "stable";
  };

  # this service sucks
  systemd.services.NetworkManager-wait-online = {
    serviceConfig.ExecStart = [
      ""
      "${lib.getExe' pkgs.networkmanager "nm-online"} -q"
    ];
  };

  environment = {
    etc = {
      issue.source = ./issue.txt;
      motd.text = ''
        Welcome on NixOS/${config.networking.hostName}
      '';
    };
  };
  users.motdFile = "/etc/motd";

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.systemd-run0 = {
      setEnvironment = true;
      pamMount = false;
    };
  };


  security.pki.caCertificateBlacklist = [
    "emSign ECC Root CA - G3"
    "emSign ECC Root CA - C3"
    "emSign Root CA - C1"
    "emSign Root CA - G1"
  ];
}
