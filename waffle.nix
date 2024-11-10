{ pkgs, ... }:
{
  imports = [ ./nixos/hardware/hardware-waffle.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "waffle";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";

  nix.settings.trusted-users = [ "@wheel" ];

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  console.keyMap = "fr";

  # SSH server
  services.openssh.enable = true;

  # Don't forget to set a password with ‘passwd’.
  users.users.clement = {
    isNormalUser = true;
    description = "clement";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmBhcZtmRfwnZJSQ9vxBecGlXDzQbWeCcvfRAcEK9FO"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICieMi8TQag5eoIJXFQbXic8YCeRMdpIw/8d8KeuxSD7"
    ];
    createHome = false;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    lazygit
    wget
    neofetch
    tmux
  ];
  environment.shellAliases.lz = "lazygit";

  services.technitium-dns-server = {
    enable = true;
    package = pkgs.unstable.technitium-dns-server;
    openFirewall = true;
  };

  services.home-assistant = {
    enable = true;
    package = pkgs.unstable.home-assistant;
    openFirewall = true;
    extraComponents = [
      "isal"
      "mobile_app"
      "default_config"

      "ffmpeg"
      "sensor"
      "history"
      "recorder"
      "history_stats"
      "logbook"

      "freebox"
      "esphome"
      "homekit"
      "homekit_controller"
      "hue"
      "tradfri"
      "weatherkit"
      "met"
      "bring"
      "plex"
      "sonarr"
    ];
    extraPackages =
      p: with p; [
        zlib-ng
        pyatv # apple_tv
        python-otbr-api
      ];
    customComponents = [
      (pkgs.unstable.buildHomeAssistantComponent rec {
        owner = "Amateur-God";
        domain = "technitiumdns";
        version = "2.3.0";
        propagatedBuildInputs = with pkgs.unstable.python312Packages; [ aiohttp ];
        src = pkgs.fetchFromGitHub {
          owner = "Amateur-God";
          repo = "home-assistant-technitiumdns";
          rev = "v${version}";
          hash = "sha256-WzuBYT+BDYHQx8PqhsgZrE5xCgTdKrSLF3N8Zdv94wo=";
        };
      })
    ];
    configWritable = true;
    config = {
      # default_config = {}; # TODO: fix
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "Europe/Paris";
      };
      isal = {};
      mobile_app = {};
      ffmpeg = {};
      sensor = {};
      history = {};
      recorder = {};
      logbook = {};
    };
  };

  networking.firewall.allowedTCPPorts = [ 21064 ]; # homekit

  # Plex
  services.plex = {
    enable = true;
    openFirewall = true;
    extraScanners = with pkgs; [
      sonarr
      radarr
    ];
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
  };
}
