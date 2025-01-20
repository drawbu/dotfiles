{
  pkgs,
  graphical,
  config,
  ...
}:
{
  imports = (pkgs.lib.optionals graphical [ ./graphical ]) ++ [ ./nix.nix ];

  system.copySystemConfiguration = false;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    command-not-found.enable = true;
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    zsh.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  virtualisation = {
    libvirtd.enable = true;

    docker.enable = false;
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };

  networking.networkmanager.enable = true;

  # this service sucks
  systemd.services.NetworkManager-wait-online = {
    serviceConfig.ExecStart = [
      ""
      "${pkgs.lib.getExe' pkgs.networkmanager "nm-online"} -q"
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      vim
      wget
      virt-manager
      nix-alien
      podman-compose
    ];
    pathsToLink = [ "/share/nix-direnv" ];

    etc = {
      issue.source = ./issue.txt;
      motd.text = ''
        Welcome on NixOS/${config.networking.hostName}
      '';
    };
  };
  users.motdFile = "/etc/motd";
  boot.initrd.preDeviceCommands = ''
    cat ${./issue.txt}
  '';

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    # sudo.enable = false;
    pam.services.systemd-run0 = {
      setEnvironment = true;
      pamMount = false;
    };
  };
}
