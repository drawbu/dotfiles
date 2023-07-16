{ config, pkgs, ... }:
{
  imports = [
    ./issue
    ./hardware-configuration.nix
    ./polkit.nix
  ];

  hardware.opengl.enable = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      gfxmodeEfi = "1920x1080x32";
      useOSProber = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    optimise.automatic = true;
  };

  environment.pathsToLink = [ "/share/nix-direnv" ];
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (self: super: {
        nix-direnv = super.nix-direnv.override {
          enableFlakes = true;
        };
      })
    ];
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # File manager
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    zsh.enable = true;
  };

  services = {
    # For the file manager
    gvfs.enable = true;
    tumbler.enable = true;

    # Compositor
    picom = {
      enable = true;
      fade = true;
    };

    # Sounds
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Graphical
    xserver = {
      enable = true;
      displayManager = {
        startx.enable = true;
        setupCommands = ''
          ${pkgs.xlibs.xrandr}/bin/xrandr --output HDMI-0 --primary --output DVI-D-0 --right-of HDMI-0
        '';
      };
      layout = "fr";
      # nvidia, fuck you
      videoDrivers = [ "nvidia" ];
      libinput.enable = true;
      windowManager.qtile.enable = true;
    };

    # SSH
    openssh.enable = true;
  };


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };


  users.users.clement = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "docker" "networkmanager" "libvirtd" "wheel" ];
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      libsForQt5.plasma-nm
      modemmanager
      networkmanagerapplet
      git
      btop
      tree
      vim
      wget
    ];
  };

  system = {
    copySystemConfiguration = false;
    stateVersion = "23.05";
  };
}
