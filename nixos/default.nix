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
    systemPackages =
      with pkgs;
      [ podman-compose ] ++ lib.optionals config.mod.profiles.desktop.enable [ virt-manager ];

    etc = {
      issue.source = ./issue.txt;
      motd.text = ''
        Welcome on NixOS/${config.networking.hostName}
      '';
    };
  };
  users.motdFile = "/etc/motd";
  # boot.initrd.preDeviceCommands = ''
  #   cat ${./issue.txt}
  # '';

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.systemd-run0 = {
      setEnvironment = true;
      pamMount = false;
    };
  };

  # TODO: Remove once repology.org domain is restored.
  # https://github.com/repology/repology-rs/issues/560#issuecomment-5688655540
  networking.hosts = {
    "92.63.176.157" = [ "repology.org" ];
    "2a03:6f01:1:2::f159" = [ "repology.org" ];
  };
}
