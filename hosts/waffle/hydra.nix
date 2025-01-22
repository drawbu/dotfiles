{ config, ... }:
{
  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.drawbu.dev";
    notificationSender = "hydra@drawbu.dev";
    buildMachinesFiles = [ "/etc/nix/machines" ];
    useSubstitutes = true;
    minimumDiskFreeEvaluator = 50;
  };

  networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];

  users.users.hydra.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmBhcZtmRfwnZJSQ9vxBecGlXDzQbWeCcvfRAcEK9FO"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICieMi8TQag5eoIJXFQbXic8YCeRMdpIw/8d8KeuxSD7"
  ];

  nix.buildMachines = [
    {
      hostName = "localhost";
      protocol = null;
      system = "x86_64-linux";
      supportedFeatures = [
        "kvm"
        "nixos-test"
        "big-parallel"
        "benchmark"
      ];
      maxJobs = 8;
    }
  ];

  nix.settings.allowed-uris = [
    "github:"
    "git+https://github.com/"
    "git+ssh://github.com/"
  ];

  services.nix-serve = {
    enable = true;
    openFirewall = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };
}
